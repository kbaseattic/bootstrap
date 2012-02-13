package KBT::Scalar;
use Moose;
use Lingua::EN::Inflect 'A';

use Moose::Util::TypeConstraints;
enum 'ScalarType' => [qw(int float string)];

has 'scalar_type' => (isa => 'ScalarType', is => 'rw');

sub as_string
{
    my($self) = @_;
    return $self->scalar_type;
}

sub english
{
    my($self) = @_;
    return A($self->scalar_type);
}

sub subtypes
{
    return [];
}

1;
