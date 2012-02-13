package KBT::StructItem;

use Moose;
use Data::Dumper;

has 'item_type' => (is => 'rw');
has 'name' => (is => 'rw', isa => 'Str');
has 'nullable' => (is => 'rw', isa => 'Bool');
has 'mutable' => (is => 'rw', isa => 'Bool');

sub as_string
{
    my($self) = @_;
    return join(" ", $self->item_type->as_string, $self->name, $self->attribs);
}

sub attribs
{
    my($self) = @_;
    my @out;
    push(@out, 'nullable') if $self->nullable;
    push(@out, 'mutable') if $self->mutable;
    return @out;
}

sub subtypes
{
    my($self, $seen) = @_;
    my $out = [];
    push(@$out, @{$self->item_type->subtypes($seen)});

    return $out;
}
1;
