use strict;
use warnings;
use Test::More;
use Data::Dumper;
use DateTime;
use JSON;
use OpenEHR::REST::Composition;

use OpenEHR::Composition::LabResultReport;

my $config_file = 'OpenEHR.conf';
open( my $fh, '<', $config_file ) or warn "Unable to read $config_file:$!";
my %config;
while ( my $line = <$fh> ) {
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    $config{$param} = $value;
}

my $ehrId = $ENV{OPENEHR_TEST_EHRID} || $config{test_ehrid};

my $request = OpenEHR::Composition::Elements::LabTest::RequestedTest->new(
    requested_test => 'Electrolytes',
    name           => 'Electrolytes',
    code           => 'ELL',
    terminology    => 'local',
);

my $specimen = OpenEHR::Composition::Elements::LabTest::Specimen->new(
    specimen_type      => 'Blood',
    datetime_collected => DateTime->new(
        year   => 2017,
        month  => 11,
        day    => 20,
        hour   => 14,
        minute => 31
    ),
    datetime_received => DateTime->new(
        year   => 2017,
        month  => 11,
        day    => 20,
        hour   => 15,
        minute => 21
    ),
    spec_id => 'bld',
);

my $labresult1 = OpenEHR::Composition::Elements::LabTest::LabResult->new(
    result_value  => '<59
this is the sodium result',
    range_low     => '50',
    range_high  => '60',
    testcode      => 'NA',
    testname      => 'Sodium',
    result_status => 'Final',
    unit         => 'mmol/l',
);

my $labresult2 = OpenEHR::Composition::Elements::LabTest::LabResult->new(
    result_value  => '88
this is the potassium result',
    range_low     => '80',
    range_high  => '90',
    testcode      => 'K',
    testname      => 'Potassium',
    result_status => 'Final',
    unit         => 'g/dl',
);

my $labresult3 = OpenEHR::Composition::Elements::LabTest::LabResult->new(
    result_value  => '88%
this is the flourosine result',
    testcode      => 'F',
    testname      => 'Flourosine',
    result_status => 'Final',
);

my $labpanel =
    OpenEHR::Composition::Elements::LabTest::LabTestPanel->new(
    lab_results => [ $labresult1, $labresult2, $labresult3 ], );

my $placer = OpenEHR::Composition::Elements::LabTest::Placer->new(
    order_number => 'TQ001113333',
    assigner     => 'TQuest',
    issuer       => 'UCLH',
    type         => 'local',
);

my $filler = OpenEHR::Composition::Elements::LabTest::Filler->new(
    order_number => '17V333999',
    assigner     => 'Winpath',
    issuer       => 'UCLH Pathology',
    type         => 'local',
);

my $ordering_provider = OpenEHR::Composition::Elements::LabTest::OrderingProvider->new(
    given_name  => 'A&E',
    family_name => 'UCLH'
);

my $professional = OpenEHR::Composition::Elements::LabTest::Professional->new(
    id       => 'AB01',
    assigner => 'Carecast',
    issuer   => 'UCLH',
    type     => 'local',
);

my $requester = OpenEHR::Composition::Elements::LabTest::Requester->new(
    ordering_provider => $ordering_provider,
    professional      => $professional,
);

my $request_details = OpenEHR::Composition::Elements::LabTest::TestRequestDetails->new(
    placer    => $placer,
    filler    => $filler,
    requester => $requester,
);

my $labtest = OpenEHR::Composition::Elements::LabTest->new(
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
);

ok( my $labreport = OpenEHR::Composition::LabResultReport->new(
        report_id       => '17V999333',
        report_date    => DateTime->new(
            year    => 2017, 
            month => 11,
            day => 10,
            hour => 14,
            minute => 45,
        ),
        labtests        => [$labtest],
        patient_comment => 'Patient feeling poorly',
    ),
    'Lab Result Report Constructor'
);

for my $format ( (qw/FLAT STRUCTURED RAW/)) { 
    note("Begin testing $format composition");
    {
        ok( $labreport->composition_format($format),
            "Set $format composition format"
        );
        my $path_report = OpenEHR::REST::Composition->new();
        ok( $path_report->composition($labreport),
            'Add composition object to rest client'
        );
        unless ($format eq 'RAW') {
            ok( $path_report->template_id('GEL - Generic Lab Report import.v0'),
                "Add template_id for $format composition" );
        }
        SKIP: {
            skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
                unless $ENV{OPENEHR_SUBMISSION};
            ok( $path_report->submit_new($ehrId), 'Submit composition' );
            diag( $path_report->err_msg ) if $path_report->err_msg;
            ok( !$path_report->err_msg, 'No Error Message set' );
            is( $path_report->action, 'CREATE', 'Action is CREATE' );
            ok( $path_report->compositionUid, 'Composition UID set' );
            ok( $path_report->href,           'HREF set' );
            note( 'Composition can be found at: ' . $path_report->href );
        };
    }
}

SKIP: {
    skip "TDD compositions not yet supported", 1;
    note('Begin testing TDD composition');
    {
        ok( $labreport->composition_format('TDD'),
            'Set TDD composition format' );
        my $path_report = OpenEHR::REST::Composition->new();
        ok( $path_report->composition($labreport),
            'Add composition to rest client'
        );
        ok( $path_report->submit_new($ehrId), 'Submit composition' );
        diag( $path_report->err_msg ) if $path_report->err_msg;
        ok( !$path_report->err_msg, 'No Error Message set' );
        is( $path_report->action, 'CREATE', 'Action is CREATE' );
        ok( $path_report->compositionUid, 'Composition UID set' );
        ok( $path_report->href,           'HREF set' );
        note( 'Composition can be found at: ' . $path_report->href );
    }
};

done_testing;
