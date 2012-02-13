package KBT::Struct;

use Moose;
use Data::Dumper;

has 'items' => (isa => 'ArrayRef[KBT::StructItem]',
		is => 'rw');

sub as_string
{
    my($self) = @_;
    return join(" ", "struct", "{", (map { $_->as_string, ";" } @{$self->items}), "}" );
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];

    for my $item (@{$self->items})
    {
	push(@$out, @{$item->subtypes($seen)});
    }
    return $out;
}

sub english
{
    my($self, $indent) = @_;
    
    my $eng = "a reference to a hash where the following keys are defined:\n";
    for my $ent (@{$self->items})
    {
	my $n = $ent->name;
	my $item_eng = $ent->item_type->english($indent);
	$eng .= "\t" x $indent . "$n has a value which is $item_eng\n";
    }
    return $eng;
}

1;
