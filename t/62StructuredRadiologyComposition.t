use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::RadiologyReport;

ok( my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(),
    'Setup elements namespace' );

my $request_id   = 'TQ00112233';
my $receiver_id  = 'RIS123123';
my $report_id    = $receiver_id . 'REP';
my $dicom_url    = 'http://uclh.dicom.store/image_1';
my $exam_request = [ 'Request1', 'Request2' ];

my $result_status1 = 'at0009'; 
my $result_date1 = '2018-09-14T12:45:54.769+01:00'; 
my $clinical_info1 = 'Clinical information provided 50'; 
my $report_text1 = 'Imaging report text 62'; 
my $modality1 = 'Modality 39';
my $image_file1 = ['Image File Reference 97', 'Image File Reference 98']; 
my $imaging_code1 = 'Imaging code 87';
my $comment1 = [ 'Comment 44', 'Comment 45' ];
my $anatomical_site1 = ['Anatomical Site 3', 'Anatomical Site 4'];
my $findings1 = 'Findings 69';
my $anatomical_side1 = 'at0007';
my $diagnosis1 = [qw/ K3123 X0038/];

my $target = &get_structured_radiology_report;
my $target_request_detail =
  $target->{radiology_result_report}->{imaging_examination_result}->[0]
  ->{examination_request_details}->[0];
my $target_requester_order =
  $target_request_detail->{requester_order_identifier}->[0];
my $target_receiver_order =
  $target_request_detail->{receiver_order_identifier}->[0];
my $target_report_reference =
  $target_request_detail->{imaging_report_reference}->[0];
my $target_imaging_report1 =
  $target->{radiology_result_report}->{imaging_examination_result}->[0]->{any_event}->[0];

print Dumper $target_imaging_report1;

ok(
    my $requester = $imaging_exam->element('Requester')->new(
        id => $request_id,
    ),
    'Construct Requester Element'
);
is_deeply( $requester->compose, $target_requester_order,
    'Requester composition matches target' );

ok(
    my $receiver = $imaging_exam->element('Receiver')->new(
        id => $receiver_id,
    ),
    'Construct Receiver Element'
);
is_deeply( $receiver->compose, $target_receiver_order,
    'Receiver composition matches target' );

ok(
    my $report_reference = $imaging_exam->element('ReportReference')->new(
        id => $report_id,
    ),
    'Construct Report Reference Element'
);
is_deeply( $report_reference->compose,
    $target_report_reference, 'Report Reference composition matches target' );

ok(
    my $request_detail = $imaging_exam->element('RequestDetail')->new(
        requester        => $requester,
        receiver         => $receiver,
        report_reference => $report_reference,
        dicom_url        => $dicom_url,
        exam_request     => $exam_request,
    ),
    'Construct Request Detail from Requester, Receiver and Report Reference'
);

is_deeply( $request_detail->compose, $target_request_detail,
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
    'Construct Imaging Report object'
);

is_deeply( $imaging_report1->compose, $target_imaging_report1, 
    'First imaging report matches');

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
                    'report_id' => ['0001111333']
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
                    '|name' => 'OpenEHR-Perl-FLAT'
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
                                    '|id'       => $request_id,
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => $receiver_id,
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => $report_id,
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier'     => [$dicom_url],
                            'examination_requested_name' => $exam_request,
                        }
                    ],
                    'any_event' => [
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => $result_status1, 
                                    '|terminology' => 'local',
                                    '|value'       => 'Registered'
                                }
                            ],
                            'datetime_result_issued' =>
                              [$result_date1],
                            'clinical_information_provided' =>
                              [$clinical_info1],
                            'imaging_report_text' => [$report_text1],
                            'modality'            => [$modality1],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      [$image_file1->[0]]
                                },
                                {
                                    'image_file_reference' =>
                                      [$image_file1->[1]]
                                }
                            ],
                            'imaging_diagnosis' => $diagnosis1,
                            'imaging_code' => [$imaging_code1],
                            'comment'      => $comment1, 
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => [$anatomical_site1->[0]]
                                },
                                {
                                    'anatomical_site' => [$anatomical_site1->[1]]
                                }
                            ],
                            'findings'        => [$findings1], 
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => $anatomical_side1, 
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0010',
                                    '|terminology' => 'local',
                                    '|value'       => 'Interim'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:55:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 51'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 63'],
                            'modality'            => ['Modality 40'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 99']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 96']
                                }
                            ],
                            'imaging_code' => ['Imaging code 88'],
                            'comment'      => [ 'Comment 47', 'Comment 46' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 5']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 6']
                                }
                            ],
                            'findings'        => ['Findings 70'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
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
                                    '|id'       => '1232341234234',
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => 'rec-1235',
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => '99887766',
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier' =>
                              ['http://uclh.dicom.store/image_1'],
                            'examination_requested_name' =>
                              [ 'Request1', 'Request2' ]
                        }
                    ],
                    'any_event' => [
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0009',
                                    '|terminology' => 'local',
                                    '|value'       => 'Registered'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:45:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 50'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 62'],
                            'modality'            => ['Modality 39'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 97']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 98']
                                }
                            ],
                            'imaging_code' => ['Imaging code 87'],
                            'comment'      => [ 'Comment 44', 'Comment 45' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 3']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 4']
                                }
                            ],
                            'findings'        => ['Findings 69'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0010',
                                    '|terminology' => 'local',
                                    '|value'       => 'Interim'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:55:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 51'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 63'],
                            'modality'            => ['Modality 40'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 99']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 96']
                                }
                            ],
                            'imaging_code' => ['Imaging code 88'],
                            'comment'      => [ 'Comment 47', 'Comment 46' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 5']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 6']
                                }
                            ],
                            'findings'        => ['Findings 70'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
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
                }
            ]
        }
    };
    return $composition;
}
