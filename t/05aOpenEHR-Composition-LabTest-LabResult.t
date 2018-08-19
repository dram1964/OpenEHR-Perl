use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::LabTest::LabResult;
diag( 'Testing OpenEHR::Composition::LabTest::LabResult '
        . $OpenEHR::Composition::LabTest::LabResult::VERSION );

my $data;

$data = {
    result_value => 59,
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest1 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with integer result' );
is( $labtest1->magnitude, 59,       'Magnitude set from result value' );
is( $labtest1->unit,      'mmol/l', 'Unit set by constructor param' );
ok( !( defined( $labtest1->magnitude_status ) ), 'No magnitude_status set' );

$data = {
    result_value => 59.0,
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest2 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with decimal result' );
is( $labtest2->magnitude, 59.0,     'Magnitude set from result value' );
is( $labtest2->unit,      'mmol/l', 'Unit set by constructor param' );
ok( !( defined( $labtest2->magnitude_status ) ), 'No magnitude_status set' );

$data = {
    result_value => '<59',
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest3 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "less than" integer result'
);
is( $labtest3->magnitude, 59, 'Magnitude set from result value' );
is( $labtest3->magnitude_status,
    '<', 'Magnitude status set from result value' );
is( $labtest3->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '<59.0',
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest4 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "less than" decimal result'
);
is( $labtest4->magnitude, '59.0', 'Magnitude set from result value' );
is( $labtest4->magnitude_status,
    '<', 'Magnitude status set from result value' );
is( $labtest4->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '>6',
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest5 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "greater than" integer result'
);
is( $labtest5->magnitude, 6, 'Magnitude set from result value' );
is( $labtest5->magnitude_status,
    '>', 'Magnitude status set from result value' );
is( $labtest5->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '>5.0',
    range_low    => 50,
    range_high   => 60,
    unit         => 'mmol/l',
};
ok( my $labtest6 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "greater than" decimal result'
);
is( $labtest6->magnitude, '5.0', 'Magnitude set from result value' );
is( $labtest6->magnitude_status,
    '>', 'Magnitude status set from result value' );
is( $labtest6->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '59
This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    range_low  => 50,
    range_high => 60,
    unit       => 'mmol/l',
};
ok( my $labtest7 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with integer result and text comment'
);
is( $labtest7->magnitude, 59, 'Magnitude set from result value' );
is( $labtest7->comment, 'This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    'Comment set correctly from result value'
);
is( $labtest7->unit, 'mmol/l', 'Unit set by constructor param' );
ok( !( defined( $labtest7->magnitude_status ) ), 'No magnitude_status set' );

$data = {
    result_value => '59.01
This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    range_low  => 50,
    range_high => 60,
    unit       => 'mmol/l',
};
ok( my $labtest8 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with decimal result and text comment'
);
is( $labtest8->magnitude, '59.01', 'Magnitude set from result value' );
is( $labtest8->comment, 'This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    'Comment set correctly from result value'
);
is( $labtest8->unit, 'mmol/l', 'Unit set by constructor param' );
ok( !( defined( $labtest8->magnitude_status ) ), 'No magnitude_status set' );

$data = {
    result_value => '<59
This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    range_low  => 50,
    range_high => 60,
    unit       => 'mmol/l',
};
ok( my $labtest9 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "less than" integer result and text comment'
);
is( $labtest9->magnitude, '59', 'Magnitude set from result value' );
is( $labtest9->magnitude_status , '<', 'magnitude_status set from result value' );
is( $labtest9->comment, 'This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    'Comment set correctly from result value'
);
is( $labtest9->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '<59.01
This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    range_low  => 50,
    range_high => 60,
    unit       => 'mmol/l',
};
ok( my $labtest10 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "less than" decimal result and text comment'
);
is( $labtest10->magnitude, '59.01', 'Magnitude set from result value' );
is( $labtest10->magnitude_status , '<', 'magnitude_status set from result value' );
is( $labtest10->comment, 'This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    'Comment set correctly from result value'
);
is( $labtest10->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => '<0.01
This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    range_low  => 50,
    range_high => 60,
    unit       => 'mmol/l',
};
ok( my $labtest11 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with "<0.01" decimal result and text comment'
);
is( $labtest11->magnitude, '0.01', 'Magnitude set from result value' );
is( $labtest11->magnitude_status , '<', 'magnitude_status set from result value' );
is( $labtest11->comment, 'This result has been produced by 
the new methodolgy introduced on
2015-11-01
see http://www.biochem.org/new_test',
    'Comment set correctly from result value'
);
is( $labtest11->unit, 'mmol/l', 'Unit set by constructor param' );

$data = {
    result_value => 'Positive',
};
ok( my $labtest12 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with single-line text-only result value'
);
ok(!( defined( $labtest12->magnitude) ), 
    'Magnitude not set from result value' 
);
ok(!( defined( $labtest12->magnitude_status ) ),
    'magnitude_status set from result value' 
);
is( $labtest12->result_text, 'Positive', 'Result text correctly set');

ok(!( defined( $labtest12->comment ) ), 'Comment not set');
ok(!( defined(  $labtest12->unit ) ), 'No unit set by constructor param' );

$data = {
    result_value => '88%',
};
ok( my $labtest13 = OpenEHR::Composition::LabTest::LabResult->new( $data, ),
    'Construct new lab test object with numeric result but no units'
);
is( $labtest13->result_text, '88%', 'Result text correctly set');
ok(!( defined( $labtest13->magnitude) ), 
    'Magnitude not set from result value' 
);
ok(!( defined( $labtest13->magnitude_status ) ),
    'magnitude_status set from result value' 
);
ok(!( defined( $labtest13->comment ) ), 'Comment not set');
ok(!( defined(  $labtest13->unit ) ), 'No unit set by constructor param' );

done_testing;
