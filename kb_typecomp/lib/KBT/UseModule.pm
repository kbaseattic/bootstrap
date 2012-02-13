package KBT::UseModule;

use Moose;

has 'module_name' => (isa => 'Str', is => 'rw');

sub as_string
{
    my($self) = @_;
    return join(" ", "use", 'module', $self->module_name, ';');

}

1;
