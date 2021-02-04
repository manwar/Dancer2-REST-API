package Schema::Author;

use Moo;

has id         => (is => 'ro');
has name       => (is => 'rw');
has first_name => (is => 'rw', required => 1);
has last_name  => (is => 'rw', required => 1);
has country    => (is => 'rw', required => 1);

sub BUILD {
    my ($self) = @_;

    $self->{name} = join(' ', $self->{first_name}, $self->{last_name});
}

sub populate {
    my ($self, $schema) = @_;

    my $entries = [ ['first_name', 'last_name', 'country'] ];
    push @$entries, [$self->first_name, $self->last_name, $self->country];

    $schema->bookstore->populate('Author', $entries);
}

1;
