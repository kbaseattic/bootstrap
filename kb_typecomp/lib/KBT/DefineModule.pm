package KBT::DefineModule;

use Moose;

has 'module_name' => (isa => 'Str', is => 'rw');
has 'service_name' => (isa => 'Str', is => 'rw');
has 'module_components' => (isa => 'ArrayRef', is => 'rw');
has 'comment' => (isa => 'Maybe[Str]', is => 'rw');
has 'options' => (isa => 'ArrayRef', is => 'rw');

sub as_string
{
    my($self) = @_;
    return "module " . $self->module_name .
	" {\n\t" . join("\n\t", map { $_->as_string } @{$self->module_components}) . "\n};\n";

}

1;
