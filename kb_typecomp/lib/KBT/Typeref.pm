package KBT::Typeref;

use Moose;

has 'reference_type' => (is => 'rw');

sub as_string
{
    my($self) = @_;
    return $self->reference_type->alias_type->as_string;
}

1;
