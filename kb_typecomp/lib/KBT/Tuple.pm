package KBT::Tuple;

use Moose;

has 'element_types' => (is => 'rw');

sub as_string
{
    my($self) = @_;
    return "tuple<" . join(", ", map { $_->as_string } @{$self->element_types} ) . ">";
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];
    for my $type (@{$self->element_types})
    {	
	push(@$out, @{$type->subtypes($seen)});
    }

    return $out;
}

sub english
{
    my($self, $indent) = @_;
    
    my $n = @{$self->element_types};
    my $eng = "a reference to a list containing $n items:\n";
    my $i = 0;
    for my $ent (@{$self->element_types})
    {
	my $item_eng = $ent->english($indent + 1);
	$eng .= "\t" x $indent. "$i: $item_eng\n";
	$i++;
    }
    return $eng;
}

1;
