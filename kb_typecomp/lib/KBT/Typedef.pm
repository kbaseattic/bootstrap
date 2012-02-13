package KBT::Typedef;

use Moose;
use Data::Dumper;
use Lingua::EN::Inflect 'A';

has 'alias_type' => (is => 'rw');
has 'name' => (isa => 'Str', is => 'rw');
has 'comment' => (isa => 'Str', is => 'rw');

sub as_string
{
    my($self) = @_;
    return join(" ", "typedef", $self->alias_type->as_string, $self->name) . ";";

}

sub english
{
    my($self) = @_;
    
    return A($self->name);
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];

    if (!$seen->{$self->name})
    {
	push(@$out, $self->name);
	$seen->{$self->name} = 1;
    }
    
    push(@$out, @{$self->alias_type->subtypes($seen)});

    return $out;
}

1;
