use strict;
use warnings;
use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::RequestedTest;
use OpenEHR::Composition::Specimen;
use OpenEHR::Composition::LabResult;
use OpenEHR::Composition::LabTestPanel;
use OpenEHR::Composition::Placer;
use OpenEHR::Composition::Filler;
use OpenEHR::Composition::Requester;
use OpenEHR::Composition::OrderingProvider;
use OpenEHR::Composition::Professional;
use OpenEHR::Composition::TestRequestDetails;

use OpenEHR::Composition::LabTest;
diag('Testing OpenEHR::Composition::LabTest '
    . $OpenEHR::Composition::LabTest::VERSION);

my $request = OpenEHR::Composition::RequestedTest->new(
    requested_test => 'Electrolytes',
    name           => 'Electrolytes',
    code           => 'ELL',
    terminology    => 'local',
);

my $specimen = OpenEHR::Composition::Specimen->new(
    specimen_type      => 'Blood',
    datetime_collected => DateTime->new(
        year   => 2017,
        month  => 11,
        day    => 20,
        hour   => 14,
        minute => 31
    ),
    collection_method => 'Phlebotomy',
    datetime_received => DateTime->new(
        year   => 2017,
        month  => 11,
        day    => 20,
        hour   => 15,
        minute => 21
    ),
    spec_id => 'bld',
);

my $labresult1 = OpenEHR::Composition::LabResult->new(
    result_value  => 59,
    comment       => 'this is the sodium result',
    ref_range     => '50-60',
    testcode      => 'NA',
    testname      => 'Sodium',
    result_status => 'Final',
);

my $labresult2 = OpenEHR::Composition::LabResult->new(
    result_value  => 88,
    comment       => 'this is the potassium result',
    ref_range     => '80-90',
    testcode      => 'K',
    testname      => 'Potassium',
    result_status => 'Final',
);

my $labpanel =
    OpenEHR::Composition::LabTestPanel->new(
    lab_results => [ $labresult1, $labresult2 ], );

my $placer = OpenEHR::Composition::Placer->new(
    order_number => 'TQ001113333',
    assigner     => 'TQuest',
    issuer       => 'UCLH',
    type         => 'local',
);

my $filler = OpenEHR::Composition::Filler->new(
    order_number => '17V333999',
    assigner     => 'Winpath',
    issuer       => 'UCLH Pathology',
    type         => 'local',
);

my $ordering_provider = OpenEHR::Composition::OrderingProvider->new(
    given_name  => 'A&E',
    family_name => 'UCLH'
);

my $professional = OpenEHR::Composition::Professional->new(
    id       => 'AB01',
    assigner => 'Carecast',
    issuer   => 'UCLH',
    type     => 'local',
);

my $requester = OpenEHR::Composition::Requester->new(
    ordering_provider => $ordering_provider,
    professional      => $professional,
);

my $request_details = OpenEHR::Composition::TestRequestDetails->new(
    placer            => $placer,
    filler            => $filler,
    ordering_provider => $ordering_provider,
    professional      => $professional,
    requester         => $requester,
);

ok( my $labtest = OpenEHR::Composition::LabTest->new(
        requested_test   => $request,
        specimens        => [$specimen],
        history_origin   => DateTime->now(),
        test_status      => 'Final',
        test_status_time => DateTime->new(
            year   => 2017,
            month  => 11,
            day    => 10,
            hour   => 14,
            minute => 12
        ),
        clinical_info   => 'Feeling unwell',
        test_panels     => [$labpanel],
        conclusion      => '',
        responsible_lab => 'Clinical Biochemistry',
        request_details => $request_details,
    ),
    'LabTest Constructor'
);

is( $labtest->composition_format,
    'STRUCTURED', 'STRUCTURED composition format set by default' );
ok( $labtest->composition_format('FLAT'), 'Set FLAT composition format' );
ok( my $flat = $labtest->compose, 'Request composition' );

ok( $labtest->composition_format('STRUCTURED'),
    'Set STRUCTURED composition format'
);
ok( my $struct = $labtest->compose, 'Request composition' );

ok( $labtest->composition_format('RAW'), 'Set RAW composition format' );
ok( my $raw = $labtest->compose, 'Request composition' );

ok( my $labtest2 = OpenEHR::Composition::LabTest->new(
        requested_test   => $request,
        specimens        => [$specimen],
        history_origin   => DateTime->now(),
        test_status      => 'Final',
        test_status_time => DateTime->new(
            year   => 2017,
            month  => 11,
            day    => 10,
            hour   => 14,
            minute => 12
        ),
        clinical_info   => undef,
        test_panels     => [$labpanel],
        conclusion      => '',
        responsible_lab => 'Clinical Biochemistry',
        request_details => $request_details,
    ),
    'LabTest Constructor with no clinical_info' 
);

is( $labtest2->composition_format,
    'STRUCTURED', 'STRUCTURED composition format set by default' );
ok( $labtest2->composition_format('FLAT'), 'Set FLAT composition format' );
ok( my $flat2 = $labtest2->compose, 'Request composition' );

ok( $labtest2->composition_format('STRUCTURED'),
    'Set STRUCTURED composition format'
);
ok( my $struct2 = $labtest2->compose, 'Request composition' );

ok( $labtest2->composition_format('RAW'), 'Set RAW composition format' );
ok( my $raw2 = $labtest2->compose, 'Request composition' );


done_testing;
