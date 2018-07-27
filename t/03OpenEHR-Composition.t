use strict;
use warnings;

use Test::More;

BEGIN { use_ok('OpenEHR::Composition') }
diag("Testing OpenEHR::Composition $OpenEHR::Composition::VERSION");

note('Testing Local Configuration file settings');
my $local_config_file = 'OpenEHR_Composition.conf';
ok( -f $local_config_file, 'Local Configuration file exists' );
ok( open( my $fh, '<', $local_config_file ), 'Local Configuration file is readable' );
my %local_config;

while ( my $line = <$fh> ) {
    next if $line =~ /^[#|\s]/;
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    note("Param($param) value($value)");
    $local_config{$param} = $value;
}


ok( my $composition = OpenEHR::Composition->new(),
    'Construct Composition object' );

is( $composition->composition_format,
    'STRUCTURED', 'Default Composition format is STRUCTURED' );
is( $composition->language_code, $local_config{language_code},
    'Default Language code set from conf file' );
is( $composition->language_terminology,
    $local_config{language_terminology},
    'Default Language terminology set from conf file'
);
is( $composition->territory_code, $local_config{territory_code},
    'Default Territory Code set from conf file' );
is( $composition->territory_terminology,
    $local_config{territory_terminology},
    'Default Territory Terminology set from conf file'
);
is( $composition->encoding_code, $local_config{encoding_code},
    'Default encoding code set from conf file' );
is( $composition->encoding_terminology,
    $local_config{encoding_terminology},
    'Default encoding terminology set from conf file'
);

is( $composition->id_namespace,  $local_config{id_namespace},  'Namespace Id set from conf file' );
is( $composition->id_scheme,  $local_config{id_scheme},  'Scheme Id set from conf file' );
is( $composition->facility_name,  $local_config{facility_name},  'Facility Name set from conf file' );
is( $composition->facility_id,  $local_config{facility_id},  'Facility Id set from conf file' );

ok( $composition->composition_format('FLAT'),
    'Set composition format to FLAT'
);
is( $composition->composition_format, 'FLAT', 'FLAT format set' );
ok( $composition->composition_format('RAW'),
    'Set composition format to RAW' );
is( $composition->composition_format, 'RAW', 'RAW format set' );
ok( $composition->composition_format('TDD'),
    'Set composition format to TDD' );
is( $composition->composition_format, 'TDD', 'TDD format set' );
eval { $composition->composition_format('XML'); };

if ($@) {
    ok( 1, q{Can't use formats outside inclusion list} );
}

done_testing;
