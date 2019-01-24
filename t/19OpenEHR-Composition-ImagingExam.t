use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::Elements::ImagingExam;
use OpenEHR::Composition::Elements::ImagingExam::ImagingReport;
use OpenEHR::Composition::Elements::ImagingExam::RequestDetail;
use OpenEHR::Composition::Elements::ImagingExam::Requester;
use OpenEHR::Composition::Elements::ImagingExam::Receiver;
use OpenEHR::Composition::Elements::ImagingExam::ReportReference;

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
    result_date => '2018-09-14T12:45:54.769+01:00',
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
    anatomical_side => 'at0008',
    result_date => '2018-09-14T12:55:54.769+01:00',
    anatomical_site => ['Anatomical site 5', 'Anatomical Site 6'],
    imaging_code => 'Imaging code 88',
    result_status => 'at0010',
    image_file => ['Image file reference 99', 'Image File Reference 96'],
);



ok(my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
    request_details => [$request_detail, $request_detail],
    reports => [$imaging_report1, $imaging_report2],
), 'ImagingExam Constructor');



for my $format ( (qw/FLAT/) ) {
    ok($imaging_exam->composition_format($format), "Set format to $format");
    ok(my $composition = $imaging_exam->compose, "Called compose for $format format");
    is(ref($composition), "HASH", "Composition is a HASHREF");
    ok(my $json = $imaging_exam->print_json, "Called print_json for $format format");
    print Dumper $composition;
}


done_testing;
