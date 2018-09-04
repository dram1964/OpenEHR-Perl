use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Elements::LabTest::LabResult;
diag( 'Testing OpenEHR::Composition::Elements::LabTest::LabResult '
        . $OpenEHR::Composition::Elements::LabTest::LabResult::VERSION );

my ( $data, $labtest );

$data = {
    'testcode'     => 'A1G',
    'testname'     => 'A1G',
    'unit'         => '%',
    'range_low'    => '1.7',
    'range_high'   => '3.8',
    'result_value' => '5.0'
};
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with decimal result' );
is( $labtest->magnitude,  '5.0',     'Magnitude set from result value' );
is( $labtest->testcode,   'A1G',     'Test code set by constructor param' );
is( $labtest->testname,   'A1G',     'Test name set by constructor param' );
is( $labtest->range_low,  '1.7',     'Range low set by constructor param' );
is( $labtest->range_high, '3.8',     'Range high set by constructor param' );
is( $labtest->ref_range,  '1.7 - 3.8', 'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with integer result' );
is( $labtest->magnitude,  '40',    'Magnitude set from result value' );
is( $labtest->testcode,   'ALB',   'Test code set by constructor param' );
is( $labtest->testname,   'ALB',   'Test name set by constructor param' );
is( $labtest->range_low,  '38',    'Range low set by constructor param' );
is( $labtest->range_high, '54',    'Range high set by constructor param' );
is( $labtest->ref_range,  '38 - 54', 'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with range_low value of zero'
);
is( $labtest->magnitude,  '150',   'Magnitude set from result value' );
is( $labtest->testcode,   'ALP',   'Test code set by constructor param' );
is( $labtest->testname,   'ALP',   'Test name set by constructor param' );
is( $labtest->range_low,  '0',     'Range low set by constructor param' );
is( $labtest->range_high, '300',   'Range high set by constructor param' );
is( $labtest->ref_range,  '0 - 300', 'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
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
          'unit' => 'mg/L',
          'range_low' => '',
          'testcode' => 'KLRA',
          'result_value' => '0.75
Analysed at UCLH using SPAplus Freelite. Results
may differ from those using the Royal Free method.
Occasional monoclonal proteins react atypically in
the assay and give erroneous results.
Contact x72952 to discuss if discrepancy suspected'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result with comment and units'
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
is( $labtest->unit, 'mg/L', 'Unit set to empty string by constructor' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->result_text ) ),        'No result_text set' );

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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result with comment but no units'
);
is( $labtest->result_text,
    '0.75', 'Result text set from numeric result with no units');
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
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );

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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "Positive" text result with comment'
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
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
is( $labtest->ref_range,  '0.0 - 0.1',    'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with double numeric result and no comment'
);
is( $labtest->result_text,
    ' 4.0%  0.40 x10^9/L', 'Result text set from double numeric result on first line');
is( $labtest->testcode,   'EO', 'Test code set by constructor param' );
is( $labtest->testname,   'EO', 'Test name set by constructor param' );
is( $labtest->range_low,  '0.0',    'Range low set by constructor param' );
is( $labtest->range_high, '0.8',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0.0 - 0.8',    'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with result with 3 decimal places'
);
is( $labtest->magnitude, '0.400', 'Magnitude set 3 decimal places');
is( $labtest->testcode,   'HCTU', 'Test code set by constructor param' );
is( $labtest->testname,   'HCTU', 'Test name set by constructor param' );
is( $labtest->range_low,  '0.33',    'Range low set by constructor param' );
is( $labtest->range_high, '0.44',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0.33 - 0.44',    'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with 5 line comment and no units or ranges'
);
is( $labtest->result_text, '0.94', 'Result text set by constructor param with no units');
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
ok( !( defined( $labtest->magnitude ) ),        'No magnitude set' );

$data = {
          'range_low' => '1.5',
          'unit' => 'x10^9/L',
          'result_value' => '20.0%  2.00',
          'testcode' => 'LY',
          'testname' => 'LY',
          'range_high' => '7.0'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with double numeric value and no initial whitespace'
);
is( $labtest->result_text, '20.0%  2.00 x10^9/L', 'Result text set properly');
is( $labtest->testcode,   'LY', 'Test code set by constructor param' );
is( $labtest->testname,   'LY', 'Test name set by constructor param' );
is( $labtest->range_low,  '1.5',    'Range low set by constructor param' );
is( $labtest->range_high, '7.0',    'Range high set by constructor param' );
is( $labtest->ref_range,  '1.5 - 7.0',    'Ref range derived from ranges' );
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
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
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

$data = {
          'range_low' => '',
          'range_high' => '',
          'unit' => '',
          'testname' => 'POCR',
          'result_value' => 'HIV 1 + 2 antibodies NOT detected.',
          'testcode' => 'POCR'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with single line text result with numeric characters'
);
is( $labtest->result_text, 'HIV 1 + 2 antibodies NOT detected.', 'Result text set properly');
is( $labtest->testcode,   'POCR', 'Test code set by constructor param' );
is( $labtest->testname,   'POCR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'result_value' => 'Note that a reactive result is not diagnostic of
HIV infection without confirmatory laboratory
testing, as false positives can occur.
Please review ALL this patient\'s virology results.',
          'testcode' => 'PCCC',
          'testname' => 'PCCC',
          'unit' => '',
          'range_high' => '',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with four line text result'
);
is( $labtest->result_text, 'Note that a reactive result is not diagnostic of
HIV infection without confirmatory laboratory
testing, as false positives can occur.
Please review ALL this patient\'s virology results.', 'Result text set properly');
is( $labtest->testcode,   'PCCC', 'Test code set by constructor param' );
is( $labtest->testname,   'PCCC', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'testcode' => 'HCVR',
          'testname' => 'HCVR',
          'range_low' => '',
          'unit' => '',
          'range_high' => '',
          'result_value' => 'Not Detected
This does not exclude acute HCV infection as
seroconversion may be delayed. If you consider
this patient to have risk factors for HCV
infection, please contact us to discuss further
testing of this sample.'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "Not Detected" result and commment'
);
is( $labtest->result_text, 'Not Detected', 'Result text set properly');
is( $labtest->comment, 'This does not exclude acute HCV infection as
seroconversion may be delayed. If you consider
this patient to have risk factors for HCV
infection, please contact us to discuss further
testing of this sample.', 'Comment set properly');
is( $labtest->testcode,   'HCVR', 'Test code set by constructor param' );
is( $labtest->testname,   'HCVR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );

$data = {
          'testname' => 'HCVR',
          'testcode' => 'HCVR',
          'range_low' => '',
          'unit' => '',
          'range_high' => '',
          'result_value' => 'Not Detected'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "Not Detected" result and no commment'
);
is( $labtest->result_text, 'Not Detected', 'Result text set properly');
is( $labtest->testcode,   'HCVR', 'Test code set by constructor param' );
is( $labtest->testname,   'HCVR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'testcode' => 'PS10',
          'result_value' => 'leave for sue please',
          'testname' => 'PS10',
          'range_low' => '',
          'range_high' => '',
          'unit' => 'secs'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with text result and units'
);
is( $labtest->result_text, 'leave for sue please', 'Result text set properly');
is( $labtest->testcode,   'PS10', 'Test code set by constructor param' );
is( $labtest->testname,   'PS10', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, 'secs', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'testname' => 'APRA',
          'unit' => 'n',
          'range_low' => '2.0',
          'testcode' => 'APRA',
          'range_high' => '3.0',
          'result_value' => '>180.0 secs. APTT ratio > 5.7'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with text result that begins and ends in numeric values'
);
is( $labtest->result_text, '>180.0 secs. APTT ratio > 5.7', 'Result text set properly');
is( $labtest->testcode,   'APRA', 'Test code set by constructor param' );
is( $labtest->testname,   'APRA', 'Test name set by constructor param' );
is( $labtest->range_low,  '2.0',    'Range low set by constructor param' );
is( $labtest->range_high, '3.0',    'Range high set by constructor param' );
is( $labtest->ref_range,  '2.0 - 3.0',    'Ref range derived from ranges' );
is( $labtest->unit, 'n', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'result_value' => 'bone marrow unsuitable for staining please repeat
6 slides required.',
          'range_high' => '',
          'testname' => 'BM',
          'unit' => '',
          'testcode' => 'BM',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with text result and comment that begins with numeric'
);
is( $labtest->result_text, 'bone marrow unsuitable for staining please repeat
6 slides required.', 'Result text set properly');
is( $labtest->testcode,   'BM', 'Test code set by constructor param' );
is( $labtest->testname,   'BM', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'testcode' => 'ACLG',
          'result_value' => '6.8Neg',
          'range_low' => '0',
          'range_high' => '5',
          'testname' => 'ACLG',
          'unit' => 'GPLU'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result with text suffix'
);
is( $labtest->result_text, '6.8Neg GPLU', 'Result text set properly');
is( $labtest->testcode,   'ACLG', 'Test code set by constructor param' );
is( $labtest->testname,   'ACLG', 'Test name set by constructor param' );
is( $labtest->range_low,  '0',    'Range low set by constructor param' );
is( $labtest->range_high, '5',    'Range high set by constructor param' );
is( $labtest->ref_range,  '0 - 5',    'Ref range derived from ranges' );
is( $labtest->unit, 'GPLU', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'testcode' => 'SYPR',
          'testname' => 'SYPR',
          'range_high' => '',
          'unit' => '',
          'range_low' => '',
          'result_value' => 'Negative'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "Negative" text result'
);
is( $labtest->result_text, 'Negative', 'Result text set properly');
is( $labtest->testcode,   'SYPR', 'Test code set by constructor param' );
is( $labtest->testname,   'SYPR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ),        'No comment set' );

$data = {
          'range_low' => '',
          'testname' => 'TLVR',
          'range_high' => '',
          'result_value' => 'REACTIVE
Sent to Reference Laboratory.',
          'testcode' => 'TLVR',
          'unit' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "REACTIVE" text result and comment'
);
is( $labtest->result_text, 'REACTIVE', 'Result text set properly');
is( $labtest->comment, 'Sent to Reference Laboratory.', 'Result text set properly');
is( $labtest->testcode,   'TLVR', 'Test code set by constructor param' );
is( $labtest->testname,   'TLVR', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );

$data = {
          'unit' => '',
          'result_value' => '10/10/2011',
          'testcode' => '9SER',
          'range_high' => '',
          'testname' => '9SER',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with date result'
);
is( $labtest->result_text, '10/10/2011', 'Result text set properly');
is( $labtest->testcode,   '9SER', 'Test code set by constructor param' );
is( $labtest->testname,   '9SER', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'No comment set' );

$data = {
          'range_high' => '',
          'result_value' => 'HIV INCIDENCE TEST RESULT NOT CONSISTENT WITH
RECENTLY ACQUIRED HIV INFECTION.
These findings indicate that seroconversion
probably did not occur within the 5-6 months prior
to sample date.  However, these findings should be
interpreted with due regard to clinical and HIV
risk information.',
          'testcode' => 'RIN1',
          'unit' => '',
          'range_low' => '',
          'testname' => 'RIN1'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with 7 line text result'
);
is( $labtest->result_text, 'HIV INCIDENCE TEST RESULT NOT CONSISTENT WITH
RECENTLY ACQUIRED HIV INFECTION.
These findings indicate that seroconversion
probably did not occur within the 5-6 months prior
to sample date.  However, these findings should be
interpreted with due regard to clinical and HIV
risk information.', 'Result text set properly');
is( $labtest->testcode,   'RIN1', 'Test code set by constructor param' );
is( $labtest->testname,   'RIN1', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'No comment set' );

$data = {
          'range_low' => '',
          'testname' => 'HELC',
          'unit' => '',
          'result_value' => '01012012',
          'testcode' => 'HELC',
          'range_high' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result and no units'
);
is( $labtest->result_text, '01012012', 'Result text set properly');
is( $labtest->testcode,   'HELC', 'Test code set by constructor param' );
is( $labtest->testname,   'HELC', 'Test name set by constructor param' );
is( $labtest->range_low,  '',    'Range low set by constructor param' );
is( $labtest->range_high, '',    'Range high set by constructor param' );
is( $labtest->ref_range,  '',    'Ref range derived from ranges' );
is( $labtest->unit, '', 'Unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'No magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'No magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'No comment set' );

$data = {
          'testname' => 'HBCC',
          'result_value' => 'If the patient was not previously immunised
against hepatitis b then the anti-hbs reactivity
is of doubtful significance and immunisation
may be appropriate.
~
If the patient was immunised previously, then a
vaccine booster should be considered.
see chapter 18 in the dh publication -
immunisation against infectious disease 2006.',
          'unit' => '',
          'testcode' => 'HBCC',
          'range_high' => '',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with 9 line text result'
);
is( $labtest->result_text, 'If the patient was not previously immunised
against hepatitis b then the anti-hbs reactivity
is of doubtful significance and immunisation
may be appropriate.
~
If the patient was immunised previously, then a
vaccine booster should be considered.
see chapter 18 in the dh publication -
immunisation against infectious disease 2006.', 'result text set properly');
is( $labtest->testcode,   'HBCC', 'test code set by constructor param' );
is( $labtest->testname,   'HBCC', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no comment set' );

$data = {
          'testcode' => 'COSD',
          'range_high' => '',
          'range_low' => '',
          'unit' => '',
          'result_value' => 'Organisms sent 13/02/2012 18:16',
          'testname' => 'COSD'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with text result ending in numerics'
);
is( $labtest->result_text, 'Organisms sent 13/02/2012 18:16', 'result text set properly');
is( $labtest->testcode,   'COSD', 'test code set by constructor param' );
is( $labtest->testname,   'COSD', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no comment set' );

$data = {
          'testcode' => 'HDVT',
          'range_high' => '',
          'unit' => '',
          'range_low' => '',
          'result_value' => 'Weak Reactive
Further report to follow.',
          'testname' => 'HDVT'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "weak reactive" text result with comment'
);
is( $labtest->result_text, 'Weak Reactive', 'result text set properly');
is( $labtest->comment, 'Further report to follow.', 'result text set properly');
is( $labtest->testcode,   'HDVT', 'test code set by constructor param' );
is( $labtest->testname,   'HDVT', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );

$data = {
          'testcode' => 'HEGE',
          'range_high' => '',
          'unit' => '',
          'range_low' => '',
          'result_value' => 'Weak Reactive',
          'testname' => 'HEGE'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "Weak Reactive" text result with no comment'
);
is( $labtest->result_text, 'Weak Reactive', 'result text set properly');
is( $labtest->testcode,   'HEGE', 'test code set by constructor param' );
is( $labtest->testname,   'HEGE', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'testname' => 'BRME',
          'result_value' => 'Positive: titre 80',
          'range_low' => '',
          'unit' => '',
          'range_high' => '',
          'testcode' => 'BRME'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "Positive" text result with same line comment ending in numerics'
);
is( $labtest->result_text, 'Positive: titre 80', 'result text set properly');
is( $labtest->testcode,   'BRME', 'test code set by constructor param' );
is( $labtest->testname,   'BRME', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'testcode' => 'ASOR',
          'range_high' => '',
          'unit' => '',
          'range_low' => '',
          'result_value' => 'Positive: 400 IU/ml',
          'testname' => 'ASOR'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "positive" text result with same line comment ending in text'
);
is( $labtest->result_text, 'Positive: 400 IU/ml', 'result text set properly');
is( $labtest->testcode,   'ASOR', 'test code set by constructor param' );
is( $labtest->testname,   'ASOR', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'result_value' => 'Anti-HIV 1 DETECTED',
          'testcode' => 'HIVR',
          'testname' => 'HIVR',
          'range_low' => '',
          'range_high' => '',
          'unit' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with text result contain numeric character'
);
is( $labtest->result_text, 'Anti-HIV 1 DETECTED', 'result text set properly');
is( $labtest->testcode,   'HIVR', 'test code set by constructor param' );
is( $labtest->testname,   'HIVR', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'range_low' => '',
          'unit' => '',
          'testcode' => 'EBNL',
          'result_value' => '<3.00',
          'testname' => 'EBNL',
          'range_high' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with magnitude status but no units'
);
is( $labtest->result_text, '<3.00', 'result text set properly');
is( $labtest->testcode,   'EBNL', 'test code set by constructor param' );
is( $labtest->testname,   'EBNL', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'testcode' => 'BA',
          'range_low' => '0.0',
          'range_high' => '0.1',
          'testname' => 'BA',
          'unit' => 'x10^9/l',
          'result_value' => '.2'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with fractional result with no leading zero'
);
is( $labtest->magnitude, '.2', 'magnitude set properly');
is( $labtest->testcode,   'BA', 'test code set by constructor param' );
is( $labtest->testname,   'BA', 'test name set by constructor param' );
is( $labtest->range_low,  '0.0',    'range low set by constructor param' );
is( $labtest->range_high, '0.1',    'range high set by constructor param' );
is( $labtest->ref_range,  '0.0 - 0.1',    'ref range derived from ranges' );
is( $labtest->unit, 'x10^9/l', 'unit set by constructor param' );
ok( !( defined( $labtest->result_text ) ), 'no result text set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data= {
          'unit' => '',
          'testname' => 'UISO',
          'testcode' => 'UISO',
          'result_value' => ':
Heavy growth of Escherichia coli
Moderate growth of Enterococcus faecalis',
          'range_high' => '',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "Isolates" result'
);
is( $labtest->result_text, ':
Heavy growth of Escherichia coli
Moderate growth of Enterococcus faecalis', 'result text set properly');
is( $labtest->testcode,   'UISO', 'test code set by constructor param' );
is( $labtest->testname,   'UISO', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude text set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'testname' => 'URST',
          'unit' => '',
          'result_value' => 'COMPLETE: 21/06/12',
          'testcode' => 'URST',
          'range_low' => '',
          'range_high' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with completion date result'
);
is( $labtest->result_text, 'COMPLETE: 21/06/12', 'result text set properly');
is( $labtest->testcode,   'URST', 'test code set by constructor param' );
is( $labtest->testname,   'URST', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude text set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'unit' => '',
          'testname' => 'UWBC',
          'testcode' => 'UWBC',
          'result_value' => '++',
          'range_high' => '',
          'range_low' => ''
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with "++" result'
);
is( $labtest->result_text, '++', 'result text set properly');
is( $labtest->testcode,   'UWBC', 'test code set by constructor param' );
is( $labtest->testname,   'UWBC', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, '', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude ) ), 'no magnitude set' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude_status set' );
ok( !( defined( $labtest->comment ) ), 'no magnitude set' );

$data = {
          'testcode' => 'GFR',
          'range_high' => '',
          'testname' => 'GFR',
          'unit' => '.',
          'range_low' => '',
          'result_value' => '>90
Units: mL/min/1.73sqm
Multiply eGFR by 1.21 for people of African
Caribbean origin. Interpret with regard to
UK CKD guidelines: www.renal.org/CKDguide/ckd.html
Use with caution for adjusting drug dosages -
contact clinical pharmacist for advice.'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with ">" GFR result'
);
is( $labtest->magnitude, '90', 'magnitude set properly');
is( $labtest->comment, 'Units: mL/min/1.73sqm
Multiply eGFR by 1.21 for people of African
Caribbean origin. Interpret with regard to
UK CKD guidelines: www.renal.org/CKDguide/ckd.html
Use with caution for adjusting drug dosages -
contact clinical pharmacist for advice.', 'comment set properly');
is( $labtest->magnitude_status, '>', 'magnitude status set properly');
is( $labtest->testcode,   'GFR', 'test code set by constructor param' );
is( $labtest->testname,   'GFR', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, 'mL/min/1.73sqm', 'unit set by constructor param' );
ok( !( defined( $labtest->result_text ) ), 'no result text set' );

$data = {
          'testcode' => 'GFR',
          'testname' => 'GFR',
          'range_high' => '',
          'unit' => '.',
          'range_low' => '',
          'result_value' => '59
Units: mL/min/1.73sqm
Multiply eGFR by 1.21 for people of African
Caribbean origin. Interpret with regard to
UK CKD guidelines: www.renal.org/CKDguide/ckd.html
Use with caution for adjusting drug dosages -
contact clinical pharmacist for advice.'
        };
ok( $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
    'construct new lab test object with numeric GFR result'
);
is( $labtest->magnitude, '59', 'magnitude set properly');
is( $labtest->comment, 'Units: mL/min/1.73sqm
Multiply eGFR by 1.21 for people of African
Caribbean origin. Interpret with regard to
UK CKD guidelines: www.renal.org/CKDguide/ckd.html
Use with caution for adjusting drug dosages -
contact clinical pharmacist for advice.', 'comment set properly');
is( $labtest->testcode,   'GFR', 'test code set by constructor param' );
is( $labtest->testname,   'GFR', 'test name set by constructor param' );
is( $labtest->range_low,  '',    'range low set by constructor param' );
is( $labtest->range_high, '',    'range high set by constructor param' );
is( $labtest->ref_range,  '',    'ref range derived from ranges' );
is( $labtest->unit, 'mL/min/1.73sqm', 'unit set by constructor param' );
ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude status text set' );
ok( !( defined( $labtest->result_text ) ), 'no result text set' );


note("on line 2101");
done_testing;
