package Schema::Book;

use Moo;

has id       => (is => 'ro');
has author   => (is => 'rw', required => 1);
has title    => (is => 'rw', required => 1);
has pub_date => (is => 'rw', required => 1);
has isbn     => (is => 'rw', required => 1);

sub populate {
    my ($self, $schema) = @_;

    my $entries = [ ['author', 'title', 'pub_date', 'isbn'] ];
    push @$entries, [$self->author, $self->title, $self->pub_date, $self->isbn];

    $schema->bookstore->populate('Book', $entries);
}

1;
