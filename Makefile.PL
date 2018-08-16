use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'OpenEHR',
    AUTHOR              => 'David Ramlakhan <dram1964@gmail.com>',
    VERSION_FROM        => 'lib/OpenEHR.pm',
    ABSTRACT_FROM       => 'lib/OpenEHR.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
        'Carp'       => 0,
        'JSON'       => 0,
        'Moose'      => 0,
        'DateTime'   => 0,
        'DateTime::Format::Pg' => 0,
        'Config::Simple'    => 0,
        'Data::Dumper'      => 0,
        'Moose::Util::TypeConstraints'  => 0,
        'URI::Encode'       => 0,
        'Module::Find'      => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'OpenEHR-*' },
);
