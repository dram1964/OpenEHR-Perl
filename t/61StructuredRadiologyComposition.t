use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::RadiologyReport;

my $report_id = 'RAD0001122';

ok(my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
    report_id => $report_id,),
    'Construct new RadiologyReport object');
is($radiology_report->composition_format, 'STRUCTURED', 
    'Default format is STRUCTURED');
ok(my $composition = $radiology_report->compose, 
    'Retrieve Composition');

ok(my $report = $composition->{radiology_result_report}, 
    'Root Node Found');

note('Testing composition context');
is($report->{territory}->[0]->{'|code'}, 'GB', 'territory code set to default value');
is($report->{language}->[0]->{'|code'}, 'en', 'language code set to default value');

ok(my $facility = $report->{context}->[0]->{'_health_care_facility'}->[0],
    'facility node found');
is($facility->{'|id'}, 'RRV', 'Facility ID set correctly');
is($facility->{'|name'}, 'UCLH NHS Foundation Trust', 'Facility ID set correctly');
is($facility->{'|id_namespace'}, 'UCLH-NS', 'Facility ID set correctly');
is($facility->{'|id_scheme'}, 'UCLH-NS', 'Facility ID set correctly');

ok(my $start_time = $report->{context}->[0]->{start_time}->[0],
    'Start Time node found');
like($start_time, qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'Start time looks like a date');
ok(my $setting = $report->{context}->[0]->{setting}->[0], 
    'Setting node found');
is($setting->{'|code'}, 238, 'Default setting code');
is($setting->{'|terminology'}, 'openehr', 'Default setting terminology');
is($setting->{'|value'}, 'other care', 'Default setting value');

is($report->{context}->[0]->{report_id}->[0], $report_id,
    'Report ID set at construction');

is($report->{composer}->[0]->{'|name'},
    'OpenEHR-Perl-STRUCTURED', 'Composer name set');
isa_ok($report->{imaging_examination_result}, 'ARRAY', 'Exam Result');

note('Testing Exam Result 1');
{

    ok(my $exam1 = $report->{imaging_examination_result}->[0], 
        'Assigned first exam_result');
    ok($exam1->{language}->[0]->{'|code'}, 'Language Code defined');
    ok($exam1->{language}->[0]->{'|terminology'}, 'Language Terminology defined');

    ok(my $request_details1 =  $exam1->{examination_request_details}->[0],
        'Assigned first request details');

    ok(my $requester1 = $request_details1->{requester_order_identifier}->[0], 
        'Assigned requester');
    is($requester1->{'|id'}, '1232341234234', 'Requester order id');
    is($requester1->{'|assigner'}, 'UCLH OCS', 'Requester order assigner');
    is($requester1->{'|issuer'}, 'UCLH', 'Requester order issuer');
    is($requester1->{'|type'}, 'local', 'Requester order type');

    ok(my $receiver1 = $request_details1->{receiver_order_identifier}->[0], 
        'Assigned receiver');
    is($receiver1->{'|id'}, 'rec-1235', 'Receiver order id');
    is($receiver1->{'|assigner'}, 'PACS OCS', 'Receiver order assigner');
    is($receiver1->{'|issuer'}, 'UCLH', 'Receiver order issuer');
    is($receiver1->{'|type'}, 'local', 'Receiver order type');

    ok(my $report_ref1 = $request_details1->{imaging_report_reference}->[0], 
        'Assigned report_ref');
    is($report_ref1->{'|id'}, '99887766', 'Report reference id');
    is($report_ref1->{'|assigner'}, 'UCLH RIS', 'Report reference assigner');
    is($report_ref1->{'|issuer'}, 'UCLH', 'Report reference issuer');
    is($report_ref1->{'|type'}, 'local', 'Report reference type');

    ok(my $dicom1 = $request_details1->{dicom_study_identifier},
        'Assigned dicom reference');
    is($dicom1->[0], 'http://uclh.dicom.store/image_1',
        'First Dicom image reference');
    ok(my $exam_names1 = $request_details1->{examination_requested_name}, 
        'Assigned exam name array');
    is($exam_names1->[0], 'Request1', 'First Exam Name');
    is($exam_names1->[1], 'Request2', 'Second Exam Name');

    ok(my $result1 = $exam1->{any_event}->[0],
        'Assigned first result details');

    ok(my $result_status1 = $result1->{overall_result_status}->[0],
        'Assigned first result_status');
    is($result_status1->{'|code'}, 'at0009', 'First result status code');
    is($result_status1->{'|terminology'}, 'local', 'First result status terminology');
    is($result_status1->{'|value'}, 'Registered', 'First result status value');

    ok(my $result_date1 = $result1->{datetime_result_issued}->[0], 
        'Assigned first result date');
    like($result_date1, qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'First result date in date format');

    ok(my $clinical_info1 = $result1->{clinical_information_provided}->[0],
        'Assigned first clinical info');
    is($clinical_info1, 'Clinical information provided 50', 
        'first clinical info data');
    like($result1->{time}->[0], qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'First result time looks like date');

    ok(my $report_text1 = $result1->{imaging_report_text}->[0], 
        'Assigned first result report text');
    is($report_text1, 'Imaging report text 62', 'First report text');
    is($result1->{modality}->[0], 'Modality 39', 'First report modality');

    ok(my $image_file1 = $result1->{multimedia_resource}->[0]->{image_file_reference}->[0],
        'Assigned first result first image file');
    is($image_file1, 'Image file reference 97', 'Image file1 value');
    ok(my $image_file2 = $result1->{multimedia_resource}->[1]->{image_file_reference}->[0],
        'Assigned first result second image file');
    is($image_file2, 'Image File Reference 98', 'Image file2 value');

    is($result1->{imaging_code}->[0], 'Imaging code 87', 'First result imaging code');
    is($result1->{comment}->[0], 'Comment 44', 'First result first comment');
    is($result1->{comment}->[1], 'Comment 45', 'First result second comment');

    is($result1->{anatomical_location}->[0]->{anatomical_site}->[0],
        'Anatomical site 3', 'First result first site');
    is($result1->{anatomical_location}->[1]->{anatomical_site}->[0],
        'Anatomical Site 4', 'First result second site');
    is($result1->{findings}->[0], 'Findings 69',
        'First result findings');
    ok(my $anatomical_side1 = $result1->{anatomical_side}->[0]->{anatomical_side}->[0],
        'Assign anatomical side');
    is($anatomical_side1->{'|code'}, 'at0007', 'First Result Anatomical side code');
    is($anatomical_side1->{'|value'}, 'Not known', 'First Result Anatomical side value');
    is($anatomical_side1->{'|terminology'}, 'local', 'First Result Anatomical side terminology');

    ok(my $result2 = $exam1->{any_event}->[1],
        'Assigned second result details');

    ok(my $result_status2 = $result2->{overall_result_status}->[0],
        'Assigned first result_status');
    is($result_status2->{'|code'}, 'at0010', 'Second result status code');
    is($result_status2->{'|terminology'}, 'local', 'Second result status terminology');
    is($result_status2->{'|value'}, 'Interim', 'Second result status value');

    ok(my $result_date2 = $result2->{datetime_result_issued}->[0], 
        'Assigned first result date');
    like($result_date2, qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'Second result date in date format');

    ok(my $clinical_info2 = $result2->{clinical_information_provided}->[0],
        'Assigned first clinical info');
    is($clinical_info2, 'Clinical information provided 51', 
        'first clinical info data');
    like($result2->{time}->[0], qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'Second result time looks like date');

    ok(my $report_text1 = $result2->{imaging_report_text}->[0], 
        'Assigned first result report text');
    is($report_text1, 'Imaging report text 63', 'Second report text');
    is($result2->{modality}->[0], 'Modality 40', 'Second report modality');

    ok(my $image_file1 = $result2->{multimedia_resource}->[0]->{image_file_reference}->[0],
        'Assigned second result first image file');
    is($image_file1, 'Image file reference 99', 'Image file1 value');
    ok(my $image_file2 = $result2->{multimedia_resource}->[1]->{image_file_reference}->[0],
        'Assigned second result second image file');
    is($image_file2, 'Image File Reference 96', 'Image file2 value');

    is($result2->{imaging_code}->[0], 'Imaging code 88', 'Second result imaging code');
    is($result2->{comment}->[0], 'Comment 47', 'Second result first comment');
    is($result2->{comment}->[1], 'Comment 46', 'Second result second comment');

    is($result2->{anatomical_location}->[0]->{anatomical_site}->[0],
        'Anatomical site 5', 'Second result first site');
    is($result2->{anatomical_location}->[1]->{anatomical_site}->[0],
        'Anatomical Site 6', 'Second result second site');
    is($result2->{findings}->[0], 'Findings 70',
        'Second result findings');
    ok(my $anatomical_side2 = $result2->{anatomical_side}->[0]->{anatomical_side}->[0],
        'Assign anatomical side');
    is($anatomical_side2->{'|code'}, 'at0007', 'Second Result Anatomical side code');
    is($anatomical_side2->{'|value'}, 'Not known', 'Second Result Anatomical side value');
    is($anatomical_side2->{'|terminology'}, 'local', 'Second Result Anatomical side terminology');
}


note('Testing Exam Result 2');
{

    ok(my $exam1 = $report->{imaging_examination_result}->[1], 
        'Assigned first exam_result');
    ok($exam1->{language}->[0]->{'|code'}, 'Language Code defined');
    ok($exam1->{language}->[0]->{'|terminology'}, 'Language Terminology defined');

    ok(my $request_details1 =  $exam1->{examination_request_details}->[0],
        'Assigned first request details');

    ok(my $requester1 = $request_details1->{requester_order_identifier}->[0], 
        'Assigned requester');
    is($requester1->{'|id'}, '1232341234234', 'Requester order id');
    is($requester1->{'|assigner'}, 'UCLH OCS', 'Requester order assigner');
    is($requester1->{'|issuer'}, 'UCLH', 'Requester order issuer');
    is($requester1->{'|type'}, 'local', 'Requester order type');

    ok(my $receiver1 = $request_details1->{receiver_order_identifier}->[0], 
        'Assigned receiver');
    is($receiver1->{'|id'}, 'rec-1235', 'Receiver order id');
    is($receiver1->{'|assigner'}, 'PACS OCS', 'Receiver order assigner');
    is($receiver1->{'|issuer'}, 'UCLH', 'Receiver order issuer');
    is($receiver1->{'|type'}, 'local', 'Receiver order type');

    ok(my $report_ref1 = $request_details1->{imaging_report_reference}->[0], 
        'Assigned report_ref');
    is($report_ref1->{'|id'}, '99887766', 'Report reference id');
    is($report_ref1->{'|assigner'}, 'UCLH RIS', 'Report reference assigner');
    is($report_ref1->{'|issuer'}, 'UCLH', 'Report reference issuer');
    is($report_ref1->{'|type'}, 'local', 'Report reference type');

    ok(my $dicom1 = $request_details1->{dicom_study_identifier},
        'Assigned dicom reference');
    is($dicom1->[0], 'http://uclh.dicom.store/image_1',
        'First Dicom image reference');
    ok(my $exam_names1 = $request_details1->{examination_requested_name}, 
        'Assigned exam name array');
    is($exam_names1->[0], 'Request1', 'First Exam Name');
    is($exam_names1->[1], 'Request2', 'Second Exam Name');

    ok(my $result1 = $exam1->{any_event}->[0],
        'Assigned first result details');

    ok(my $result_status1 = $result1->{overall_result_status}->[0],
        'Assigned first result_status');
    is($result_status1->{'|code'}, 'at0009', 'First result status code');
    is($result_status1->{'|terminology'}, 'local', 'First result status terminology');
    is($result_status1->{'|value'}, 'Registered', 'First result status value');

    ok(my $result_date1 = $result1->{datetime_result_issued}->[0], 
        'Assigned first result date');
    like($result_date1, qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'First result date in date format');

    ok(my $clinical_info1 = $result1->{clinical_information_provided}->[0],
        'Assigned first clinical info');
    is($clinical_info1, 'Clinical information provided 50', 
        'first clinical info data');
    like($result1->{time}->[0], qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'First result time looks like date');

    ok(my $report_text1 = $result1->{imaging_report_text}->[0], 
        'Assigned first result report text');
    is($report_text1, 'Imaging report text 62', 'First report text');
    is($result1->{modality}->[0], 'Modality 39', 'First report modality');

    ok(my $image_file1 = $result1->{multimedia_resource}->[0]->{image_file_reference}->[0],
        'Assigned first result first image file');
    is($image_file1, 'Image file reference 97', 'Image file1 value');
    ok(my $image_file2 = $result1->{multimedia_resource}->[1]->{image_file_reference}->[0],
        'Assigned first result second image file');
    is($image_file2, 'Image File Reference 98', 'Image file2 value');

    is($result1->{imaging_code}->[0], 'Imaging code 87', 'First result imaging code');
    is($result1->{comment}->[0], 'Comment 44', 'First result first comment');
    is($result1->{comment}->[1], 'Comment 45', 'First result second comment');

    is($result1->{anatomical_location}->[0]->{anatomical_site}->[0],
        'Anatomical site 3', 'First result first site');
    is($result1->{anatomical_location}->[1]->{anatomical_site}->[0],
        'Anatomical Site 4', 'First result second site');
    is($result1->{findings}->[0], 'Findings 69',
        'First result findings');
    ok(my $anatomical_side1 = $result1->{anatomical_side}->[0]->{anatomical_side}->[0],
        'Assign anatomical side');
    is($anatomical_side1->{'|code'}, 'at0007', 'First Result Anatomical side code');
    is($anatomical_side1->{'|value'}, 'Not known', 'First Result Anatomical side value');
    is($anatomical_side1->{'|terminology'}, 'local', 'First Result Anatomical side terminology');

    ok(my $result2 = $exam1->{any_event}->[1],
        'Assigned second result details');

    ok(my $result_status2 = $result2->{overall_result_status}->[0],
        'Assigned first result_status');
    is($result_status2->{'|code'}, 'at0010', 'Second result status code');
    is($result_status2->{'|terminology'}, 'local', 'Second result status terminology');
    is($result_status2->{'|value'}, 'Interim', 'Second result status value');

    ok(my $result_date2 = $result2->{datetime_result_issued}->[0], 
        'Assigned first result date');
    like($result_date2, qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'Second result date in date format');

    ok(my $clinical_info2 = $result2->{clinical_information_provided}->[0],
        'Assigned first clinical info');
    is($clinical_info2, 'Clinical information provided 51', 
        'first clinical info data');
    like($result2->{time}->[0], qr/^\d{4,4}-\d{2,2}-\d{2,2}/, 'Second result time looks like date');

    ok(my $report_text1 = $result2->{imaging_report_text}->[0], 
        'Assigned first result report text');
    is($report_text1, 'Imaging report text 63', 'Second report text');
    is($result2->{modality}->[0], 'Modality 40', 'Second report modality');

    ok(my $image_file1 = $result2->{multimedia_resource}->[0]->{image_file_reference}->[0],
        'Assigned second result first image file');
    is($image_file1, 'Image file reference 99', 'Image file1 value');
    ok(my $image_file2 = $result2->{multimedia_resource}->[1]->{image_file_reference}->[0],
        'Assigned second result second image file');
    is($image_file2, 'Image File Reference 96', 'Image file2 value');

    is($result2->{imaging_code}->[0], 'Imaging code 88', 'Second result imaging code');
    is($result2->{comment}->[0], 'Comment 47', 'Second result first comment');
    is($result2->{comment}->[1], 'Comment 46', 'Second result second comment');

    is($result2->{anatomical_location}->[0]->{anatomical_site}->[0],
        'Anatomical site 5', 'Second result first site');
    is($result2->{anatomical_location}->[1]->{anatomical_site}->[0],
        'Anatomical Site 6', 'Second result second site');
    is($result2->{findings}->[0], 'Findings 70',
        'Second result findings');
    ok(my $anatomical_side2 = $result2->{anatomical_side}->[0]->{anatomical_side}->[0],
        'Assign anatomical side');
    is($anatomical_side2->{'|code'}, 'at0007', 'Second Result Anatomical side code');
    is($anatomical_side2->{'|value'}, 'Not known', 'Second Result Anatomical side value');
    is($anatomical_side2->{'|terminology'}, 'local', 'Second Result Anatomical side terminology');
}

done_testing;
