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
    },
    add_to_cleanup      => [ 'OpenEHR-*' ],
);

$builder->create_build_script();
