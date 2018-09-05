65 b1dd2b- 2586 - 4628 -a76a-fb8dd7285b19::default::1 $VAR1 = {
    'laboratory_result_report' => {
        'territory' => [
            {
                '|code'        => 'GB',
                '|terminology' => 'ISO_3166-1'
            }
        ],
        'laboratory_test' => [
            {
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'clinical_information_provided' => [ 'Patient feeling unwell' ],
                'time'        => [ '2018-09-03T14:08:55+01:00' ],
                'test_status' => [
                    {
                        '|code'        => 'at0038',
                        '|terminology' => 'local',
                        '|value'       => 'Final'
                    }
                ],
                'responsible_laboratory' => [
                    {
                        'name_of_organisation' => [ 'UCLH Pathology' ]
                    }
                ],
                'requested_test' => [
                    {
                        '|code'        => 'ELL',
                        '|terminology' => 'local',
                        '|value'       => 'Electrolytes'
                    }
                ],
                'test_request_details' => [
                    {
                        'placer_order_number' => [
                            {
                                '|id'       => 'TQ00112233',
                                '|assigner' => 'TQuest',
                                '|issuer'   => 'UCLH',
                                '|type'     => 'local'
                            }
                        ],
                        'requester' => [
                            {
                                'professional_identifier' => [
                                    {
                                        '|id'       => 'AB01',
                                        '|assigner' => 'Carecast',
                                        '|issuer'   => 'UCLH',
                                        '|type'     => 'local'
                                    }
                                ],
                                'ordering_provider' => [
                                    {
                                        'ordering_provider' => [
                                            {
                                                'family_name' => [ 'UCLH' ],
                                                'given_name'  => [ 'ITU1' ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        ],
                        'filler_order_number' => [
                            {
                                '|id'       => '17V333322',
                                '|assigner' => 'Winpath',
                                '|issuer'   => 'UCLH Pathology',
                                '|type'     => 'local'
                            }
                        ]
                    }
                ],
                'test_status_timestamp' => [ '2017-12-01T01:30Z' ],
                'specimen'              => [
                    {
                        'collection_method'  => [ 'Phlebotomy' ],
                        'datetime_collected' => [ '2017-12-01T01:10Z' ],
                        'processing'         => [
                            {
                                'laboratory_specimen_identifier' => [
                                    {
                                        '|id'       => '17V333322',
                                        '|assigner' => 'Winpath',
                                        '|issuer'   => 'UCLH Pathology',
                                        '|type'     => 'local'
                                    }
                                ],
                                'datetime_received' => [ '2017-12-01T01:30Z' ]
                            }
                        ],
                        'specimen_type' => [ 'Blood' ]
                    }
                ],
                'laboratory_test_panel' => [
                    {
                        'laboratory_result' => [
                            {
                                'result_value' => [
                                    {
                                        '_name' => [
                                            {
                                                '|code'        => 'NA',
                                                '|terminology' => 'Local',
                                                '|value'       => 'Sodium',
                                                '_mapping'     => [
                                                    {
                                                        'target' => [
                                                            {
                                                                '|code' =>
                                                                  '5195-3',
                                                                '|terminology'
                                                                  => 'LOINC'
                                                            }
                                                        ],
                                                        '|match' => '='
                                                    }
                                                ]
                                            }
                                        ],
                                        'quantity_value' => [
                                            {
                                                '_normal_range' => [
                                                    {
                                                        'upper' => [
                                                            {
                                                                '|unit' =>
                                                                  'mmol/l',
                                                                '|magnitude' =>
                                                                  '90'
                                                            }
                                                        ],
                                                        'lower' => [
                                                            {
                                                                '|unit' =>
                                                                  'mmol/l',
                                                                '|magnitude' =>
                                                                  '80'
                                                            }
                                                        ]
                                                    }
                                                ],
                                                '|unit'             => 'mmol/l',
                                                '|magnitude_status' => '<',
                                                '|magnitude'        => '88.9'
                                            }
                                        ]
                                    }
                                ],
                                'reference_range_guidance' => [ '80-90' ],
                                'comment' => [ 'This is the sodium comment' ],
                                'result_status' => [
                                    {
                                        '|code'        => 'at0009',
                                        '|terminology' => 'local',
                                        '|value'       => 'Final'
                                    }
                                ]
                            },
                            {
                                'result_value' => [
                                    {
                                        '_name' => [
                                            {
                                                '|code'        => 'K',
                                                '|terminology' => 'Local',
                                                '|value'       => 'Potassium',
                                                '_mapping'     => [
                                                    {
                                                        'target' => [
                                                            {
                                                                '|code' =>
                                                                  '5195-3',
                                                                '|terminology'
                                                                  => 'LOINC'
                                                            }
                                                        ],
                                                        '|match' => '='
                                                    }
                                                ]
                                            }
                                        ],
                                        'quantity_value' => [
                                            {
                                                '_normal_range' => [
                                                    {
                                                        'upper' => [
                                                            {
                                                                '|unit' =>
                                                                  'mmol/l',
                                                                '|magnitude' =>
                                                                  '70'
                                                            }
                                                        ],
                                                        'lower' => [
                                                            {
                                                                '|unit' =>
                                                                  'mmol/l',
                                                                '|magnitude' =>
                                                                  '50'
                                                            }
                                                        ]
                                                    }
                                                ],
                                                '|unit'      => 'mmol/l',
                                                '|magnitude' => '52.9'
                                            }
                                        ]
                                    }
                                ],
                                'reference_range_guidance' => [ '50-70' ],
                                'comment' =>
                                  [ 'This is the potassium comment' ],
                                'result_status' => [
                                    {
                                        '|code'        => 'at0009',
                                        '|terminology' => 'local',
                                        '|value'       => 'Final'
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
                'clinical_information_provided' => [ 'Patient feeling unwell' ],
                'time'        => [ '2018-09-03T14:08:55+01:00' ],
                'test_status' => [
                    {
                        '|code'        => 'at0038',
                        '|terminology' => 'local',
                        '|value'       => 'Final'
                    }
                ],
                'responsible_laboratory' => [
                    {
                        'name_of_organisation' => [ 'UCLH Pathology' ]
                    }
                ],
                'requested_test' => [
                    {
                        '|code'        => 'SFLC',
                        '|terminology' => 'local',
                        '|value'       => 'Serum Free Light Chains'
                    }
                ],
                'test_request_details' => [
                    {
                        'placer_order_number' => [
                            {
                                '|id'       => 'TQ00112233',
                                '|assigner' => 'TQuest',
                                '|issuer'   => 'UCLH',
                                '|type'     => 'local'
                            }
                        ],
                        'requester' => [
                            {
                                'professional_identifier' => [
                                    {
                                        '|id'       => 'AB01',
                                        '|assigner' => 'Carecast',
                                        '|issuer'   => 'UCLH',
                                        '|type'     => 'local'
                                    }
                                ],
                                'ordering_provider' => [
                                    {
                                        'ordering_provider' => [
                                            {
                                                'family_name' => [ 'UCLH' ],
                                                'given_name'  => [ 'ITU1' ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        ],
                        'filler_order_number' => [
                            {
                                '|id'       => '17V333322',
                                '|assigner' => 'Winpath',
                                '|issuer'   => 'UCLH Pathology',
                                '|type'     => 'local'
                            }
                        ]
                    }
                ],
                'test_status_timestamp' => [ '2017-12-01T01:30Z' ],
                'specimen'              => [
                    {
                        'collection_method'  => [ 'Phlebotomy' ],
                        'datetime_collected' => [ '2017-12-01T01:10Z' ],
                        'processing'         => [
                            {
                                'laboratory_specimen_identifier' => [
                                    {
                                        '|id'       => '17V333322',
                                        '|assigner' => 'Winpath',
                                        '|issuer'   => 'UCLH Pathology',
                                        '|type'     => 'local'
                                    }
                                ],
                                'datetime_received' => [ '2017-12-01T01:30Z' ]
                            }
                        ],
                        'specimen_type' => [ 'Blood' ]
                    }
                ],
                'laboratory_test_panel' => [
                    {
                        'laboratory_result' => [
                            {
                                'result_value' => [
                                    {
                                        '_name' => [
                                            {
                                                '|code'        => 'KAPA',
                                                '|terminology' => 'Local',
                                                '|value' =>
                                                  'Free Kappa Light Chains'
                                            }
                                        ],
                                        'quantity_value' => [
                                            {
                                                '|unit'      => 'mg/L',
                                                '|magnitude' => '15'
                                            }
                                        ]
                                    }
                                ],
                                'result_status' => [
                                    {
                                        '|code'        => 'at0009',
                                        '|terminology' => 'local',
                                        '|value'       => 'Final'
                                    }
                                ]
                            },
                            {
                                'result_value' => [
                                    {
                                        '_name' => [
                                            {
                                                '|code'        => 'LAMB',
                                                '|terminology' => 'Local',
                                                '|value' =>
                                                  'Free Lambda Light Chains'
                                            }
                                        ],
                                        'quantity_value' => [
                                            {
                                                '|unit'      => 'mg/L',
                                                '|magnitude' => '20'
                                            }
                                        ]
                                    }
                                ],
                                'result_status' => [
                                    {
                                        '|code'        => 'at0009',
                                        '|terminology' => 'local',
                                        '|value'       => 'Final'
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
        ],
        'patient_comment' => [
            {
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'comment'  => [ 'Hello EHR' ],
                'encoding' => [
                    {
                        '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ]
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
                        '|name'         => 'UCLH',
                        '|id_namespace' => 'UCLH-NS',
                        '|id_scheme'    => 'UCLH-NS'
                    }
                ],
                'start_time' => [ '2018-09-03T14:08:55+01:00' ],
                'setting'    => [
                    {
                        '|code'        => '238',
                        '|terminology' => 'openehr',
                        '|value'       => 'other care'
                    }
                ],
                'report_id' => [ '1112233322233' ]
            }
        ],
        'category' => [
            {
                '|code'        => '433',
                '|terminology' => 'openehr',
                '|value'       => 'event'
            }
        ],
        '_uid'     => [ '65b1dd2b-2586-4628-a76a-fb8dd7285b19::default::1' ],
        'composer' => [
            {
                '|name' => 'David Ramlakhan'
            }
        ]
    }
};
