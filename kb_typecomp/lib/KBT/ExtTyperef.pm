package KBT::ExtTyperef;

use Moose;

has 'reference_type' => (is => 'rw');

sub as_string
{
    my($self) = @_;
    return $self->reference_type;
}

1;
