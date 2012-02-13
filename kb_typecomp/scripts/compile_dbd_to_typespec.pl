use strict;
use Data::Dumper;
use XML::LibXML;
#use String::CamelCase 'decamelize';
use Template;
use KBT;

@ARGV == 5 or die "Usage: $0 module-name DBD-xml-file spec-file impl-file bin-dir\n";

my $module = shift;
my $in_file = shift;
my $out_file = shift;
my $impl_file = shift;
my $bin_dir = shift;

-d $bin_dir or die "bin-dir $bin_dir does not exist\n";

my $doc = XML::LibXML->new->parse_file($in_file);
$doc or die "cannot parse $in_file\n";

open(OUT, ">", $out_file) or die "cannot write $out_file: $!";
open(IMPL, ">", $impl_file) or die "cannot write $impl_file: $!";

my %type_map = (boolean	    => 'int',
		char	    => 'string',
		countVector => 'countVector',
		counter	    => 'int',
		date	    => 'string',
		diamond	    => 'diamond',
		dna	    => 'string',
		float	    => 'float',
		image	    => 'string',
		int	    => 'int',
		link	    => 'string',
		rectangle   => 'rectangle',
		string	    => 'string',
		text	    => 'string',
		);

print OUT "module $module {\n";
print OUT "typedef string diamond;\n";
print OUT "typedef string countVector;\n";
print OUT "typedef string rectangle;\n";
print OUT "\n";

my %kids;
my %rel_printed;

for my $r ($doc->findnodes('//Relationships/Relationship'))
{
    my $n = $r->getAttribute("name");
    my $arity = $r->getAttribute("arity");
    my $from = $r->getAttribute("from");
    my $to = $r->getAttribute("to");
    my $converse = $r->getAttribute("converse");

    push(@{$kids{$from}}, $r);
}

my $entities = [];
my $relationships = [];
my $template_data = {
    entities => $entities,
    relationships => $relationships,
    module => $module,
};

for my $e (sort { $a->getAttribute("name") cmp $b->getAttribute("name") }  $doc->findnodes('//Entities/Entity'))
{
    my $n = $e->getAttribute("name");
    my @cnode = $e->getChildrenByTagName("Notes");
    my $com = join("\n", map { my $s = $_->textContent; $s =~ s/^\s*//gm; $s } @cnode);

    # my $nn = decamelize($n);
    my $nn = $n;

    my $field_map = [];

    my $edata = {
	name => $nn,
	sapling_name => $n,
	field_map => $field_map,
    };
    push(@$entities, $edata);

    my @fields = $e->findnodes('Fields/Field');
    # next if @fields == 0;

    print OUT "typedef structure {\n";
    print OUT "\tstring id;\n";

    $com .= "\nIt has the following fields:\n\n=over 4\n\n";
    for my $f (@fields)
    {
	my $fn = $f->getAttribute("name");
	# my $fnn = decamelize($fn);
	my $fnn = $fn;

	$fnn =~ s/-/_/g;

	push(@$field_map, { name => $fnn, sapling_name => $fn });
	
	my $ftype = $type_map{$f->getAttribute("type")};

	print OUT "\t$ftype $fnn nullable;\n";

	my @fcnode = $f->getChildrenByTagName("Notes");
	my $fcom = join("\n", map { my $s = $_->textContent; $s =~ s/^\s*//gm; $s } @fcnode);

	$com .= "\n=item $fnn\n\n$fcom\n\n";
    }

    $edata->{field_list} = join(", ", map { "'$_->{name}'" } @$field_map);
    $com .= "\n\n=back\n\n";
    print OUT "} fields_$nn ;\n";
    print OUT "\n";
    print OUT "/*\n$com\n*/\n";
    print OUT "funcdef get_entity_$nn(list<string> ids, list<string> fields)\n";
    print OUT "\treturns(mapping<string, fields_$nn>);\n";
    print OUT "funcdef all_entities_$nn(int start, int count, list<string> fields)\n";
    print OUT "\treturns(mapping<string, fields_$nn>);\n";
    print OUT "\n";
}

for my $e (sort { $a->getAttribute("name") cmp $b->getAttribute("name") }  $doc->findnodes('//Relationships/Relationship'))
{
    my $n = $e->getAttribute("name");
    my $from = $e->getAttribute("from");
    my $to = $e->getAttribute("to");
    my $converse = $e->getAttribute("converse");
    
    my @cnode = $e->getChildrenByTagName("Notes");
    my $com = join("\n", map { my $s = $_->textContent; $s =~ s/^\s*//gm; $s } @cnode);

    # my $nn = decamelize($n);
    my $nn = $n;

    my $field_map = [];

    my $edata = {
	name => $nn,
	sapling_name => $n,
	field_map => $field_map,
	relation => $nn,
	is_converse => 0,
	from => $from,
	to => $to,
    };
    push(@$relationships, $edata);

    push(@$relationships, {
	name => $converse,
	sapling_name => $converse,
	relation => $nn,
	is_converse => 1,
	field_map => $field_map,
	from => $to,
	to => $from,
    });

    my @fields = $e->findnodes('Fields/Field');

    print OUT "typedef structure {\n";
    print OUT "\tstring id;\n";

    $com .= "\nIt has the following fields:\n\n=over 4\n\n";
    for my $f (@fields)
    {
	my $fn = $f->getAttribute("name");
	# my $fnn = decamelize($fn);
	my $fnn = $fn;

	$fnn =~ s/-/_/g;

	push(@$field_map, { name => $fnn, sapling_name => $fn });
	
	my $ftype = $type_map{$f->getAttribute("type")};

	print OUT "\t$ftype $fnn nullable;\n";

	my @fcnode = $f->getChildrenByTagName("Notes");
	my $fcom = join("\n", map { my $s = $_->textContent; $s =~ s/^\s*//gm; $s } @fcnode);

	$com .= "\n=item $fnn\n\n$fcom\n\n";
    }

    $edata->{field_list} = join(", ", map { "'$_->{name}'" } @$field_map);
    $com .= "\n\n=back\n\n";
    print OUT "} fields_$nn ;\n";
    print OUT "\n";
    print OUT "/*\n$com\n*/\n";
    print OUT "funcdef get_relationship_$nn(list<string> ids, list<string> from_fields, list<string> rel_fields,  list<string> to_fields)\n";
    print OUT "\treturns(list<tuple<fields_$from, fields_$nn, fields_$to>>);\n";

    print OUT "funcdef get_relationship_$converse(list<string> ids, list<string> from_fields, list<string> rel_fields,  list<string> to_fields)\n";
    print OUT "\treturns(list<tuple<fields_$to, fields_$nn, fields_$from>>);\n";

    print OUT "\n";
}


print OUT "};\n";

my $tmpl_dir = KBT->install_path;

my $tmpl = Template->new({ OUTPUT_PATH => '.',
			       ABSOLUTE => 1,
			   });

for my $entity (@{$entities})
{
    my %d = %$template_data;
    $d{entity} = $entity;
    open(my $fh, ">", "$bin_dir/get_entity_$entity->{name}.pl") or die "cannot write $bin_dir/get_entity_$entity->{name}.pl: $!";
    $tmpl->process("$tmpl_dir/get_entity.tt", \%d, $fh) || die Template->error;
    close($fh);
    open(my $fh, ">", "$bin_dir/all_entities_$entity->{name}.pl") or die "cannot write $bin_dir/all_entities_$entity->{name}.pl: $!";
    $tmpl->process("$tmpl_dir/all_entities.tt", \%d, $fh) || die Template->error;
    close($fh);
}

for my $rel (@{$relationships})
{
    my %d = %$template_data;
    $d{relationship} = $rel;
    open(my $fh, ">", "$bin_dir/get_relationship_$rel->{name}.pl") or die "cannot write $bin_dir/get_relationship_$rel->{name}.pl: $!";
    $tmpl->process("$tmpl_dir/get_relationship.tt", \%d, $fh) || die Template->error;
    close($fh);
}
$tmpl->process("$tmpl_dir/sapling_impl.tt", $template_data, \*IMPL) || die Template->error;
