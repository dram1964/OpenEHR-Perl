use strict;
use warnings;
use Test::More;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::REST::Composition;

my $requester = OpenEHR::Composition::Elements::ImagingExam::Requester->new(
    id => '1232341234234',
);
my $receiver = OpenEHR::Composition::Elements::ImagingExam::Receiver->new(
    id => 'rec-1235',
);
my $report_reference = OpenEHR::Composition::Elements::ImagingExam::ReportReference->new(
    id => '99887766',
);
my $request_detail = OpenEHR::Composition::Elements::ImagingExam::RequestDetail->new(
    requester => $requester,
    receiver => $receiver,
    report_reference => $report_reference,
    exam_request => [ qw/ Request1 Request2/ ],
    dicom_url => 'http://uclh.dicom.store/image_1',
);

my $imaging_report1 = OpenEHR::Composition::Elements::ImagingExam::ImagingReport->new(
    clinical_info => 'Clinical information provided 50',
    comment => ['Comment 44', 'Comment 45'],
    report_text => 'Imaging report text 62',
    imaging_diagnosis => ['Imaging diagnosis 29', 'Imaging Diagnosis 30'],
    findings => 'Findings 69',
    modality => 'Modality 39',
    anatomical_side => 'at0007',
    result_date => DateTime->new(
        year => 2018,
        month => 9,
        day => 14,
        hour => 12,
        minute => 45,
    ),
    anatomical_site => ['Anatomical site 3', 'Anatomical Site 4'],
    imaging_code => 'Imaging code 87',
    result_status => 'at0009',
    image_file => ['Image file reference 97', 'Image File Reference 98'],
);
my $imaging_report2 = OpenEHR::Composition::Elements::ImagingExam::ImagingReport->new(
    clinical_info => 'Clinical information provided 51',
    comment => ['Comment 47', 'Comment 46'],
    report_text => 'Imaging report text 63',
    imaging_diagnosis => ['Imaging diagnosis 31', 'Imaging Diagnosis 32'],
    findings => 'Findings 70',
    modality => 'Modality 40',
    anatomical_side => 'at0007',
    result_date => DateTime->new(
        year => 2018,
        month => 9,
        day => 14,
        hour => 12,
        minute => 55,
    ),
    anatomical_site => ['Anatomical site 5', 'Anatomical Site 6'],
    imaging_code => 'Imaging code 88',
    result_status => 'at0010',
    image_file => ['Image file reference 99', 'Image File Reference 96'],
);



my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
    request_details => [$request_detail],
    reports => [$imaging_report1, $imaging_report2],
);

ok( my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
    report_id => '0001111333',
    imaging_exam => [$imaging_exam, $imaging_exam],
    report_date => DateTime->now,
), 'RadiologyReport Constructor');

my $rest_client = OpenEHR::REST::Composition->new();

for my $format ( ( qw/FLAT STRUCTURED RAW/ ) ) {
    SKIP: {
        skip "RAW compositions not implemented for RadiologyReports", 1 if ($format eq 'RAW');
        note("Testing submit_new method with $format composition");
        ok( $radiology_report->composition_format($format), "Set $format composition format" );

        my $compos = $radiology_report->compose;
#print Dumper $compos;

        ok( $rest_client->composition($radiology_report),
            'Add composition object to rest client'
        );
        ok( $rest_client->template_id('GEL Generic radiology report import.v0'),
            "Add template_id for $format composition" );
        SKIP: {
            skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
                unless $ENV{OPENEHR_SUBMISSION};
        ok( $rest_client->submit_new( $radiology_report->test_ehrid ), 'Submit composition' );
        diag( $rest_client->err_msg ) if $rest_client->err_msg;
        ok( !$rest_client->err_msg, 'No Error Message set' );
        is( $rest_client->action, 'CREATE', 'Action is CREATE' );
        ok( $rest_client->compositionUid, 'Composition UID set' );
        ok( $rest_client->href,           'HREF set' );
        note( 'Composition can be found at: ' . $rest_client->href );
        };
    }
}

done_testing;
