use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::LabResultReport;

my $labtest = &get_labtest_data();

ok( my $labreport = OpenEHR::Composition::LabResultReport->new(
        report_id       => '17V999333',
        labtests        => [$labtest],
        patient_comment => 'Patient feeling poorly',
    ),
    'Lab Result Report Constructor'
);

for my $format ( (qw/FLAT STRUCTURED RAW/) ) {

    ok($labreport->composition_format($format), "Set format to $format");
    ok(my $composition = $labreport->compose, "Called compose for $format format");
    is(ref($composition), "HASH", "Composition is a HASHREF");
    ok(my $json = $labreport->print_json, "Called print_json for $format format");
}


done_testing;

sub get_labtest_data {
    my $request = OpenEHR::Composition::LabTest::RequestedTest->new(
        requested_test => 'Electrolytes',
        name           => 'Electrolytes',
        code           => 'ELL',
        terminology    => 'local',
    );

    my $specimen = OpenEHR::Composition::LabTest::Specimen->new(
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

    my $labresult1 = OpenEHR::Composition::LabTest::LabResult->new(
        result_value  => '59
this is the sodium result',
        range_low     => '50',
        range_high  => '60',
        testcode      => 'NA',
        testname      => 'Sodium',
        result_status => 'Final',
    );

    my $labresult2 = OpenEHR::Composition::LabTest::LabResult->new(
        result_value  => '88
this is the potassium result',
        range_low     => '80',
        range_high  => '90',
        testcode      => 'K',
        testname      => 'Potassium',
        result_status => 'Final',
    );

    my $labpanel =
        OpenEHR::Composition::LabTest::LabTestPanel->new(
        lab_results => [ $labresult1, $labresult2 ], );

    my $placer = OpenEHR::Composition::LabTest::Placer->new(
        order_number => 'TQ001113333',
        assigner     => 'TQuest',
        issuer       => 'UCLH',
        type         => 'local',
    );

    my $filler = OpenEHR::Composition::LabTest::Filler->new(
        order_number => '17V333999',
        assigner     => 'Winpath',
        issuer       => 'UCLH Pathology',
        type         => 'local',
    );

    my $ordering_provider = OpenEHR::Composition::LabTest::OrderingProvider->new(
        given_name  => 'A&E',
        family_name => 'UCLH'
    );

    my $professional = OpenEHR::Composition::LabTest::Professional->new(
        id       => 'AB01',
        assigner => 'Carecast',
        issuer   => 'UCLH',
        type     => 'local',
    );

    my $requester = OpenEHR::Composition::LabTest::Requester->new(
        ordering_provider => $ordering_provider,
        professional      => $professional,
    );

    my $request_details = OpenEHR::Composition::LabTest::TestRequestDetails->new(
        placer    => $placer,
        filler    => $filler,
        requester => $requester,
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

    return $labtest;
}

