$VAR1 = {
    'laboratory_result_report' => {
        'patient_comment' => [
            {   'comment'  => [ 'Patient feeling poorly' ],
                'encoding' => [
                    {   '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'language' => [
                    {   '|terminology' => 'ISO_639-1',
                        '|code'        => 'en'
                    }
                ]
            }
        ],
        'category' => [
            {   '|terminology' => 'openehr',
                '|value'       => 'event',
                '|code'        => '433'
            }
        ],
        'territory' => [
            {   '|code'        => 'GB',
                '|terminology' => 'ISO_3166-1'
            }
        ],
        '_uid' => [ '107c6d6d-cc84-45c5-8e4c-c4a3aaa7bbd8::default::1' ],
        'laboratory_test' => [
            {   'time'     => [ '2018-09-06T16:55:24.208+01:00' ],
                'specimen' => [
                    {   'processing' => [
                            {   'laboratory_specimen_identifier' => [
                                    {   '|issuer'   => 'UCLH Pathology',
                                        '|type'     => 'local',
                                        '|id'       => 'bld',
                                        '|assigner' => 'Winpath'
                                    }
                                ],
                                'datetime_received' => [ '2017-11-20T15:21Z' ]
                            }
                        ],
                        'specimen_type'      => [ 'Blood' ],
                        'datetime_collected' => [ '2017-11-20T14:31Z' ],
                        'collection_method'  => [ 'Phlebotomy' ]
                    }
                ],
                'test_request_details' => [
                    {   'filler_order_number' => [
                            {   '|assigner' => 'Winpath',
                                '|issuer'   => 'UCLH Pathology',
                                '|type'     => 'local',
                                '|id'       => '17V333999'
                            }
                        ],
                        'requester' => [
                            {   'ordering_provider' => [
                                    {   'ordering_provider' => [
                                            {   'family_name' => [ 'UCLH' ],
                                                'given_name'  => [ 'A&E' ]
                                            }
                                        ]
                                    }
                                ],
                                'professional_identifier' => [
                                    {   '|assigner' => 'Carecast',
                                        '|issuer'   => 'UCLH',
                                        '|type'     => 'local',
                                        '|id'       => 'AB01'
                                    }
                                ]
                            }
                        ],
                        'placer_order_number' => [
                            {   '|assigner' => 'TQuest',
                                '|type'     => 'local',
                                '|id'       => 'TQ001113333',
                                '|issuer'   => 'UCLH'
                            }
                        ]
                    }
                ],
                'test_status_timestamp'  => [ '2017-11-10T14:12Z' ],
                'responsible_laboratory' => [
                    { 'name_of_organisation' => [ 'Clinical Biochemistry' ] }
                ],
                'clinical_information_provided' => [ 'Feeling unwell' ],
                'language'                      => [
                    {   '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'requested_test' => [
                    {   '|terminology' => 'local',
                        '|code'        => 'ELL',
                        '|value'       => 'Electrolytes'
                    }
                ],
                'laboratory_test_panel' => [
                    {   'laboratory_result' => [
                            {   'result_status' => [
                                    {   '|code'        => 'at0009',
                                        '|value'       => 'Final',
                                        '|terminology' => 'local'
                                    }
                                ],
                                'result_value' => [
                                    {   '_name' => [
                                            {   '|terminology' => 'Local',
                                                '|code'        => 'NA',
                                                '|value'       => 'Sodium'
                                            }
                                        ],
                                        'quantity_value' => [
                                            {   '_normal_range' => [
                                                    {   'upper' => [
                                                            {   '|unit' =>
                                                                    'mmol/l',
                                                                '|magnitude'
                                                                    => '60'
                                                            }
                                                        ],
                                                        'lower' => [
                                                            {   '|unit' =>
                                                                    'mmol/l',
                                                                '|magnitude'
                                                                    => '50'
                                                            }
                                                        ]
                                                    }
                                                ],
                                                '|magnitude_status' => '<',
                                                '|unit'      => 'mmol/l',
                                                '|magnitude' => '59'
                                            }
                                        ]
                                    }
                                ],
                                'comment' => [ 'this is the sodium result' ],
                                'reference_range_guidance' => [ '50 - 60' ]
                            },
                            {   'reference_range_guidance' => [ '80 - 90' ],
                                'comment' =>
                                    [ 'this is the potassium result' ],
                                'result_value' => [
                                    {   'quantity_value' => [
                                            {   '|magnitude'    => '88',
                                                '|unit'         => 'g/dl',
                                                '_normal_range' => [
                                                    {   'upper' => [
                                                            {   '|unit' =>
                                                                    'g/dl',
                                                                '|magnitude'
                                                                    => '90'
                                                            }
                                                        ],
                                                        'lower' => [
                                                            {   '|unit' =>
                                                                    'g/dl',
                                                                '|magnitude'
                                                                    => '80'
                                                            }
                                                        ]
                                                    }
                                                ]
                                            }
                                        ],
                                        '_name' => [
                                            {   '|code'        => 'K',
                                                '|value'       => 'Potassium',
                                                '|terminology' => 'Local'
                                            }
                                        ]
                                    }
                                ],
                                'result_status' => [
                                    {   '|terminology' => 'local',
                                        '|code'        => 'at0009',
                                        '|value'       => 'Final'
                                    }
                                ]
                            },
                            {   'result_value' => [
                                    {   '_name' => [
                                            {   '|code'  => 'F',
                                                '|value' => 'Flourosine',
                                                '|terminology' => 'Local'
                                            }
                                        ],
                                        'text_value' => [
                                            '88%
this is the flourosine result'
                                        ]
                                    }
                                ],
                                'result_status' => [
                                    {   '|value'       => 'Final',
                                        '|code'        => 'at0009',
                                        '|terminology' => 'local'
                                    }
                                ]
                            }
                        ]
                    }
                ],
                'encoding' => [
                    {   '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'test_status' => [
                    {   '|code'        => 'at0038',
                        '|value'       => 'Final',
                        '|terminology' => 'local'
                    }
                ]
            }
        ],
        'language' => [
            {   '|terminology' => 'ISO_639-1',
                '|code'        => 'en'
            }
        ],
        'context' => [
            {   'setting' => [
                    {   '|terminology' => 'openehr',
                        '|code'        => '238',
                        '|value'       => 'other care'
                    }
                ],
                'report_id'  => [ '17V999333' ],
                'start_time' => [ '2018-09-06T16:55:24.208+01:00' ],
                '_health_care_facility' => [
                    {   '|id'           => 'RRV',
                        '|id_scheme'    => 'UCLH-NS',
                        '|name'         => 'UCLH NHS Foundation Trust',
                        '|id_namespace' => 'UCLH-NS'
                    }
                ]
            }
        ],
        'composer' => [ { '|name' => 'OpenEHR-Perl-FLAT' } ]
    }
};
