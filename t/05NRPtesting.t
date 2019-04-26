use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Elements::LabTest::LabResult;
diag( 'Testing OpenEHR::Composition::Elements::LabTest::LabResult '
        . $OpenEHR::Composition::Elements::LabTest::LabResult::VERSION );

my ( $data, $labtest );

$data = {
    'testcode'     => 'NRP',
    'testname'     => 'Nucleated RBCs %',
    'unit'         => '          ',
    'range_low'    => '',
    'range_high'   => '',
    'result_value' => '0.0'
};
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct NRP result with no units' );

is( $labtest->testcode,   'NRP',     'Test code set by constructor param' );
is( $labtest->testname,   'Nucleated RBCs %',     'Test name set by constructor param' );
is( $labtest->unit,       '',       'Unit set by constructor param' );
is( $labtest->result_text, '0.0' ,      'result_text set by constuctor' );
is( $labtest->magnitude, '0.0', 'magnitude set by constructor' );
is( $labtest->range_low, '',  'range_low set by constructor' );
is( $labtest->range_high , '', 'range_high set by constructor' );
is( $labtest->ref_range , '',  'ref_range set by constructor' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

done_testing;
