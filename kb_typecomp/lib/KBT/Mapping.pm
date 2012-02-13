package KBT::Mapping;

use Moose;

has 'key_type' => (is => 'rw');
has 'value_type' => (is => 'rw');

sub as_string
{
    my($self) = @_;
    return "mapping<" . $self->key_type->as_string . "," . $self->value_type->as_string . ">";
}

sub english
{
    my($self, $indent) = @_;

    my $key_eng = $self->key_type->english($indent);
    my $value_eng = $self->value_type->english($indent);
    return "a reference to a hash where the key is $key_eng and the value is $value_eng";
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];
    for my $type ($self->key_type, $self->value_type)
    {	
	push(@$out, @{$type->subtypes($seen)});
    }

    return $out;
}
1;
