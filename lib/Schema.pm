package Schema;

use Moo;

has 'bookstore' => (is => 'ro', required => 1);

sub search_object {
    my ($self, $object, $params) = @_;

    my @objects = $self->bookstore->resultset($object)->search($params);
    return wantarray ? @objects : \@objects;
}

sub delete_object {
    my ($self, $object, $id) = @_;

    my $result = $self->bookstore->resultset($object)->search({ id => $id });
    return $result->delete_all;
}

1;
