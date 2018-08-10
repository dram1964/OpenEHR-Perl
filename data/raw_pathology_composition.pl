$VAR1 = {
    'territory' => {
        'terminology_id' => {
            'value'  => 'ISO_3166-1',
            '@class' => 'TERMINOLOGY_ID'
        },
        'code_string' => 'GB',
        '@class'      => 'CODE_PHRASE'
    },
    'language' => {
        'terminology_id' => {
            'value'  => 'ISO_639-1',
            '@class' => 'TERMINOLOGY_ID'
        },
        'code_string' => 'en',
        '@class'      => 'CODE_PHRASE'
    },
    'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report-result.v1',
    'uid'               => {
        'value'  => '84c6bde4-cd43-4f36-9b24-1654faa54aa1::default::1',
        '@class' => 'OBJECT_VERSION_ID'
    },
    'content' => [
        {
            'protocol' => {
                'archetype_node_id' => 'at0004',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.organisation.v1',
                        'name' => {
                            'value'  => 'Responsible laboratory',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.organisation.v1',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'  => 'UCLH Pathology',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Name of Organisation',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' => 'at0094',
                        'name'              => {
                            'value'  => 'Test request details',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0062',
                                'value'             => {
                                    'type'     => 'local',
                                    'id'       => 'TQ00112233',
                                    'issuer'   => 'UCLH',
                                    'assigner' => 'TQuest',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Placer order number',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0063',
                                'value'             => {
                                    'type'     => 'local',
                                    'id'       => '17V333322',
                                    'issuer'   => 'UCLH Pathology',
                                    'assigner' => 'Winpath',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Filler order number',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' =>
'openEHR-EHR-CLUSTER.individual_professional.v1',
                                'name' => {
                                    'value'  => 'Requester',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
'openEHR-EHR-CLUSTER.individual_professional.v1',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {
                                        'archetype_node_id' =>
                                          'openEHR-EHR-CLUSTER.person_name.v1',
                                        'name' => {
                                            'value'  => 'Ordering provider',
                                            '@class' => 'DV_TEXT'
                                        },
                                        'archetype_details' => {
                                            'rm_version'   => '1.0.1',
                                            'archetype_id' => {
                                                'value' =>
'openEHR-EHR-CLUSTER.person_name.v1',
                                                '@class' => 'ARCHETYPE_ID'
                                            },
                                            '@class' => 'ARCHETYPED'
                                        },
                                        'items' => [
                                            {
                                                'archetype_node_id' => 'at0002',
                                                'name'              => {
                                                    'value' =>
                                                      'Ordering provider',
                                                    '@class' => 'DV_TEXT'
                                                },
                                                'items' => [
                                                    {
                                                        'archetype_node_id' =>
                                                          'at0003',
                                                        'value' => {
                                                            'value' => 'ITU1',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        'name' => {
                                                            'value' =>
                                                              'Given name',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        '@class' => 'ELEMENT'
                                                    },
                                                    {
                                                        'archetype_node_id' =>
                                                          'at0005',
                                                        'value' => {
                                                            'value' => 'UCLH',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        'name' => {
                                                            'value' =>
                                                              'Family name',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        '@class' => 'ELEMENT'
                                                    }
                                                ],
                                                '@class' => 'CLUSTER'
                                            }
                                        ],
                                        '@class' => 'CLUSTER'
                                    },
                                    {
                                        'archetype_node_id' => 'at0011',
                                        'value'             => {
                                            'type'     => 'local',
                                            'id'       => 'AB01',
                                            'issuer'   => 'UCLH',
                                            'assigner' => 'Carecast',
                                            '@class'   => 'DV_IDENTIFIER'
                                        },
                                        'name' => {
                                            'value' =>
                                              'Professional Identifier',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    }
                ],
                '@class' => 'ITEM_TREE'
            },
            'language' => {
                'terminology_id' => {
                    'value'  => 'ISO_639-1',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'en',
                '@class'      => 'CODE_PHRASE'
            },
            'archetype_node_id' => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
            'subject'           => {
                '@class' => 'PARTY_SELF'
            },
            'name' => {
                'value'  => 'Laboratory test',
                '@class' => 'DV_TEXT'
            },
            'data' => {
                'archetype_node_id' => 'at0001',
                'events'            => [
                    {
                        'archetype_node_id' => 'at0002',
                        'time'              => {
                            'value'  => '2018-08-10T13:08:47+01:00',
                            '@class' => 'DV_DATE_TIME'
                        },
                        'name' => {
                            'value'  => 'Any event',
                            '@class' => 'DV_TEXT'
                        },
                        'data' => {
                            'archetype_node_id' => 'at0003',
                            'name'              => {
                                'value'  => 'Tree',
                                '@class' => 'DV_TEXT'
                            },
                            'items' => [
                                {
                                    'archetype_node_id' => 'at0005',
                                    'value'             => {
                                        'value'         => 'Electrolytes',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'ELL',
                                            '@class'      => 'CODE_PHRASE'
                                        },
                                        '@class' => 'DV_CODED_TEXT'
                                    },
                                    'name' => {
                                        'value'  => 'Requested Test',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' =>
                                      'openEHR-EHR-CLUSTER.specimen.v0',
                                    'name' => {
                                        'value'  => 'Specimen',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'archetype_details' => {
                                        'rm_version'   => '1.0.1',
                                        'archetype_id' => {
                                            'value' =>
                                              'openEHR-EHR-CLUSTER.specimen.v0',
                                            '@class' => 'ARCHETYPE_ID'
                                        },
                                        '@class' => 'ARCHETYPED'
                                    },
                                    'items' => [
                                        {
                                            'archetype_node_id' => 'at0029',
                                            'value'             => {
                                                'value'  => 'Blood',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'name' => {
                                                'value'  => 'Specimen type',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0015',
                                            'value'             => {
                                                'value' =>
                                                  '2017-12-01T01:10:00Z',
                                                '@class' => 'DV_DATE_TIME'
                                            },
                                            'name' => {
                                                'value' => 'Datetime collected',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0007',
                                            'value'             => {
                                                'value'  => 'Phlebotomy',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'name' => {
                                                'value'  => 'Collection method',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0046',
                                            'name'              => {
                                                'value'  => 'Processing',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0034',
                                                    'value' => {
                                                        'value' =>
'2017-12-01T01:30:00Z',
                                                        '@class' =>
                                                          'DV_DATE_TIME'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Datetime received',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'type' => 'local',
                                                        'id'   => '17V333322',
                                                        'issuer' =>
                                                          'UCLH Pathology',
                                                        'assigner' => 'Winpath',
                                                        '@class' =>
                                                          'DV_IDENTIFIER'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Laboratory specimen identifier',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        }
                                    ],
                                    '@class' => 'CLUSTER'
                                },
                                {
                                    'archetype_node_id' => 'at0073',
                                    'value'             => {
                                        'value'         => 'Final',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'at0038',
                                            '@class'      => 'CODE_PHRASE'
                                        },
                                        '@class' => 'DV_CODED_TEXT'
                                    },
                                    'name' => {
                                        'value'  => 'Test status',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' => 'at0075',
                                    'value'             => {
                                        'value'  => '2017-12-01T01:30:00Z',
                                        '@class' => 'DV_DATE_TIME'
                                    },
                                    'name' => {
                                        'value'  => 'Test status timestamp',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' => 'at0100',
                                    'value'             => {
                                        'value'  => 'Patient feeling unwell',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'name' => {
                                        'value' =>
                                          'Clinical information provided',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' =>
'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                    'name' => {
                                        'value'  => 'Laboratory test panel',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'archetype_details' => {
                                        'rm_version'   => '1.0.1',
                                        'archetype_id' => {
                                            'value' =>
'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                            '@class' => 'ARCHETYPE_ID'
                                        },
                                        '@class' => 'ARCHETYPED'
                                    },
                                    'items' => [
                                        {
                                            'archetype_node_id' => 'at0002',
                                            'name'              => {
                                                'value'  => 'Laboratory result',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'magnitude' => '88.9',
                                                        'units'     => 'mmol/l',
                                                        '@class' =>
                                                          'DV_QUANTITY'
                                                    },
                                                    'name' => {
                                                        'mappings' => [
                                                            {
                                                                'target' => {
'terminology_id'
                                                                      => {
                                                                        'value'
                                                                          => 'LOINC',
                                                                        '@class'
                                                                          => 'TERMINOLOGY_ID'
                                                                      },
'code_string'
                                                                      => '5195-3',
                                                                    '@class' =>
'CODE_PHRASE'
                                                                },
                                                                'match' => '=',
                                                                '@class' =>
                                                                  'TERM_MAPPING'
                                                            }
                                                        ],
                                                        'value' => 'Sodium',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'Local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'NA',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0003',
                                                    'value' => {
                                                        'value' =>
'This is the sodium comment',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value'  => 'Comment',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0004',
                                                    'value' => {
                                                        'value'  => '80-90',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Reference range guidance',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0005',
                                                    'value' => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'at0009',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Result status',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        },
                                        {
                                            'archetype_node_id' => 'at0002',
                                            'name'              => {
                                                'value' =>
                                                  'Laboratory result #2',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'value' =>
                                                          '52.9 mmol/l',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'mappings' => [
                                                            {
                                                                'target' => {
'terminology_id'
                                                                      => {
                                                                        'value'
                                                                          => 'LOINC',
                                                                        '@class'
                                                                          => 'TERMINOLOGY_ID'
                                                                      },
'code_string'
                                                                      => '5195-3',
                                                                    '@class' =>
'CODE_PHRASE'
                                                                },
                                                                'match' => '=',
                                                                '@class' =>
                                                                  'TERM_MAPPING'
                                                            }
                                                        ],
                                                        'value' => 'Potassium',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'Local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'K',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0003',
                                                    'value' => {
                                                        'value' =>
'This is the potassium comment',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value'  => 'Comment',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0004',
                                                    'value' => {
                                                        'value'  => '50-70',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Reference range guidance',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0005',
                                                    'value' => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'at0009',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Result status',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        }
                                    ],
                                    '@class' => 'CLUSTER'
                                }
                            ],
                            '@class' => 'ITEM_TREE'
                        },
                        '@class' => 'POINT_EVENT'
                    }
                ],
                'origin' => {
                    'value'  => '2018-08-10T13:08:47+01:00',
                    '@class' => 'DV_DATE_TIME'
                },
                'name' => {
                    'value'  => 'Event Series',
                    '@class' => 'DV_TEXT'
                },
                '@class' => 'HISTORY'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            '@class'   => 'OBSERVATION',
            'encoding' => {
                'terminology_id' => {
                    'value'  => 'IANA_character-sets',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'UTF-8',
                '@class'      => 'CODE_PHRASE'
            }
        },
        {
            'protocol' => {
                'archetype_node_id' => 'at0004',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.organisation.v1',
                        'name' => {
                            'value'  => 'Responsible laboratory',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.organisation.v1',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'  => 'UCLH Pathology',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Name of Organisation',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' => 'at0094',
                        'name'              => {
                            'value'  => 'Test request details',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0062',
                                'value'             => {
                                    'type'     => 'local',
                                    'id'       => 'TQ00112233',
                                    'issuer'   => 'UCLH',
                                    'assigner' => 'TQuest',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Placer order number',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0063',
                                'value'             => {
                                    'type'     => 'local',
                                    'id'       => '17V333322',
                                    'issuer'   => 'UCLH Pathology',
                                    'assigner' => 'Winpath',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Filler order number',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' =>
'openEHR-EHR-CLUSTER.individual_professional.v1',
                                'name' => {
                                    'value'  => 'Requester',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
'openEHR-EHR-CLUSTER.individual_professional.v1',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {
                                        'archetype_node_id' =>
                                          'openEHR-EHR-CLUSTER.person_name.v1',
                                        'name' => {
                                            'value'  => 'Ordering provider',
                                            '@class' => 'DV_TEXT'
                                        },
                                        'archetype_details' => {
                                            'rm_version'   => '1.0.1',
                                            'archetype_id' => {
                                                'value' =>
'openEHR-EHR-CLUSTER.person_name.v1',
                                                '@class' => 'ARCHETYPE_ID'
                                            },
                                            '@class' => 'ARCHETYPED'
                                        },
                                        'items' => [
                                            {
                                                'archetype_node_id' => 'at0002',
                                                'name'              => {
                                                    'value' =>
                                                      'Ordering provider',
                                                    '@class' => 'DV_TEXT'
                                                },
                                                'items' => [
                                                    {
                                                        'archetype_node_id' =>
                                                          'at0003',
                                                        'value' => {
                                                            'value' => 'ITU1',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        'name' => {
                                                            'value' =>
                                                              'Given name',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        '@class' => 'ELEMENT'
                                                    },
                                                    {
                                                        'archetype_node_id' =>
                                                          'at0005',
                                                        'value' => {
                                                            'value' => 'UCLH',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        'name' => {
                                                            'value' =>
                                                              'Family name',
                                                            '@class' =>
                                                              'DV_TEXT'
                                                        },
                                                        '@class' => 'ELEMENT'
                                                    }
                                                ],
                                                '@class' => 'CLUSTER'
                                            }
                                        ],
                                        '@class' => 'CLUSTER'
                                    },
                                    {
                                        'archetype_node_id' => 'at0011',
                                        'value'             => {
                                            'type'     => 'local',
                                            'id'       => 'AB01',
                                            'issuer'   => 'UCLH',
                                            'assigner' => 'Carecast',
                                            '@class'   => 'DV_IDENTIFIER'
                                        },
                                        'name' => {
                                            'value' =>
                                              'Professional Identifier',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    }
                ],
                '@class' => 'ITEM_TREE'
            },
            'language' => {
                'terminology_id' => {
                    'value'  => 'ISO_639-1',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'en',
                '@class'      => 'CODE_PHRASE'
            },
            'archetype_node_id' => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
            'subject'           => {
                '@class' => 'PARTY_SELF'
            },
            'name' => {
                'value'  => 'Laboratory test #2',
                '@class' => 'DV_TEXT'
            },
            'data' => {
                'archetype_node_id' => 'at0001',
                'events'            => [
                    {
                        'archetype_node_id' => 'at0002',
                        'time'              => {
                            'value'  => '2018-08-10T13:08:47+01:00',
                            '@class' => 'DV_DATE_TIME'
                        },
                        'name' => {
                            'value'  => 'Any event',
                            '@class' => 'DV_TEXT'
                        },
                        'data' => {
                            'archetype_node_id' => 'at0003',
                            'name'              => {
                                'value'  => 'Tree',
                                '@class' => 'DV_TEXT'
                            },
                            'items' => [
                                {
                                    'archetype_node_id' => 'at0005',
                                    'value'             => {
                                        'value' => 'Serum Free Light Chains',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'SFLC',
                                            '@class'      => 'CODE_PHRASE'
                                        },
                                        '@class' => 'DV_CODED_TEXT'
                                    },
                                    'name' => {
                                        'value'  => 'Requested Test',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' =>
                                      'openEHR-EHR-CLUSTER.specimen.v0',
                                    'name' => {
                                        'value'  => 'Specimen',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'archetype_details' => {
                                        'rm_version'   => '1.0.1',
                                        'archetype_id' => {
                                            'value' =>
                                              'openEHR-EHR-CLUSTER.specimen.v0',
                                            '@class' => 'ARCHETYPE_ID'
                                        },
                                        '@class' => 'ARCHETYPED'
                                    },
                                    'items' => [
                                        {
                                            'archetype_node_id' => 'at0029',
                                            'value'             => {
                                                'value'  => 'Blood',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'name' => {
                                                'value'  => 'Specimen type',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0015',
                                            'value'             => {
                                                'value' =>
                                                  '2017-12-01T01:10:00Z',
                                                '@class' => 'DV_DATE_TIME'
                                            },
                                            'name' => {
                                                'value' => 'Datetime collected',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0007',
                                            'value'             => {
                                                'value'  => 'Phlebotomy',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'name' => {
                                                'value'  => 'Collection method',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                        {
                                            'archetype_node_id' => 'at0046',
                                            'name'              => {
                                                'value'  => 'Processing',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0034',
                                                    'value' => {
                                                        'value' =>
'2017-12-01T01:30:00Z',
                                                        '@class' =>
                                                          'DV_DATE_TIME'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Datetime received',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'type' => 'local',
                                                        'id'   => '17V333322',
                                                        'issuer' =>
                                                          'UCLH Pathology',
                                                        'assigner' => 'Winpath',
                                                        '@class' =>
                                                          'DV_IDENTIFIER'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Laboratory specimen identifier',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        }
                                    ],
                                    '@class' => 'CLUSTER'
                                },
                                {
                                    'archetype_node_id' => 'at0073',
                                    'value'             => {
                                        'value'         => 'Final',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'at0038',
                                            '@class'      => 'CODE_PHRASE'
                                        },
                                        '@class' => 'DV_CODED_TEXT'
                                    },
                                    'name' => {
                                        'value'  => 'Test status',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' => 'at0075',
                                    'value'             => {
                                        'value'  => '2017-12-01T01:30:00Z',
                                        '@class' => 'DV_DATE_TIME'
                                    },
                                    'name' => {
                                        'value'  => 'Test status timestamp',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' => 'at0100',
                                    'value'             => {
                                        'value'  => 'Patient feeling unwell',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'name' => {
                                        'value' =>
                                          'Clinical information provided',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {
                                    'archetype_node_id' =>
'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                    'name' => {
                                        'value'  => 'Laboratory test panel',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'archetype_details' => {
                                        'rm_version'   => '1.0.1',
                                        'archetype_id' => {
                                            'value' =>
'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                            '@class' => 'ARCHETYPE_ID'
                                        },
                                        '@class' => 'ARCHETYPED'
                                    },
                                    'items' => [
                                        {
                                            'archetype_node_id' => 'at0002',
                                            'name'              => {
                                                'value'  => 'Laboratory result',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'value'  => '15.0 mg/L',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Free Kappa Light Chains',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'Local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'KAPA',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0005',
                                                    'value' => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'at0009',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Result status',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        },
                                        {
                                            'archetype_node_id' => 'at0002',
                                            'name'              => {
                                                'value' =>
                                                  'Laboratory result #2',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {
                                                    'archetype_node_id' =>
                                                      'at0001',
                                                    'value' => {
                                                        'value'  => '20 mg/L',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
'Free Lambda Light Chains',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'Local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'LAMB',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {
                                                    'archetype_node_id' =>
                                                      'at0005',
                                                    'value' => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            'terminology_id' =>
                                                              {
                                                                'value' =>
                                                                  'local',
                                                                '@class' =>
'TERMINOLOGY_ID'
                                                              },
                                                            'code_string' =>
                                                              'at0009',
                                                            '@class' =>
                                                              'CODE_PHRASE'
                                                        },
                                                        '@class' =>
                                                          'DV_CODED_TEXT'
                                                    },
                                                    'name' => {
                                                        'value' =>
                                                          'Result status',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                }
                                            ],
                                            '@class' => 'CLUSTER'
                                        }
                                    ],
                                    '@class' => 'CLUSTER'
                                }
                            ],
                            '@class' => 'ITEM_TREE'
                        },
                        '@class' => 'POINT_EVENT'
                    }
                ],
                'origin' => {
                    'value'  => '2018-08-10T13:08:47+01:00',
                    '@class' => 'DV_DATE_TIME'
                },
                'name' => {
                    'value'  => 'Event Series',
                    '@class' => 'DV_TEXT'
                },
                '@class' => 'HISTORY'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            '@class'   => 'OBSERVATION',
            'encoding' => {
                'terminology_id' => {
                    'value'  => 'IANA_character-sets',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'UTF-8',
                '@class'      => 'CODE_PHRASE'
            }
        },
        {
            'language' => {
                'terminology_id' => {
                    'value'  => 'ISO_639-1',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'en',
                '@class'      => 'CODE_PHRASE'
            },
            'archetype_node_id' =>
              'openEHR-EHR-EVALUATION.clinical_synopsis.v1',
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'name' => {
                'value'  => 'Patient comment',
                '@class' => 'DV_TEXT'
            },
            'data' => {
                'archetype_node_id' => 'at0001',
                'name'              => {
                    'value'  => 'List',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0002',
                        'value'             => {
                            'value'  => 'Hello EHR',
                            '@class' => 'DV_TEXT'
                        },
                        'name' => {
                            'value'  => 'Comment',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT'
                    }
                ],
                '@class' => 'ITEM_TREE'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            '@class'   => 'EVALUATION',
            'encoding' => {
                'terminology_id' => {
                    'value'  => 'IANA_character-sets',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'UTF-8',
                '@class'      => 'CODE_PHRASE'
            }
        }
    ],
    'name' => {
        'value'  => 'Laboratory Result Report',
        '@class' => 'DV_TEXT'
    },
    'archetype_details' => {
        'template_id' => {
            'value'  => 'GEL - Generic Lab Report import.v0',
            '@class' => 'TEMPLATE_ID'
        },
        'rm_version'   => '1.0.1',
        'archetype_id' => {
            'value'  => 'openEHR-EHR-COMPOSITION.report-result.v1',
            '@class' => 'ARCHETYPE_ID'
        },
        '@class' => 'ARCHETYPED'
    },
    '@class'  => 'COMPOSITION',
    'context' => {
        'start_time' => {
            'value'  => '2018-08-10T13:08:47+01:00',
            '@class' => 'DV_DATE_TIME'
        },
        'health_care_facility' => {
            'name'         => 'UCLH',
            'external_ref' => {
                'namespace' => 'UCLH-NS',
                'type'      => 'PARTY',
                'id'        => {
                    'value'  => 'RRV',
                    'scheme' => 'UCLH-NS',
                    '@class' => 'GENERIC_ID'
                },
                '@class' => 'PARTY_REF'
            },
            '@class' => 'PARTY_IDENTIFIED'
        },
        'other_context' => {
            'archetype_node_id' => 'at0001',
            'name'              => {
                'value'  => 'Tree',
                '@class' => 'DV_TEXT'
            },
            'items' => [
                {
                    'archetype_node_id' => 'at0002',
                    'value'             => {
                        'value'  => '1112233322233',
                        '@class' => 'DV_TEXT'
                    },
                    'name' => {
                        'value'  => 'Report ID',
                        '@class' => 'DV_TEXT'
                    },
                    '@class' => 'ELEMENT'
                }
            ],
            '@class' => 'ITEM_TREE'
        },
        'setting' => {
            'value'         => 'other care',
            'defining_code' => {
                'terminology_id' => {
                    'value'  => 'openehr',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => '238',
                '@class'      => 'CODE_PHRASE'
            },
            '@class' => 'DV_CODED_TEXT'
        },
        '@class' => 'EVENT_CONTEXT'
    },
    'category' => {
        'value'         => 'event',
        'defining_code' => {
            'terminology_id' => {
                'value'  => 'openehr',
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => '433',
            '@class'      => 'CODE_PHRASE'
        },
        '@class' => 'DV_CODED_TEXT'
    },
    'composer' => {
        'name'   => 'David Ramlakhan',
        '@class' => 'PARTY_IDENTIFIED'
    }
};
