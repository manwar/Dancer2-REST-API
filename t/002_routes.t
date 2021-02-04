use strict;
use warnings;

use JSON;
use BookStore;
use Test::Deep;
use Test::More;
use Plack::Test;
use Ref::Util qw(is_coderef);
use HTTP::Request::Common qw(GET);

my $app  = BookStore->to_app;
my $test = Plack::Test->create($app);

subtest main => sub {
    ok(is_coderef($app), 'Got app');
};

subtest author => sub {
    my $res1 = $test->request(GET '/api/authors');
    is($res1->status_line, '200 OK', 'Status');
    is_deeply(from_json($res1->content), _authors(), 'GET /api/authors');

    my $res2 = $test->request(GET '/api/authors/1');
    is($res2->status_line, '200 OK', 'Status');
    is_deeply(from_json($res2->content), _author(), 'GET /api/authors/1');
};

subtest book => sub {
    my $res1 = $test->request(GET '/api/books');
    is($res1->status_line, '200 OK', 'Status');
    is_deeply(from_json($res1->content), _books(), 'GET /api/books');

    my $res2 = $test->request(GET '/api/books/1');
    is($res2->status_line, '200 OK', 'Status');
    is_deeply(from_json($res2->content), _book(), 'GET /api/books/1');
};

done_testing;

#
#
# PRIVATE METHODS

sub _author {
    return
    {
        "id"         => 1,
        "first_name" => "Dave",
        "last_name"  => "Cross",
        "country"    => "England",
    };
}

sub _authors {
    return
    [
        {
            "id"         => 1,
            "first_name" => "Dave",
            "last_name"  => "Cross",
            "country"    => "England",
        },
        {
               "id"         => 2,
            "first_name" => "Curtis",
            "last_name"  => "Poe",
            "country"    => "France",
        },
        {
            "id"         => 3,
            "first_name" => "Damian",
            "last_name"  => "Conway",
            "country"    => "Australia",
        }
    ];
}

sub _book {
    return
    {
        "id"       => 1,
        "author"   => 1,
        "title"    => "Data Munging with Perl",
        "pub_date" => "2010-01-01",
        "isbn"     => "DMWP-DC",
    };
}

sub _books {
    return
    [
           {
              "id"       => 1,
              "author"   => 1,
              "title"    => "Data Munging with Perl",
              "pub_date" => "2010-01-01",
              "isbn"     => "DMWP-DC",
           },
           {
              "id"       => 2,
              "author"   => 1,
              "title"    => "Perl Taster",
              "pub_date" => "2010-02-01",
              "isbn"     => "PT-DC",
           },
           {
              "id"       => 3,
              "author"   => 2,
              "title"    => "Perl Hacks",
              "pub_date" => "2010-03-01",
              "isbn"     => "PH-CP",
           },
           {
              "id"       => 4,
              "author"   => 2,
              "title"    => "Beginning Perl",
              "pub_date" => "2010-04-01",
              "isbn"     => "BP-CP",
           },
           {
              "id"       => 5,
              "author"   => 3,
              "title"    => "Perl Best Practices",
              "pub_date" => "2010-05-01",
              "isbn"     => "PBP-DC",
           },
           {
              "id"       => 6,
              "author"   => 3,
              "title"    => "Object Oriented Perl 123",
              "pub_date" => "2010-06-01",
              "isbn"     => "OOP-DC",
           }
    ];
}
