use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'OpenEHR',
    license             => 'artistic2',
    dist_author         => 'David Ramlakhan <dram1964@gmail.com>',
    dist_version_from   => 'lib/OpenEHR.pm',
    requires => {
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
    add_to_cleanup      => [ 'OpenEHR-*' ],
);

$builder->create_build_script();
