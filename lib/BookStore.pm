package BookStore;

use strict;
use warnings;

use Schema;
use Schema::Book;
use Schema::Author;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Serializer::JSON;

=head1 NAME

Programming Exercise - BookStore

=head1 VERSION

Version 0.01

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=cut

$BookStore::VERSION   = '0.01';
$BookStore::AUTHORITY = 'cpan:MANWAR';

set engines => { serializer => { JSON => { pretty => 1 } } };
set serializer => 'JSON';

our $schema = Schema->new({ bookstore => schema 'bookstore' });

#
#
# Routes for Authors

get '/api/authors' => sub { return _authors(); };

get '/api/authors/:id/books' => sub {
    my $id = route_parameters->get('id');

    return _author_books($id);
};

get '/api/authors/:id' => sub {
    my $id = route_parameters->get('id');

    return _author($id);
};

put '/api/authors/:id' => sub {
    my $id         = route_parameters->get('id');
    my $first_name = body_parameters->get('first_name');
    my $last_name  = body_parameters->get('last_name');
    my $country    = body_parameters->get('country');

    my ($author) = $schema->search_object('Author', { id => $id });
    $author->first_name($first_name);
    $author->last_name($last_name);
    $author->country($country);
    $author->update;

    return _author($id);
};

patch '/api/authors/:id' => sub {
    my $id         = route_parameters->get('id');
    my $first_name = body_parameters->get('first_name');
    my $last_name  = body_parameters->get('last_name');
    my $country    = body_parameters->get('country');

    my ($author) = $schema->search_object('Author', { id => $id });
    $author->first_name($first_name) if defined $first_name;
    $author->last_name($last_name)   if defined $last_name;
    $author->country($country)       if defined $country;
    $author->update;

    return _author($id);
};

post '/api/authors' => sub {
    my $first_name = body_parameters->get('first_name');
    my $last_name  = body_parameters->get('last_name');
    my $country    = body_parameters->get('country');

    my $response = Schema::Author->new({
        first_name => $first_name,
        last_name  => $last_name,
        country    => $country,
    })->populate($schema);

    return _author($response->[0]->id);
};

del '/api/authors/:id' => sub {
    my $id = route_parameters->get('id');

    my $books = _author_books($id);
    foreach my $book (@$books) {
        $schema->delete_object('Book', $book->{id});
    }

    $schema->delete_object('Author', $id);

    return _authors();
};

#
#
# Routes for Books

get '/api/books' => sub { return _books(); };

get '/api/books/:id' => sub {
    my $id = route_parameters->get('id');

    return _book($id);
};

put '/api/books/:id' => sub {
    my $id       = route_parameters->get('id');
    my $author   = body_parameters->get('author');
    my $title    = body_parameters->get('title');
    my $pub_date = body_parameters->get('pub_date');
    my $isbn     = body_parameters->get('isbn');

    my ($book) = $schema->search_object('Book', { id => $id });
    return unless defined $book;

    # check if it is valid author
    return unless defined _author($author);

    $book->author($author);
    $book->title($title);
    $book->pub_date($pub_date);
    $book->isbn($isbn);
    $book->update;

    return _book($id);
};

patch '/api/books/:id' => sub {
    my $id       = route_parameters->get('id');
    my $author   = body_parameters->get('author');
    my $title    = body_parameters->get('title');
    my $pub_date = body_parameters->get('pub_date');
    my $isbn     = body_parameters->get('isbn');

    my ($book) = $schema->search_object('Book', { id => $id });
    return unless defined $book;

    # check if it is valid author
    if (defined $author && defined _author($author)) {
        $book->author($author);
    }
    else {
        $book->title($title)       if defined $title;
        $book->pub_date($pub_date) if defined $pub_date;
        $book->isbn($isbn)         if defined $isbn;
        $book->update;
    }

    return _book($id);
};

post '/api/books' => sub {
    my $author   = body_parameters->get('author');
    my $title    = body_parameters->get('title');
    my $pub_date = body_parameters->get('pub_date');
    my $isbn     = body_parameters->get('isbn');

    # check if it is valid author
    return unless defined _author($author);

    my $response = Schema::Book->new({
        author   => $author,
        title    => $title,
        pub_date => $pub_date,
        isbn     => $isbn,
    })->populate($schema);

    return _book($response->[0]->id);
};

del '/api/books/:id' => sub {
    my $id = route_parameters->get('id');

    $schema->delete_object('Book', $id);

    return _books();
};

#
#
# PRIVATE METHODS

sub _books {

    my @rows  = $schema->search_object('Book');
    my $books = [];
    foreach my $row (@rows) {
        push @$books, {
            id       => $row->id,
            author   => $row->author->id,
            title    => $row->title,
            pub_date => $row->pub_date,
            isbn     => $row->isbn,
        };
    }

    return $books;
}

sub _book {
    my ($id) = @_;

    my ($book) = $schema->search_object('Book', { id => $id });

    return {
        id       => $id,
        author   => $book->author->id,
        title    => $book->title,
        pub_date => $book->pub_date,
        isbn     => $book->isbn,
    };
}

sub _authors {

    my @rows    = $schema->search_object('Author');
    my $authors = [];
    foreach my $row (@rows) {
        push @$authors, {
            id         => $row->id,
            first_name => $row->first_name,
            last_name  => $row->last_name,
            country    => $row->country,
        };
    }

    return $authors;
}

sub _author {
    my ($id) = @_;

    my ($author) = $schema->search_object('Author', { id => $id });
    return unless defined $author;

    return {
        id         => $id,
        first_name => $author->first_name,
        last_name  => $author->last_name,
        country    => $author->country,
    };
}

sub _author_books {
    my ($id) = @_;

    my @rows  = $schema->search_object('Book', { author => $id });
    my $books = [];
    foreach my $row (@rows) {
        push @$books, {
            id       => $row->id,
            author   => $row->author->id,
            title    => $row->title,
            pub_date => $row->pub_date,
            isbn     => $row->isbn,
        };
    }

    return $books;
}

1;
