package My::BookStore::Schema;

use DBIx::Class::Schema::Loader;
use base qw(DBIx::Class::Schema::Loader);

package main;

use strict;
use warnings;

my $schema = My::BookStore::Schema->connect('dbi:SQLite:dbname=bookstore.db');

# pre-populate table 'authors'
$schema->populate(
    'Authors', [
        ['first_name', 'last_name', 'country'  ],
        ['Dave',       'Cross',     'England'  ],
        ['Curtis',     'Poe',       'France'   ],
        ['Damian',     'Conway',    'Australia'],
    ]);

# initial book list by authors
my @book_list = (
    ['Data Munging with Perl', 'Dave',   'Cross',  '2010-01-01', 'DMWP-DC'],
    ['Perl Taster',            'Dave',   'Cross',  '2010-02-01', 'PT-DC'  ],
    ['Perl Hacks',             'Curtis', 'Poe',    '2010-03-01', 'PH-CP'  ],
    ['Beginning Perl',         'Curtis', 'Poe',    '2010-04-01', 'BP-CP'  ],
    ['Perl Best Practices',    'Damian', 'Conway', '2010-05-01', 'PBP-DC' ],
    ['Object Oriented Perl',   'Damian', 'Conway', '2010-06-01', 'OOP-DC' ],
);

# fetch author id using author's first name and last name
my $books = [];
foreach my $book (@book_list) {

    my ($title, $first_name, $last_name, $pub_date, $isbn) = @$book;

    # assign author to each book
    my $author = $schema->resultset('Authors')
                 ->find({
                     first_name => $first_name,
                     last_name  => $last_name
                 })->id;

    push @$books, [$title, $author, $pub_date, $isbn];
}

# pre-populate table 'books'
$schema->populate('Books',
                  [['title', 'author', 'pub_date', 'isbn'],
                  @$books ]);
