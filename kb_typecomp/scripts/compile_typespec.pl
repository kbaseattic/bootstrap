use typedoc;
use strict;
use POSIX;
use Data::Dumper;
use Template;
use File::Slurp;
use KBT;
use Getopt::Long;

my $scripts_dir;

my $rc = GetOptions("scripts=s" => \$scripts_dir);

($rc && @ARGV >= 2) or die "Usage: $0 [--scripts script-dir] typespec [typespec...] output-dir\n";

my $dir = pop;
my @spec_files = @ARGV;

if ($scripts_dir && ! -d $scripts_dir)
{
    die "Script output directory $scripts_dir does not exist\n";
}

my $parser = typedoc->new();

#
# Read and parse all the given documents. We collect all documents
# that comprise each service, and process the services as units.
#

my %services;

my $errors_found;

for my $spec_file (@spec_files)
{
    my $txt = read_file($spec_file) or die "Cannot read $spec_file: $!";
    my($modules, $errors) = $parser->parse($txt, $spec_file);
    my $type_info = assemble_types($parser);
    if ($errors)
    {
	print "$errors errors were found in $spec_file\n";
	$errors_found += $errors;
    }
    for my $mod (@$modules)
    {
	my $mod_name = $mod->module_name;
	my $serv_name = $mod->service_name;
	print "$spec_file: module $mod_name service $serv_name\n";
	push(@{$services{$serv_name}}, [$mod, $type_info, $parser->YYData->{type_table}]);
    }
}
if ($errors_found)
{
    exit 1;
}
#print Dumper(\%services);

while (my($service, $modules) = each %services)
{
    write_service_stubs($service, $modules, $dir);
}

=head2 write_service_stubs

Given one more more modules that implement a service, write a single
psgi, client and service stub for the service, and one impl stub per module.

The service stubs include a mapping from the function name in a module
to the impl module for that function.

=cut

sub write_service_stubs
{
    my($service, $modules, $dir) = @_;

    my $tmpl = Template->new( { OUTPUT_PATH => $dir,
				ABSOLUTE => 1,
			      });

    my %service_options;

    my @modules;
    
    for my $module_ent (@$modules)
    {
	my($module, $type_info, $type_table) = @$module_ent;
	
	$service_options{$_} = 1 foreach @{$module->options};

	my $data = compute_module_data($module, $type_info, $type_table);

	push(@modules, $data);
    }

    my $client_package_name = $service . "Client";
    my $server_package_name = $service . "Server";

    my $vars = {
	client_package_name => $client_package_name,
	server_package_name => $server_package_name,
	service_name => $service,
	modules => \@modules,
	service_options => \%service_options,
    };

    my $tmpl_dir = KBT->install_path;

    $tmpl->process("$tmpl_dir/client_stub.tt", $vars, "$client_package_name.pm") || die Template->error;
    $tmpl->process("$tmpl_dir/server_stub.tt", $vars, "$server_package_name.pm") || die Template->error;
    $tmpl->process("$tmpl_dir/psgi_stub.tt", $vars, $service . ".psgi") || die Template->error;

    for my $module_ent (@$modules)
    {
	my($module, $type_info) = @$module_ent;

	write_module_stubs($service, $module, $type_info, $vars, $dir);
    }
}

sub compute_module_data
{
    my($module, $type_info, $type_table) = @_;

    my $doc = $module->comment;
    $doc =~ s/^\s*\*\s?//mg;
    
    my $impl_package_name = $module->module_name . "Impl";

    my %saved_stub;
    my $saved_header;
    my $saved_const;

    my $impl_file = "$dir/$impl_package_name.pm";
    if (open(my $fh, "<", $impl_file))
    {
	#
	# Collect old client implementation code.
	#
	my $cur_rtn;
	my $cur_hdr;
	my $cur_const;
	while (<$fh>)
	{
	    if (/^\s*\#BEGIN\s+(\S+)/)
	    {
		$cur_rtn = $1;
	    }
	    elsif (/^\s*\#END\s+(\S+)/)
	    {
		undef $cur_rtn;
	    }
	    elsif ($cur_rtn)
	    {
		$saved_stub{$cur_rtn} .= $_;
	    }
	    elsif (/^\s*\#BEGIN_HEADER\s*$/)
	    {
		$cur_hdr = 1;
	    }
	    elsif (/^\s*\#END_HEADER\s*$/)
	    {
		$cur_hdr = 0;
	    }
	    elsif (/^\s*\#BEGIN_CONSTRUCTOR\s*$/)
	    {
		$cur_const = 1;
	    }
	    elsif (/^\s*\#END_CONSTRUCTOR\s*$/)
	    {
		$cur_const = 0;
	    }
	    elsif ($cur_hdr)
	    {
		$saved_header .= $_;
	    }
	    elsif ($cur_const)
	    {
		$saved_const .= $_;
	    }
	}
	close($fh);
    }

    my $methods = [];

    my $vars = {
	impl_package_name => $impl_package_name,
	module_name => $module->module_name,
	module => $module,
	module_doc => $doc,
	methods => $methods,
	types => $type_info,
	module_header => $saved_header,
	module_constructor => $saved_const,
    };

    for my $comp (@{$module->module_components})
    {
	next unless $comp->isa('KBT::Funcdef');

	my $params = $comp->parameters;
	my @args;
	my %ncount;

	for my $i (0..$#$params)
	{
	    my $p = $params->[$i];

	    my $name;
	    if ($p->{name})
	    {
		$name = $p->{name};
	    }
	    else
	    {
		#
		# if we didn't pass in a name, and if
		# this parameter is a typedef, use the type name.
		#
		if (ref($p->{type}) && $p->{type}->can('alias_type'))
		{
		    $name = $p->{type}->name;
		}
		else
		{
		    $name = "arg_" . ($i + 1);
		}
	    }
	    push(@args, $name);
	    $ncount{$name}++;
	}

	#
	# Scan args for duplicates and disambiguate.
	#
	for my $argi (0..$#args)
	{
	    if ($ncount{$args[$argi]} > 1)
	    {
		$args[$argi] .= "_" . ($argi + 1);
	    }
	}
	#
	# Generate english type descriptions.
	#
	my %types_seen;
	my $typenames = [];
	my @english;
	
	for my $argi (0..$#args)
	{
	    my $name = $args[$argi];
	    my $p = $params->[$argi];
	    my $type = $p->{type};
	    my $eng = $type->english(1);
	    my $tn = $type->subtypes(\%types_seen);
	    # print "arg $argi $type subtypes @$tn\n";
	    push(@$typenames, @$tn);
	    push(@english, "\$$name is $eng");
	}

	my $args = join(", ", @args);
	my $arg_vars = join(", ", map { "\$$_" } @args);

	my $returns = $comp->return_type;
	
	my @rets;

	if (@$returns == 1)
	{
	    my $p = $returns->[0];
	    my $name = $p->{name} // "return";
	    push(@rets, $name);
	    my $tn = $p->{type}->subtypes(\%types_seen);
	    push(@$typenames, @$tn);
	    my $eng = $p->{type}->english(1);
	    push(@english, "\$$name is $eng");
	}
	else
	{
	    for my $i (0..$#$returns)
	    {
		my $p = $returns->[$i];
		my $name = $p->{name} // "return_" . ($i + 1);
		push(@rets, $name);
		my $tn = $p->{type}->subtypes(\%types_seen);
		push(@$typenames, @$tn);
		my $eng = $p->{type}->english(1);
		push(@english, "\$$name is $eng");
	    }
	}
	my $rets = join(", ", @rets);
	my $ret_vars = join(", ", map { "\$$_" } @rets);

	for my $tn (@$typenames)
	{
	    my $type = $type_table->{$tn};
	    if (!defined($type))
	    {
		die "Type $tn is not defined in module " . $module->module_name . "\n";
	    }

	    push(@english, "$tn is " . $type->alias_type->english(1));
	}
	
	my $doc = $comp->comment;
	$doc =~ s/^\s*\*\s?//mg;

	chomp @english;

	my $meth = {
	    name => $comp->name,
	    arg_doc => [grep { !/^\s*$/ } @english],
	    doc => $doc,
	    args => $args,
	    arg_vars => $arg_vars,
	    rets => $rets,
	    ret_vars => $ret_vars,
	    arg_count => scalar @args,
	    user_code => $saved_stub{$comp->name},
	};
	push(@$methods, $meth);
    }
    
    return $vars;
}

sub write_module_stubs
{
    my($service, $module, $type_info, $vars, $dir) = @_;

    my($my_module) = grep { $_->{module_name} eq $module->module_name } @{$vars->{modules}};
    
    my $tmpl = Template->new( { OUTPUT_PATH => $dir,
				ABSOLUTE => 1,
			      });

    my $tmpl_dir = KBT->install_path;

    my $impl_file = "$dir/$my_module->{impl_package_name}.pm";
    if (-f $impl_file)
    {
	my $ts = strftime("%Y-%m-%d-%H-%M-%S", localtime);
	my $bak = "$impl_file.bak-$ts";
	rename($impl_file, $bak);
    }

    my $mvars = {
	%$vars,
	module => $my_module,
    };

    open(IM, ">", $impl_file) or die "Cannot write $impl_file: $!";
    $tmpl->process("$tmpl_dir/impl_stub.tt", $mvars, \*IM) || die Template->error;
    close(IM);

    if ($scripts_dir)
    {
	for my $method (@{$vars->{modules}->{$module}->{methods}})
	{
	    my %d = %$vars;
	    $d{method} = $method;
	    my $name = $method->{name};

	    my $fh;
	    if (!open($fh, ">", "$scripts_dir/$name.pl"))
	    {
		die "Cannot write $scripts_dir/$name.pl: $!";
	    }
	    
	    $tmpl->process("$tmpl_dir/api_script.tt", \%d, $fh) || die Template->error;
	}
    }
}

sub assemble_types
{
    my($parser) = @_;

    my $types = [];

    for my $type (@{$parser->types()})
    {
	my $name = $type->name;
	my $ref = $type->alias_type;
	my $eng = $ref->english(0);
	push(@$types, {
	    name => $name,
	    ref => $ref,
	    english => $eng,
	    comment => $type->comment,
	     });
    }
    return $types;
}
