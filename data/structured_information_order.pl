$VAR1 = {
    'gel_data_request_summary' => {
        'territory' => [
            {
                '|code'        => 'GB',
                '|terminology' => 'ISO_3166-1'
            }
        ],
        'service_request' => [
            {
                'narrative' => [ 'GEL Information data request - pathology' ],
                'request'   => [
                    {
                        'gel_information_request_details' => [
                            {
                                'patient_information_request_end_date' =>
                                  [ '2018-01-09T00:00Z' ],
                                'patient_information_request_start_date' =>
                                  [ '1970-03-16T00:00+01:00' ]
                            }
                        ],
                        'service_type' => [ 'pathology' ],
                        'timing'       => [
                            {
                                '|value'     => '2019-01-10T13:52:35',
                                '|formalism' => 'timing'
                            }
                        ],
                        'service_name' => [ 'GEL Information data request' ]
                    }
                ],
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'requestor_identifier' => [ '1-20190110-656620' ],
                '_uid'     => [ 'a98526fb-fdcb-4665-967c-103f300b6435' ],
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
        'service' => [
            {
                'service_type' => [ 'pathology' ],
                'service_name' => [ 'GEL Information data request' ],
                'language'     => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'time'     => [ '2019-01-10T13:52:35Z' ],
                'encoding' => [
                    {
                        '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'ism_transition' => [
                    {
                        'current_state' => [
                            {
                                '|code'        => '526',
                                '|terminology' => 'openehr',
                                '|value'       => 'planned'
                            }
                        ]
                    }
                ]
            }
        ],
        'context' => [
            {
                '_health_care_facility' => [
                    {
                        '|id'           => 'GOSH',
                        '|name'         => 'Great Ormond Street Hospital',
                        '|id_namespace' => 'NTGMC_NAMESPACE',
                        '|id_scheme'    => 'NTGMC_SCHEME'
                    }
                ],
                'start_time' => [ '2019-01-10T13:52:35Z' ],
                'setting'    => [
                    {
                        '|code'        => '238',
                        '|terminology' => 'openehr',
                        '|value'       => 'other care'
                    }
                ]
            }
        ],
        'category' => [
            {
                '|code'        => '433',
                '|terminology' => 'openehr',
                '|value'       => 'event'
            }
        ],
        '_uid'     => [ '79fa1261-5fe2-44a2-b3fb-e594ea4c0463::default::1' ],
        'composer' => [
            {
                '|name' => 'GENIE'
            }
        ]
    }
};
