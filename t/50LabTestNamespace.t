use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::Composition;

my $ehrId = $ENV{OPENEHR_TEST_EHRID};

ok( my $labtest = OpenEHR::Composition::Elements::LabTest->new(), "Setup elements");

ok(my $request = $labtest->element('RequestedTest')->new(
    requested_test => 'Electrolytes',
    name           => 'Electrolytes',
    code           => 'ELL',
    terminology    => 'local',
), 'RequestedTest compos available');

ok( my $specimen = $labtest->element('Specimen')->new(
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
), 'Specimen compos available');

ok( my $labresult1 = $labtest->element('LabResult')->new(
    result_value  => '<59
this is the sodium result',
    range_low     => '50',
    range_high  => '60',
    testcode      => 'NA',
    testname      => 'Sodium',
    result_status => 'Final',
    unit         => 'mmol/l',
), 'LabResult compos available');

ok( my $labresult2 = $labtest->element('LabResult')->new(
    result_value  => '88
this is the potassium result',
    range_low     => '80',
    range_high  => '90',
    testcode      => 'K',
    testname      => 'Potassium',
    result_status => 'Final',
    unit         => 'g/dl',
), 'LabResult compos called 2nd time');

ok( my $labresult3 = $labtest->element('LabResult')->new(
    result_value  => '88%
this is the flourosine result',
    testcode      => 'F',
    testname      => 'Flourosine',
    result_status => 'Final',
), 'LabResult compos called 3rd time');

ok( my $labpanel =
    $labtest->element('LabTestPanel')->new(
    lab_results => [ $labresult1, $labresult2, $labresult3 ], ),
    'LabTestPanel compos called with LabResult objects');

ok( my $placer = $labtest->element('Placer')->new(
    order_number => 'TQ001113333',
    assigner     => 'TQuest',
    issuer       => 'UCLH',
    type         => 'local',
), 'Placer compos available');

ok( my $filler = $labtest->element('Filler')->new(
    order_number => '17V333999',
    assigner     => 'Winpath',
    issuer       => 'UCLH Pathology',
    type         => 'local',
), 'Filler compos available');

ok( my $ordering_provider = $labtest->element('OrderingProvider')->new(
    given_name  => 'A&E',
    family_name => 'UCLH'
), 'Ordering provider compos available');

ok( my $professional = $labtest->element('Professional')->new(
    id       => 'AB01',
    assigner => 'Carecast',
    issuer   => 'UCLH',
    type     => 'local',
), 'Professional compos available');

ok( my $requester = $labtest->element('Requester')->new(
    ordering_provider => $ordering_provider,
    professional      => $professional,
), 'Requester compos called with ordering provider and professional objects');

ok( my $request_details = $labtest->element('TestRequestDetails')->new(
    placer    => $placer,
    filler    => $filler,
    requester => $requester,
), 'TestRequestDetails called with placer, filler and requester objects');

ok( $labtest = $labtest->element('LabTest')->new(
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
), 'LabTest called with compos objects');


ok( my $labreport = OpenEHR::Composition::LabResultReport->new(
        report_id       => '17V999333',
        report_date       => DateTime->new(
            year   => 2017,
            month  => 11,
            day    => 10,
            hour   => 14,
            minute => 12
        ),
        labtests        => [$labtest],
        patient_comment => 'Patient feeling poorly',
    ),
    'Lab Result Report Constructor'
);

for my $format ( ( qw/FLAT STRUCTURED RAW/ ) ) {
    note("Begin testing $format composition");
    {
        ok( $labreport->composition_format($format),
            'Set format composition format'
        );
        my $path_report = OpenEHR::REST::Composition->new();
        ok( $path_report->composition($labreport),
            'Add composition object to rest client'
        );
        ok( $path_report->template_id('GEL - Generic Lab Report import.v0'),
            "Add template_id for $format composition" );
        SKIP: {
            skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
                unless $ENV{OPENEHR_SUBMISSION};
            
            ok( $path_report->submit_new($ehrId), "Submit $format composition" );
            diag( $path_report->err_msg ) if $path_report->err_msg;
            ok( !$path_report->err_msg, 'No Error Message set' );
            is( $path_report->action, 'CREATE', 'Action is CREATE' );
            ok( $path_report->compositionUid, 'Composition UID set' );
            ok( $path_report->href,           'HREF set' );
            note( 'Composition can be found at: ' . $path_report->href );
        };
    }
}


done_testing;
