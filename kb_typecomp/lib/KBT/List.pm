package KBT::List;

use Moose;

has 'element_type' => (is => 'rw');

sub as_string
{
    my($self) = @_;
    return "list<" . $self->element_type->as_string . ">";
}

sub english
{
    my($self, $indent) = @_;

    my $value_eng = $self->element_type->english($indent);
    return "a reference to a list where each element is $value_eng";
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];
    for my $type ($self->element_type)
    {	
	push(@$out, @{$type->subtypes($seen)});
    }

    return $out;
}



1;
