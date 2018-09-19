$VAR1 = {
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
                'start_time' => [ '2018-09-19T12:47:05.725+01:00' ],
                'setting'    => [
                    {
                        '|code'        => '238',
                        '|terminology' => 'openehr',
                        '|value'       => 'other care'
                    }
                ],
                'report_id' => [ '0001111333' ]
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
        '_uid' => [ '846df873-6371-4b3c-9df4-568f2ebc67b1::default::1' ],
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
                          [ 'http://uclh.dicom.store/image_1' ],
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
                          [ '2018-09-14T12:45:54.769+01:00' ],
                        'clinical_information_provided' =>
                          [ 'Clinical information provided 50' ],
                        'time' => [ '2018-09-19T12:47:05.725+01:00' ],
                        'imaging_report_text' => [ 'Imaging report text 62' ],
                        'modality'            => [ 'Modality 39' ],
                        'multimedia_resource' => [
                            {
                                'image_file_reference' =>
                                  [ 'Image file reference 97' ]
                            },
                            {
                                'image_file_reference' =>
                                  [ 'Image File Reference 98' ]
                            }
                        ],
                        'imaging_code'        => [ 'Imaging code 87' ],
                        'comment'             => [ 'Comment 44', 'Comment 45' ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [ 'Anatomical site 3' ]
                            },
                            {
                                'anatomical_site' => [ 'Anatomical Site 4' ]
                            }
                        ],
                        'findings'        => [ 'Findings 69' ],
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
                          [ '2018-09-14T12:55:54.769+01:00' ],
                        'clinical_information_provided' =>
                          [ 'Clinical information provided 51' ],
                        'time' => [ '2018-09-19T12:47:05.725+01:00' ],
                        'imaging_report_text' => [ 'Imaging report text 63' ],
                        'modality'            => [ 'Modality 40' ],
                        'multimedia_resource' => [
                            {
                                'image_file_reference' =>
                                  [ 'Image file reference 99' ]
                            },
                            {
                                'image_file_reference' =>
                                  [ 'Image File Reference 96' ]
                            }
                        ],
                        'imaging_code'        => [ 'Imaging code 88' ],
                        'comment'             => [ 'Comment 47', 'Comment 46' ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [ 'Anatomical site 5' ]
                            },
                            {
                                'anatomical_site' => [ 'Anatomical Site 6' ]
                            }
                        ],
                        'findings'        => [ 'Findings 70' ],
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
                          [ 'http://uclh.dicom.store/image_1' ],
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
                          [ '2018-09-14T12:45:54.769+01:00' ],
                        'clinical_information_provided' =>
                          [ 'Clinical information provided 50' ],
                        'time' => [ '2018-09-19T12:47:05.725+01:00' ],
                        'imaging_report_text' => [ 'Imaging report text 62' ],
                        'modality'            => [ 'Modality 39' ],
                        'multimedia_resource' => [
                            {
                                'image_file_reference' =>
                                  [ 'Image file reference 97' ]
                            },
                            {
                                'image_file_reference' =>
                                  [ 'Image File Reference 98' ]
                            }
                        ],
                        'imaging_code'        => [ 'Imaging code 87' ],
                        'comment'             => [ 'Comment 44', 'Comment 45' ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [ 'Anatomical site 3' ]
                            },
                            {
                                'anatomical_site' => [ 'Anatomical Site 4' ]
                            }
                        ],
                        'findings'        => [ 'Findings 69' ],
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
                          [ '2018-09-14T12:55:54.769+01:00' ],
                        'clinical_information_provided' =>
                          [ 'Clinical information provided 51' ],
                        'time' => [ '2018-09-19T12:47:05.725+01:00' ],
                        'imaging_report_text' => [ 'Imaging report text 63' ],
                        'modality'            => [ 'Modality 40' ],
                        'multimedia_resource' => [
                            {
                                'image_file_reference' =>
                                  [ 'Image file reference 99' ]
                            },
                            {
                                'image_file_reference' =>
                                  [ 'Image File Reference 96' ]
                            }
                        ],
                        'imaging_code'        => [ 'Imaging code 88' ],
                        'comment'             => [ 'Comment 47', 'Comment 46' ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [ 'Anatomical site 5' ]
                            },
                            {
                                'anatomical_site' => [ 'Anatomical Site 6' ]
                            }
                        ],
                        'findings'        => [ 'Findings 70' ],
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
