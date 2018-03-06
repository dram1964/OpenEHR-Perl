use strict;
use warnings;
use Test::More;
use Data::Dumper;
use DateTime;
use JSON;
use OpenEHR::REST::PathologyReport;

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
use OpenEHR::Composition::LabResultReport;

my $config_file = 'OpenEHR.conf';
open( my $fh, '<', $config_file ) or warn "Unable to read $config_file:$!";
my %config;
while ( my $line = <$fh> ) {
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    $config{$param} = $value;
}

my $ehrId = $config{test_ehrid};

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

my $labtest = OpenEHR::Composition::LabTest->new(
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
        labtests        => [$labtest],
        patient_comment => 'Patient feeling poorly',
    ),
    'Lab Result Report Constructor'
);

note('Begin testing FLAT composition');
{
    ok( $labreport->composition_format('FLAT'),
        'Set FLAT composition format'
    );
    my $path_report = OpenEHR::REST::PathologyReport->new();
    ok( $path_report->composition($labreport),
        'Add composition object to rest client'
    );
    ok( $path_report->submit_new($ehrId), 'Submit composition' );
    diag( $path_report->err_msg ) if $path_report->err_msg;
    ok( !$path_report->err_msg, 'No Error Message set' );
    is( $path_report->action, 'CREATE', 'Action is CREATE' );
    ok( $path_report->compositionUid, 'Composition UID set' );
    ok( $path_report->href,           'HREF set' );
    note( 'Composition can be found at: ' . $path_report->href );
}

note('Begin testing STRUCTURED composition');
{
    ok( $labreport->composition_format('STRUCTURED'),
        'Set STRUCTURED composition format'
    );
    my $path_report = OpenEHR::REST::PathologyReport->new();
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

note('Begin testing RAW composition');
{
    ok( $labreport->composition_format('RAW'), 'Set RAW composition format' );
    my $path_report = OpenEHR::REST::PathologyReport->new();
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

SKIP: {
    skip "TDD compositions not yet supported", 1;
    note('Begin testing TDD composition');
    {
        ok( $labreport->composition_format('TDD'),
            'Set TDD composition format' );
        my $path_report = OpenEHR::REST::PathologyReport->new();
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
}

done_testing;