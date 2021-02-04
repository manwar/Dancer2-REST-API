use strict;
use warnings;
use ExtUtils::MakeMaker;

my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME         => 'BookStore',
    AUTHOR       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM => 'lib/BookStore.pm',
    ABSTRACT     => 'lib/BookStore.pm',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    BUILD_REQUIRES    => {
        'JSON'        => 0,
        'Test::More'  => 0,
        'Plack::Test' => 0,
        'Ref::Util'   => 0,
        'HTTP::Request::Common' => 0,
    },
    PREREQ_PM => {
        'Moo'     => 2.003006,
        'Dancer2' => 0.300004,
        'Dancer2::Plugin::DBIC'     => 0,
        'Dancer2::Serializer::JSON' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'BookStore-*' },
);
