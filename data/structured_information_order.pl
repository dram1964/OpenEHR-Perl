#c5c35e2e-79ad-43e5-a9a4-dfba3429dcb8::default::1
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
                'narrative' => [ 'GEL Information data request - cancer' ],
                'request'   => [
                    {
                        'gel_information_request_details' => [
                            {
                                'patient_information_request_end_date' =>
                                  [ '2019-05-15T00:00+01:00' ],
                                'patient_information_request_start_date' =>
                                  [ '1941-11-13T00:00+01:00' ]
                            }
                        ],
                        'service_type' => [ 'cancer' ],
                        'timing'       => [
                            {
                                '|value'     => '2019-05-15T11:06:41.9313603Z',
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
                'requestor_identifier' => [ 'CoreDataOrderID: 120026' ],
                '_uid'     => [ '62af03f1-9998-4cd5-96c0-65cd015a026f' ],
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
                'service_type' => [ 'cancer' ],
                'service_name' => [ 'GEL Information data request' ],
                'language'     => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'time'     => [ '2019-05-15T11:06:41.931360300Z' ],
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
                        '|id'           => 'TBH',
                        '|name'         => 'The Best Hospital',
                        '|id_namespace' => 'NTGMC_NAMESPACE',
                        '|id_scheme'    => 'NTGMC_SCHEME'
                    }
                ],
                'start_time' => [ '2019-05-15T11:06:41.931360300Z' ],
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
        '_uid'     => [ 'c5c35e2e-79ad-43e5-a9a4-dfba3429dcb8::default::1' ],
        'composer' => [
            {
                '|name' => 'GENIE'
            }
        ]
    }
};
