use strict;
use warnings;

use Test::More;

BEGIN { use_ok('OpenEHR::Composition') }
diag("Testing OpenEHR::Composition $OpenEHR::Composition::VERSION");

ok( my $composition = OpenEHR::Composition->new(),
    'Construct Composition object' );

is( $composition->composition_format,
    'STRUCTURED', 'Default Composition format' );
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
