use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::LabTest::LabResult;
diag( 'Testing OpenEHR::Composition::LabTest::LabResult '
        . $OpenEHR::Composition::LabTest::LabResult::VERSION );

my ( $data, $labtest );

$data = {
    'testcode'     => 'A1G',
    'testname'     => 'A1G',
    'unit'         => '%',
    'range_low'    => '1.7',
    'range_high'   => '3.8',
    'result_value' => '5.0'
};
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with decimal result' );
is( $labtest->magnitude,  '5.0',     'Magnitude set from result value' );
is( $labtest->testcode,   'A1G',     'Test code set by constructor param' );
is( $labtest->testname,   'A1G',     'Test name set by constructor param' );
is( $labtest->range_low,  '1.7',     'Range low set by constructor param' );
is( $labtest->range_high, '3.8',     'Range high set by constructor param' );
is( $labtest->ref_range,  '1.7-3.8', 'Ref range derived from ranges' );
is( $labtest->unit,       '%',       'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),      'No result_text set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
    'testname'     => 'ALB',
    'testcode'     => 'ALB',
    'result_value' => '40',
    'range_high'   => '54',
    'unit'         => 'g/L',
    'range_low'    => '38'
};
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with integer result' );
is( $labtest->magnitude,  '40',    'Magnitude set from result value' );
is( $labtest->testcode,   'ALB',   'Test code set by constructor param' );
is( $labtest->testname,   'ALB',   'Test name set by constructor param' );
is( $labtest->range_low,  '38',    'Range low set by constructor param' );
is( $labtest->range_high, '54',    'Range high set by constructor param' );
is( $labtest->ref_range,  '38-54', 'Ref range derived from ranges' );
is( $labtest->unit,       'g/L',   'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),      'No result_text set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
    'unit'         => 'IU/L',
    'testname'     => 'ALP',
    'range_low'    => '0',
    'range_high'   => '300',
    'result_value' => '150',
    'testcode'     => 'ALP'
};
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with range_low value of zero'
);
is( $labtest->magnitude,  '150',   'Magnitude set from result value' );
is( $labtest->testcode,   'ALP',   'Test code set by constructor param' );
is( $labtest->testname,   'ALP',   'Test name set by constructor param' );
is( $labtest->range_low,  '0',     'Range low set by constructor param' );
is( $labtest->range_high, '300',   'Range high set by constructor param' );
is( $labtest->ref_range,  '0-300', 'Ref range derived from ranges' );
is( $labtest->unit,       'IU/L',  'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),      'No result_text set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
    'result_value' => '6.0',
    'testname'     => 'B2G',
    'range_high'   => '',
    'testcode'     => 'B2G',
    'unit'         => '%',
    'range_low'    => ''
};
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with blank ranges' );
is( $labtest->magnitude,  '6.0', 'Magnitude set from result value' );
is( $labtest->testcode,   'B2G', 'Test code set by constructor param' );
is( $labtest->testname,   'B2G', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit,       '%',   'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),      'No result_text set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
    'range_high'   => '',
    'testcode'     => 'GFR',
    'testname'     => 'GFR',
    'range_low'    => '',
    'result_value' => 'Not calculated. Age less than 18yrs.',
    'unit'         => '.'
};
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with text only result'
);
is( $labtest->result_text,
    'Not calculated. Age less than 18yrs.',
    'Result text set from result value'
);
is( $labtest->testcode,   'GFR', 'Test code set by constructor param' );
is( $labtest->testname,   'GFR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit,       '',    'Unit set to empty string' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'range_high' => '',
          'testname' => 'KLRA',
          'unit' => '',
          'range_low' => '',
          'testcode' => 'KLRA',
          'result_value' => '0.75
Analysed at UCLH using SPAplus Freelite. Results
may differ from those using the Royal Free method.
Occasional monoclonal proteins react atypically in
the assay and give erroneous results.
Contact x72952 to discuss if discrepancy suspected'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result with comment'
);
is( $labtest->magnitude,
    '0.75', 'Magnitude set from numeric result on first line');
is( $labtest->comment, 'Analysed at UCLH using SPAplus Freelite. Results
may differ from those using the Royal Free method.
Occasional monoclonal proteins react atypically in
the assay and give erroneous results.
Contact x72952 to discuss if discrepancy suspected',
    'comment set from remainder of result'
);
is( $labtest->testcode,   'KLRA', 'Test code set by constructor param' );
is( $labtest->testname,   'KLRA', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set to empty string by constructor' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),        'No result_text set' );

$data = {
          'range_low' => '',
          'testname' => 'PCOM',
          'result_value' => 'Positive
Method changed on 24/02/14 from gel to capillary
electrophoresis. New reference ranges apply.',
          'range_high' => '',
          'testcode' => 'PCOM',
          'unit' => ''
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with text result with comment'
);
is( $labtest->result_text,
    'Positive', 'Result text set from text result on first line');
is( $labtest->comment, 'Method changed on 24/02/14 from gel to capillary
electrophoresis. New reference ranges apply.',
    'comment set from remainder of result'
);
is( $labtest->testcode,   'PCOM', 'Test code set by constructor param' );
is( $labtest->testname,   'PCOM', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set to empty string by constructor' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );

$data = {
          'result_value' => '19
Method changed on 24/02/14 from gel to capillary
electrophoresis. Paraproteins average 2 g/L higher
(80% between 1 g/L lower and 5 g/L higher).
IgA PP more affected than IgG or IgM.',
          'range_low' => '0',
          'testname' => 'PPR',
          'range_high' => '',
          'testcode' => 'PPR',
          'unit' => 'g/L'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result, 
    comment, no range high and range low set to "0"'
);
is( $labtest->magnitude,
    '19', 'Magnitude set from numeric result on first line');
is( $labtest->comment, 'Method changed on 24/02/14 from gel to capillary
electrophoresis. Paraproteins average 2 g/L higher
(80% between 1 g/L lower and 5 g/L higher).
IgA PP more affected than IgG or IgM.',
    'comment set from remainder of result'
);
is( $labtest->testcode,   'PPR', 'Test code set by constructor param' );
is( $labtest->testname,   'PPR', 'Test name set by constructor param' );
is( $labtest->range_low,  '0',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0',    'Ref range derived from ranges' );
is( $labtest->unit, 'g/L', 'Unit set to empty string by constructor' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),        'No result_text set' );

$data = {
          'range_high' => '0.1',
          'testcode' => 'BA',
          'result_value' => ' 1.0%  0.10
Note new haematology ranges effective 05/10/15',
          'range_low' => '0.0',
          'unit' => 'x10^9/L',
          'testname' => 'BA'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with double numeric result and comment'
);
is( $labtest->result_text,
    ' 1.0%  0.10 x10^9/L', 'Result text set from double numeric result on first line');
is( $labtest->comment, 'Note new haematology ranges effective 05/10/15',
    'comment set from remainder of result'
);
is( $labtest->testcode,   'BA', 'Test code set by constructor param' );
is( $labtest->testname,   'BA', 'Test name set by constructor param' );
is( $labtest->range_low,  '0.0',    'Range low set by constructor param' );
is( $labtest->range_high, '0.1',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0.0-0.1',    'Ref range derived from ranges' );
is( $labtest->unit, 'x10^9/L', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );

$data = {
          'range_high' => '0.8',
          'range_low' => '0.0',
          'unit' => 'x10^9/L',
          'testcode' => 'EO',
          'testname' => 'EO',
          'result_value' => ' 4.0%  0.40'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with double numeric result and no comment'
);
is( $labtest->result_text,
    ' 4.0%  0.40 x10^9/L', 'Result text set from double numeric result on first line');
is( $labtest->testcode,   'EO', 'Test code set by constructor param' );
is( $labtest->testname,   'EO', 'Test name set by constructor param' );
is( $labtest->range_low,  '0.0',    'Range low set by constructor param' );
is( $labtest->range_high, '0.8',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0.0-0.8',    'Ref range derived from ranges' );
is( $labtest->unit, 'x10^9/L', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'range_high' => '0.44',
          'range_low' => '0.33',
          'testname' => 'HCTU',
          'testcode' => 'HCTU',
          'unit' => 'L/L',
          'result_value' => '0.400'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with result with 3 decimal places'
);
is( $labtest->magnitude, '0.400', 'Magnitude set 3 decimal places');
is( $labtest->testcode,   'HCTU', 'Test code set by constructor param' );
is( $labtest->testname,   'HCTU', 'Test name set by constructor param' );
is( $labtest->range_low,  '0.33',    'Range low set by constructor param' );
is( $labtest->range_high, '0.44',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0.33-0.44',    'Ref range derived from ranges' );
is( $labtest->unit, 'L/L', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),        'No magnitude set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'unit' => '',
          'result_value' => '0.94
Analysed at UCLH using SPAplus Freelite. Results
may differ from those using the Royal Free method.
Occasional monoclonal proteins react atypically in
the assay and give erroneous results.
Contact x72952 to discuss if discrepancy suspected',
          'range_high' => '',
          'testname' => 'KLRA',
          'range_low' => '',
          'testcode' => 'KLRA'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with 5 line comment and no units or ranges'
);
is( $labtest->magnitude, '0.94', 'Magnitude set by constructor param');
is( $labtest->comment, 'Analysed at UCLH using SPAplus Freelite. Results
may differ from those using the Royal Free method.
Occasional monoclonal proteins react atypically in
the assay and give erroneous results.
Contact x72952 to discuss if discrepancy suspected', 'Comment set from remainder of result');
is( $labtest->testcode,   'KLRA', 'Test code set by constructor param' );
is( $labtest->testname,   'KLRA', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),        'No magnitude set' );

$data = {
          'range_low' => '1.5',
          'unit' => 'x10^9/L',
          'result_value' => '20.0%  2.00',
          'testcode' => 'LY',
          'testname' => 'LY',
          'range_high' => '7.0'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with double numeric value and no initial whitespace'
);
is( $labtest->result_text, '20.0%  2.00 x10^9/L', 'Result text set properly');
is( $labtest->testcode,   'LY', 'Test code set by constructor param' );
is( $labtest->testname,   'LY', 'Test name set by constructor param' );
is( $labtest->range_low,  '1.5',    'Range low set by constructor param' );
is( $labtest->range_high, '7.0',    'Range high set by constructor param' );
is( $labtest->ref_range,  '1.5-7.0',    'Ref range derived from ranges' );
is( $labtest->unit, 'x10^9/L', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'unit' => '',
          'range_low' => '',
          'testname' => 'PCCC',
          'result_value' => 'Please note that this test may not detect HIV
infection for up to three months after exposure.',
          'range_high' => '',
          'testcode' => 'PCCC'
        };
ok( $labtest = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with two line text-only result'
);
is( $labtest->result_text, 'Please note that this test may not detect HIV
infection for up to three months after exposure.', 'Result text set properly');
is( $labtest->testcode,   'PCCC', 'Test code set by constructor param' );
is( $labtest->testname,   'PCCC', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );
note("on lines 141 to 150");


done_testing;
