use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok('OpenEHR::Composition::Elements::CTX'); }

note('Testing Local Configuration file settings');
my $local_config_file = 'OpenEHR_Composition.conf';
ok( -f $local_config_file, 'Local Configuration file exists' );
ok( open( my $fh, '<', $local_config_file ),
    'Local Configuration file is readable'
);
my %local_config;

while ( my $line = <$fh> ) {
    next if $line =~ /^[#|\s]/;
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    note("Param($param) value($value)");
    $local_config{$param} = $value;
}

ok( my $ctx = OpenEHR::Composition::Elements::CTX->new() );

is( $ctx->composition_format,
    'STRUCTURED', 'Default Composition format is STRUCTURED' );
is( $ctx->language_code,
    $local_config{language_code},
    'Default Language code set from conf file'
);
is( $ctx->language_terminology,
    $local_config{language_terminology},
    'Default Language terminology set from conf file'
);
is( $ctx->territory_code,
    $local_config{territory_code},
    'Default Territory Code set from conf file'
);
is( $ctx->territory_terminology,
    $local_config{territory_terminology},
    'Default Territory Terminology set from conf file'
);
is( $ctx->encoding_code,
    $local_config{encoding_code},
    'Default encoding code set from conf file'
);
is( $ctx->encoding_terminology,
    $local_config{encoding_terminology},
    'Default encoding terminology set from conf file'
);

is( $ctx->id_namespace,
    $local_config{id_namespace},
    'Namespace Id set from conf file'
);
is( $ctx->id_scheme,
    $local_config{id_scheme},
    'Scheme Id set from conf file'
);
is( $ctx->facility_name,
    $local_config{facility_name},
    'Facility Name set from conf file'
);
is( $ctx->facility_id,
    $local_config{facility_id},
    'Facility Id set from conf file'
);
is( $ctx->composer_name,      $local_config{composer_name}, 'Composer Name accessor' );


done_testing;
