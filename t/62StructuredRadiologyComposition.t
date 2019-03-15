use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::RadiologyReport;

ok( my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(),
    'Setup elements namespace' );

my $report_id = 'AAACMEReport123';

my $request_id1   = 'TQ00112233';
my $receiver_id1  = 'RIS123123';
my $report_id1    = $receiver_id1 . 'REP';
my $dicom_url1    = 'http://uclh.dicom.store/image_1';
my $exam_request1 = [ 'Request1', 'Request2' ];

my $request_id2   = 'TQ00223344';
my $receiver_id2  = 'RIS345345';
my $report_id2    = $receiver_id2 . 'REP';
my $dicom_url2    = 'http://uclh.dicom.store/image_2';
my $exam_request2 = [ 'Request1', 'Request2' ];

my $result_status1 = 'at0011';
my $result_date1   = DateTime->new(
    year   => 2018,
    month  => 9,
    day    => 14,
    hour   => 12,
    minute => 45,
);
my $clinical_info1   = 'Clinical information provided 50';
my $report_text1     = 'Imaging report text 62';
my $modality1        = 'Modality 39';
my $image_file1      = [ 'Image File Reference 97', 'Image File Reference 98' ];
my $imaging_code1    = 'Imaging code 87';
my $comment1         = [ 'Comment 44', 'Comment 45' ];
my $anatomical_site1 = [ 'Anatomical Site 3', 'Anatomical Site 4' ];
my $findings1        = 'Findings 69';
my $anatomical_side1 = 'LEFT';
my $diagnosis1       = [qw/ K3123 X0038/];

my $result_status2 = 'at0010';
my $result_date2   = DateTime->new(
    year   => 2018,
    month  => 9,
    day    => 14,
    hour   => 12,
    minute => 55,
);

my $clinical_info2   = 'Clinical information provided 51';
my $report_text2     = 'Imaging report text 63';
my $modality2        = 'Modality 40';
my $image_file2      = [ 'Image file reference 99', 'Image File Reference 96' ];
my $imaging_code2    = 'Imaging code 88';
my $comment2         = [ 'Comment 47', 'Comment 46' ];
my $anatomical_site2 = [ 'Anatomical site 5', 'Anatomical Site 6' ];
my $findings2        = 'Findings 70';
my $anatomical_side2 = 'RIGHT';
my $diagnosis2       = [qw/ K3123 MT331/];

my $target = &get_structured_radiology_report;
my $target_imaging_exam1 =
  $target->{radiology_result_report}->{imaging_examination_result}->[0];
my $target_imaging_exam2 =
  $target->{radiology_result_report}->{imaging_examination_result}->[1];
my $target_request_detail1 =
  $target_imaging_exam1->{examination_request_details}->[0];
my $target_request_detail2 =
  $target_imaging_exam2->{examination_request_details}->[0];
my $target_requester_order1 =
  $target_request_detail1->{requester_order_identifier}->[0];
my $target_requester_order2 =
  $target_request_detail2->{requester_order_identifier}->[0];
my $target_receiver_order1 =
  $target_request_detail1->{receiver_order_identifier}->[0];
my $target_receiver_order2 =
  $target_request_detail2->{receiver_order_identifier}->[0];
my $target_report_reference1 =
  $target_request_detail1->{imaging_report_reference}->[0];
my $target_report_reference2 =
  $target_request_detail2->{imaging_report_reference}->[0];
my $target_imaging_report1 = $target_imaging_exam1->{any_event}->[0];
my $target_imaging_report2 = $target_imaging_exam1->{any_event}->[1];
my $target_imaging_report3 = $target_imaging_exam2->{any_event}->[0];
my $target_imaging_report4 = $target_imaging_exam2->{any_event}->[1];

ok(
    my $requester1 = $imaging_exam->element('Requester')->new(
        id => $request_id1,
    ),
    'Construct Requester Element'
);
is_deeply( $requester1->compose, $target_requester_order1,
    'Requester composition matches target' );

ok(
    my $receiver1 = $imaging_exam->element('Receiver')->new(
        id => $receiver_id1,
    ),
    'Construct Receiver Element'
);
is_deeply( $receiver1->compose, $target_receiver_order1,
    'Receiver composition matches target' );

ok(
    my $report_reference1 = $imaging_exam->element('ReportReference')->new(
        id => $report_id1,
    ),
    'Construct Report Reference Element'
);
is_deeply( $report_reference1->compose,
    $target_report_reference1, 'Report Reference composition matches target' );

ok(
    my $request_detail1 = $imaging_exam->element('RequestDetail')->new(
        requester        => $requester1,
        receiver         => $receiver1,
        report_reference => $report_reference1,
        dicom_url        => $dicom_url1,
        exam_request     => $exam_request1,
    ),
    'Construct Request Detail from Requester, Receiver and Report Reference'
);

is_deeply( $request_detail1->compose, $target_request_detail1,
    'Request Detail composition matches target' );

ok(
    my $imaging_report1 = $imaging_exam->element('ImagingReport')->new(
        clinical_info   => $clinical_info1,
        comment         => $comment1,
        diagnosis       => $diagnosis1,
        report_text     => $report_text1,
        findings        => $findings1,
        modality        => $modality1,
        anatomical_side => $anatomical_side1,
        anatomical_site => $anatomical_site1,
        result_date     => $result_date1,
        result_status   => $result_status1,
        imaging_code    => $imaging_code1,
        image_file      => $image_file1,
    ),
    'construct first imaging report object'
);

is_deeply( $imaging_report1->compose, $target_imaging_report1,
    'first imaging report matches' );

ok(
    my $imaging_report2 = $imaging_exam->element('ImagingReport')->new(
        clinical_info   => $clinical_info2,
        comment         => $comment2,
        diagnosis       => $diagnosis2,
        report_text     => $report_text2,
        findings        => $findings2,
        modality        => $modality2,
        anatomical_side => $anatomical_side2,
        anatomical_site => $anatomical_site2,
        result_date     => $result_date2,
        result_status   => $result_status2,
        imaging_code    => $imaging_code2,
        image_file      => $image_file2,
    ),
    'construct second imaging report object'
);
is_deeply( $imaging_report2->compose, $target_imaging_report2,
    'second imaging report matches' );

ok(
    my $imaging_exam_report1 = $imaging_exam->element('ImagingExam')->new(
        reports         => [ $imaging_report1, $imaging_report2 ],
        request_details => [$request_detail1],
    ),
    'Imaging Examination Report Constructor'
);
is_deeply( $imaging_exam_report1->compose,
    $target_imaging_exam1, 'Imaging Exam composition matches target' );

ok(
    my $requester2 = $imaging_exam->element('Requester')->new(
        id => $request_id2,
    ),
    'Construct Second Requester Element'
);
is_deeply( $requester2->compose, $target_requester_order2,
    'Second Requester composition matches target' );

ok(
    my $receiver2 = $imaging_exam->element('Receiver')->new(
        id => $receiver_id2,
    ),
    'Construct Second Receiver Element'
);
is_deeply( $receiver2->compose, $target_receiver_order2,
    'Second Receiver composition matches target' );

ok(
    my $report_reference2 = $imaging_exam->element('ReportReference')->new(
        id => $report_id2,
    ),
    'Construct Second Report Reference Element'
);
is_deeply( $report_reference2->compose,
    $target_report_reference2,
    'Second Report Reference composition matches target' );

ok(
    my $request_detail2 = $imaging_exam->element('RequestDetail')->new(
        requester        => $requester2,
        receiver         => $receiver2,
        report_reference => $report_reference2,
        dicom_url        => $dicom_url2,
        exam_request     => $exam_request2,
    ),
'Construct Second Request Detail from Requester, Receiver and Report Reference'
);

is_deeply( $request_detail2->compose, $target_request_detail2,
    'Second Request Detail composition matches target' );

ok(
    my $imaging_report3 = $imaging_exam->element('ImagingReport')->new(
        clinical_info   => $clinical_info1,
        comment         => $comment1,
        diagnosis       => $diagnosis1,
        report_text     => $report_text1,
        findings        => $findings1,
        modality        => $modality1,
        anatomical_side => $anatomical_side1,
        anatomical_site => $anatomical_site1,
        result_date     => $result_date1,
        result_status   => $result_status1,
        imaging_code    => $imaging_code1,
        image_file      => $image_file1,
    ),
    'construct third imaging report object'
);

is_deeply( $imaging_report3->compose, $target_imaging_report3,
    'third imaging report matches' );

ok(
    my $imaging_report4 = $imaging_exam->element('ImagingReport')->new(
        clinical_info   => $clinical_info2,
        comment         => $comment2,
        diagnosis       => $diagnosis2,
        report_text     => $report_text2,
        findings        => $findings2,
        modality        => $modality2,
        anatomical_side => $anatomical_side2,
        anatomical_site => $anatomical_site2,
        result_date     => $result_date2,
        result_status   => $result_status2,
        imaging_code    => $imaging_code2,
        image_file      => $image_file2,
    ),
    'construct second imaging report object'
);
is_deeply( $imaging_report4->compose, $target_imaging_report4,
    'fourth imaging report matches' );

ok(
    my $imaging_exam_report2 = $imaging_exam->element('ImagingExam')->new(
        reports         => [ $imaging_report3, $imaging_report4 ],
        request_details => [$request_detail2],
    ),
    'Imaging Examination Report Constructor'
);
is_deeply( $imaging_exam_report2->compose,
    $target_imaging_exam2, 'Imaging Exam composition matches target' );

ok(
    my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
        report_id    => $report_id,
        imaging_exam => [ $imaging_exam_report1, $imaging_exam_report2 ],
        report_date  => DateTime->now,
    ),
    'Radiology Report Constructor with two imaging exams'
);
is_deeply( $radiology_report->compose,
    $target, 'Radiology Report matches target' );

done_testing;

sub get_structured_radiology_report {
    my $composition = {
        'radiology_result_report' => {
            'territory' => [
                {
                    '|code'        => 'GB',
                    '|terminology' => 'ISO_3166-1'
                }
            ],
            'language' => [
                {
                    '|code'        => 'en',
                    '|terminology' => 'ISO_639-1'
                }
            ],
            'context' => [
                {
                    '_health_care_facility' => [
                        {
                            '|id'           => 'RRV',
                            '|name'         => 'UCLH NHS Foundation Trust',
                            '|id_namespace' => 'UCLH-NS',
                            '|id_scheme'    => 'UCLH-NS'
                        }
                    ],
                    'start_time' => ['2018-09-19T12:47:05.725+01:00'],
                    'setting'    => [
                        {
                            '|code'        => '238',
                            '|terminology' => 'openehr',
                            '|value'       => 'other care'
                        }
                    ],
                    'report_id' => [$report_id],
                }
            ],
            'category' => [
                {
                    '|code'        => '433',
                    '|terminology' => 'openehr',
                    '|value'       => 'event'
                }
            ],
            'composer' => [
                {
                    '|name' => 'OpenEHR-Perl-STRUCTURED'
                }
            ],
            'imaging_examination_result' => [
                {
                    'language' => [
                        {
                            '|code'        => 'en',
                            '|terminology' => 'ISO_639-1'
                        }
                    ],
                    'examination_request_details' => [
                        {
                            'requester_order_identifier' => [
                                {
                                    '|id'       => $request_id1,
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => $receiver_id1,
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => $report_id1,
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier'     => [$dicom_url1],
                            'examination_requested_name' => $exam_request1,
                        }
                    ],
                    'any_event' => [
                        {
                            'time' => [ $result_date1->datetime, ],

                            'overall_result_status' => [
                                {
                                    '|code'        => $result_status1,
                                    '|terminology' => 'local',
                                    '|value'       => 'F'
                                }
                            ],
                            'datetime_result_issued' =>
                              [ $result_date1->datetime ],
                            'clinical_information_provided' =>
                              [$clinical_info1],
                            'imaging_report_text' => [$report_text1],
                            'modality'            => [$modality1],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      [ $image_file1->[0] ]
                                },
                                {
                                    'image_file_reference' =>
                                      [ $image_file1->[1] ]
                                }
                            ],
                            'imaging_diagnosis' => $diagnosis1,
                            'imaging_code'      => [
                                {
                                    '|terminology' => 'local',
                                    '|code'        => $imaging_code1,
                                    '|value'       => $imaging_code1,
                                }
                            ],
                            'comment'             => $comment1,
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => [
                                        {
                                            '|value' => $anatomical_site1->[0],
                                            '|terminology' => 'GEL-REGION',
                                            '|code' => $anatomical_site1->[0],
                                        },
                                        {
                                            '|terminology' => 'GEL-REGION',
                                            '|value' => $anatomical_site1->[1],
                                            '|code'  => $anatomical_site1->[1],
                                        }
                                    ]
                                }
                            ],
                            'findings'        => [$findings1],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0002',
                                            '|terminology' => 'local',
                                            '|value'       => $anatomical_side1,
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'time' => [ $result_date2->datetime, ],
                            'overall_result_status' => [
                                {
                                    '|code'        => $result_status2,
                                    '|terminology' => 'local',
                                    '|value'       => 'I'
                                }
                            ],
                            'datetime_result_issued' =>
                              [ $result_date2->datetime ],
                            'clinical_information_provided' =>
                              [$clinical_info2],
                            'imaging_report_text' => [$report_text2],
                            'modality'            => [$modality2],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      [ $image_file2->[0] ]
                                },
                                {
                                    'image_file_reference' =>
                                      [ $image_file2->[1] ]
                                }
                            ],
                            'imaging_diagnosis' => $diagnosis2,
                            'imaging_code'      => [
                                {
                                    '|terminology' => 'local',
                                    '|code'        => $imaging_code2,
                                    '|value'       => $imaging_code2,
                                }
                            ],
                            'comment'             => $comment2,
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => [
                                        {
                                            '|value' => $anatomical_site2->[0],
                                            '|terminology' => 'GEL-REGION',
                                            '|code' => $anatomical_site2->[0],
                                        },
                                        {
                                            '|terminology' => 'GEL-REGION',
                                            '|value' => $anatomical_site2->[1],
                                            '|code'  => $anatomical_site2->[1],
                                        }
                                    ]
                                }
                            ],
                            'findings'        => [$findings2],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0003',
                                            '|terminology' => 'local',
                                            '|value'       => $anatomical_side2,
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    'encoding' => [
                        {
                            '|code'        => 'UTF-8',
                            '|terminology' => 'IANA_character-sets'
                        }
                    ]
                },
                {
                    'language' => [
                        {
                            '|code'        => 'en',
                            '|terminology' => 'ISO_639-1'
                        }
                    ],
                    'examination_request_details' => [
                        {
                            'requester_order_identifier' => [
                                {
                                    '|id'       => $request_id2,
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => $receiver_id2,
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => $report_id2,
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier'     => [$dicom_url2],
                            'examination_requested_name' => $exam_request2,
                        }
                    ],
                    'any_event' => [
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => $result_status1,
                                    '|terminology' => 'local',
                                    '|value'       => 'F'
                                }
                            ],
                            'datetime_result_issued' =>
                              [ $result_date1->datetime ],
                            'clinical_information_provided' =>
                              [$clinical_info1],
                            'imaging_report_text' => [$report_text1],
                            'modality'            => [$modality1],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      [ $image_file1->[0] ]
                                },
                                {
                                    'image_file_reference' =>
                                      [ $image_file1->[1] ]
                                }
                            ],
                            'imaging_diagnosis' => $diagnosis1,
                            'imaging_code'      => [
                                {
                                    '|terminology' => 'local',
                                    '|code'        => $imaging_code1,
                                    '|value'       => $imaging_code1,
                                }
                            ],

                            'comment'             => $comment1,
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => [
                                        {
                                            '|value' => $anatomical_site1->[0],
                                            '|terminology' => 'GEL-REGION',
                                            '|code' => $anatomical_site1->[0],
                                        },
                                        {
                                            '|terminology' => 'GEL-REGION',
                                            '|value' => $anatomical_site1->[1],
                                            '|code'  => $anatomical_site1->[1],
                                        }
                                    ]
                                }
                            ],
                            'findings'        => [$findings1],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0002',
                                            '|terminology' => 'local',
                                            '|value'       => $anatomical_side1,
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => $result_status2,
                                    '|terminology' => 'local',
                                    '|value'       => 'I'
                                }
                            ],
                            'datetime_result_issued' =>
                              [ $result_date2->datetime ],
                            'clinical_information_provided' =>
                              [$clinical_info2],
                            'imaging_report_text' => [$report_text2],
                            'modality'            => [$modality2],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      [ $image_file2->[0] ]
                                },
                                {
                                    'image_file_reference' =>
                                      [ $image_file2->[1] ]
                                }
                            ],
                            'imaging_diagnosis' => $diagnosis2,
                            'imaging_code'      => [
                                {
                                    '|terminology' => 'local',
                                    '|code'        => $imaging_code2,
                                    '|value'       => $imaging_code2,
                                }
                            ],
                            'comment'             => $comment2,
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => [
                                        {
                                            '|value' => $anatomical_site2->[0],
                                            '|terminology' => 'GEL-REGION',
                                            '|code' => $anatomical_site2->[0],
                                        },
                                        {
                                            '|terminology' => 'GEL-REGION',
                                            '|value' => $anatomical_site2->[1],
                                            '|code'  => $anatomical_site2->[1],
                                        }
                                    ]
                                }
                            ],
                            'findings'        => [$findings2],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0003',
                                            '|terminology' => 'local',
                                            '|value'       => $anatomical_side2,
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    'encoding' => [
                        {
                            '|code'        => 'UTF-8',
                            '|terminology' => 'IANA_character-sets'
                        }
                    ]
                },
            ]
        }
    };
    return $composition;
}
