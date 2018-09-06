$VAR1 = {
    'category' => {
        '@class'        => 'DV_CODED_TEXT',
        'value'         => 'event',
        'defining_code' => {
            '@class'         => 'CODE_PHRASE',
            'terminology_id' => {
                'value'  => 'openehr',
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => '433'
        }
    },
    'composer' => {
        '@class' => 'PARTY_IDENTIFIED',
        'name'   => 'OpenEHR-Perl-FLAT'
    },
    '@class'            => 'COMPOSITION',
    'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report-result.v1',
    'name'              => {
        '@class' => 'DV_TEXT',
        'value'  => 'Laboratory Result Report'
    },
    'uid' => {
        '@class' => 'OBJECT_VERSION_ID',
        'value'  => '107c6d6d-cc84-45c5-8e4c-c4a3aaa7bbd8::default::1'
    },
    'territory' => {
        '@class'         => 'CODE_PHRASE',
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_3166-1'
        },
        'code_string' => 'GB'
    },
    'archetype_details' => {
        'archetype_id' => {
            'value'  => 'openEHR-EHR-COMPOSITION.report-result.v1',
            '@class' => 'ARCHETYPE_ID'
        },
        '@class'      => 'ARCHETYPED',
        'rm_version'  => '1.0.1',
        'template_id' => {
            'value'  => 'GEL - Generic Lab Report import.v0',
            '@class' => 'TEMPLATE_ID'
        }
    },
    'language' => {
        'code_string'    => 'en',
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_639-1'
        },
        '@class' => 'CODE_PHRASE'
    },
    'content' => [
        {   'subject' => { '@class' => 'PARTY_SELF' },
            'name'    => {
                '@class' => 'DV_TEXT',
                'value'  => 'Laboratory test'
            },
            'archetype_node_id' =>
                'openEHR-EHR-OBSERVATION.laboratory_test.v0',
            '@class'   => 'OBSERVATION',
            'protocol' => {
                'items' => [
                    {   'archetype_details' => {
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.organisation.v1'
                            },
                            '@class'     => 'ARCHETYPED',
                            'rm_version' => '1.0.1'
                        },
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.organisation.v1',
                        'items' => [
                            {   'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Clinical Biochemistry'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Name of Organisation',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Responsible laboratory'
                        },
                        '@class' => 'CLUSTER'
                    },
                    {   'items' => [
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0062',
                                'name'              => {
                                    'value'  => 'Placer order number',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    'type'     => 'local',
                                    'id'       => 'TQ001113333',
                                    '@class'   => 'DV_IDENTIFIER',
                                    'assigner' => 'TQuest',
                                    'issuer'   => 'UCLH'
                                }
                            },
                            {   'value' => {
                                    'type'     => 'local',
                                    'id'       => '17V333999',
                                    'assigner' => 'Winpath',
                                    'issuer'   => 'UCLH Pathology',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Filler order number',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0063',
                                '@class'            => 'ELEMENT'
                            },
                            {   'archetype_details' => {
                                    '@class'       => 'ARCHETYPED',
                                    'archetype_id' => {
                                        'value' =>
                                            'openEHR-EHR-CLUSTER.individual_professional.v1',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    'rm_version' => '1.0.1'
                                },
                                '@class' => 'CLUSTER',
                                'items'  => [
                                    {   'items' => [
                                            {   'name' => {
                                                    'value' =>
                                                        'Ordering provider',
                                                    '@class' => 'DV_TEXT'
                                                },
                                                'items' => [
                                                    {   '@class' => 'ELEMENT',
                                                        'name'   => {
                                                            '@class' =>
                                                                'DV_TEXT',
                                                            'value' =>
                                                                'Given name'
                                                        },
                                                        'archetype_node_id'
                                                            => 'at0003',
                                                        'value' => {
                                                            'value' => 'A&E',
                                                            '@class' =>
                                                                'DV_TEXT'
                                                        }
                                                    },
                                                    {   'value' => {
                                                            'value' => 'UCLH',
                                                            '@class' =>
                                                                'DV_TEXT'
                                                        },
                                                        '@class' => 'ELEMENT',
                                                        'archetype_node_id'
                                                            => 'at0005',
                                                        'name' => {
                                                            'value' =>
                                                                'Family name',
                                                            '@class' =>
                                                                'DV_TEXT'
                                                        }
                                                    }
                                                ],
                                                'archetype_node_id' =>
                                                    'at0002',
                                                '@class' => 'CLUSTER'
                                            }
                                        ],
                                        'archetype_node_id' =>
                                            'openEHR-EHR-CLUSTER.person_name.v1',
                                        'name' => {
                                            'value'  => 'Ordering provider',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class'            => 'CLUSTER',
                                        'archetype_details' => {
                                            'rm_version'   => '1.0.1',
                                            'archetype_id' => {
                                                '@class' => 'ARCHETYPE_ID',
                                                'value' =>
                                                    'openEHR-EHR-CLUSTER.person_name.v1'
                                            },
                                            '@class' => 'ARCHETYPED'
                                        }
                                    },
                                    {   'value' => {
                                            '@class'   => 'DV_IDENTIFIER',
                                            'assigner' => 'Carecast',
                                            'issuer'   => 'UCLH',
                                            'type'     => 'local',
                                            'id'       => 'AB01'
                                        },
                                        '@class'            => 'ELEMENT',
                                        'archetype_node_id' => 'at0011',
                                        'name'              => {
                                            'value' =>
                                                'Professional Identifier',
                                            '@class' => 'DV_TEXT'
                                        }
                                    }
                                ],
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Requester'
                                },
                                'archetype_node_id' =>
                                    'openEHR-EHR-CLUSTER.individual_professional.v1'
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Test request details'
                        },
                        'archetype_node_id' => 'at0094',
                        '@class'            => 'CLUSTER'
                    }
                ],
                'name' => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'archetype_node_id' => 'at0004',
                '@class'            => 'ITEM_TREE'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            'language' => {
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    'value'  => 'ISO_639-1',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'en'
            },
            'encoding' => {
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'IANA_character-sets'
                },
                'code_string' => 'UTF-8'
            },
            'data' => {
                '@class' => 'HISTORY',
                'events' => [
                    {   'archetype_node_id' => 'at0002',
                        'name'              => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Any event'
                        },
                        '@class' => 'POINT_EVENT',
                        'time'   => {
                            'value'  => '2018-09-06T16:55:24.208+01:00',
                            '@class' => 'DV_DATE_TIME'
                        },
                        'data' => {
                            'name' => {
                                'value'  => 'Tree',
                                '@class' => 'DV_TEXT'
                            },
                            'items' => [
                                {   'value' => {
                                        '@class'        => 'DV_CODED_TEXT',
                                        'value'         => 'Electrolytes',
                                        'defining_code' => {
                                            '@class'         => 'CODE_PHRASE',
                                            'code_string'    => 'ELL',
                                            'terminology_id' => {
                                                '@class' => 'TERMINOLOGY_ID',
                                                'value'  => 'local'
                                            }
                                        }
                                    },
                                    '@class'            => 'ELEMENT',
                                    'archetype_node_id' => 'at0005',
                                    'name'              => {
                                        'value'  => 'Requested Test',
                                        '@class' => 'DV_TEXT'
                                    }
                                },
                                {   'archetype_details' => {
                                        'archetype_id' => {
                                            '@class' => 'ARCHETYPE_ID',
                                            'value' =>
                                                'openEHR-EHR-CLUSTER.specimen.v0'
                                        },
                                        '@class'     => 'ARCHETYPED',
                                        'rm_version' => '1.0.1'
                                    },
                                    'items' => [
                                        {   'value' => {
                                                'value'  => 'Blood',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT',
                                            'name'   => {
                                                'value'  => 'Specimen type',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'archetype_node_id' => 'at0029'
                                        },
                                        {   'archetype_node_id' => 'at0015',
                                            'name'              => {
                                                '@class' => 'DV_TEXT',
                                                'value' =>
                                                    'Datetime collected'
                                            },
                                            '@class' => 'ELEMENT',
                                            'value'  => {
                                                '@class' => 'DV_DATE_TIME',
                                                'value' =>
                                                    '2017-11-20T14:31:00Z'
                                            }
                                        },
                                        {   '@class'            => 'ELEMENT',
                                            'archetype_node_id' => 'at0007',
                                            'name'              => {
                                                '@class' => 'DV_TEXT',
                                                'value' => 'Collection method'
                                            },
                                            'value' => {
                                                'value'  => 'Phlebotomy',
                                                '@class' => 'DV_TEXT'
                                            }
                                        },
                                        {   '@class' => 'CLUSTER',
                                            'items'  => [
                                                {   'archetype_node_id' =>
                                                        'at0034',
                                                    'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value' =>
                                                            'Datetime received'
                                                    },
                                                    '@class' => 'ELEMENT',
                                                    'value'  => {
                                                        '@class' =>
                                                            'DV_DATE_TIME',
                                                        'value' =>
                                                            '2017-11-20T15:21:00Z'
                                                    }
                                                },
                                                {   '@class' => 'ELEMENT',
                                                    'name'   => {
                                                        '@class' => 'DV_TEXT',
                                                        'value' =>
                                                            'Laboratory specimen identifier'
                                                    },
                                                    'archetype_node_id' =>
                                                        'at0001',
                                                    'value' => {
                                                        'type' => 'local',
                                                        'id'   => 'bld',
                                                        'issuer' =>
                                                            'UCLH Pathology',
                                                        'assigner' =>
                                                            'Winpath',
                                                        '@class' =>
                                                            'DV_IDENTIFIER'
                                                    }
                                                }
                                            ],
                                            'archetype_node_id' => 'at0046',
                                            'name'              => {
                                                '@class' => 'DV_TEXT',
                                                'value'  => 'Processing'
                                            }
                                        }
                                    ],
                                    'name' => {
                                        '@class' => 'DV_TEXT',
                                        'value'  => 'Specimen'
                                    },
                                    'archetype_node_id' =>
                                        'openEHR-EHR-CLUSTER.specimen.v0',
                                    '@class' => 'CLUSTER'
                                },
                                {   'value' => {
                                        '@class'        => 'DV_CODED_TEXT',
                                        'value'         => 'Final',
                                        'defining_code' => {
                                            '@class'         => 'CODE_PHRASE',
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'at0038'
                                        }
                                    },
                                    '@class' => 'ELEMENT',
                                    'name'   => {
                                        '@class' => 'DV_TEXT',
                                        'value'  => 'Test status'
                                    },
                                    'archetype_node_id' => 'at0073'
                                },
                                {   'value' => {
                                        '@class' => 'DV_DATE_TIME',
                                        'value'  => '2017-11-10T14:12:00Z'
                                    },
                                    '@class'            => 'ELEMENT',
                                    'archetype_node_id' => 'at0075',
                                    'name'              => {
                                        'value'  => 'Test status timestamp',
                                        '@class' => 'DV_TEXT'
                                    }
                                },
                                {   'value' => {
                                        'value'  => 'Feeling unwell',
                                        '@class' => 'DV_TEXT'
                                    },
                                    'archetype_node_id' => 'at0100',
                                    'name'              => {
                                        'value' =>
                                            'Clinical information provided',
                                        '@class' => 'DV_TEXT'
                                    },
                                    '@class' => 'ELEMENT'
                                },
                                {   'archetype_details' => {
                                        'archetype_id' => {
                                            '@class' => 'ARCHETYPE_ID',
                                            'value' =>
                                                'openEHR-EHR-CLUSTER.laboratory_test_panel.v0'
                                        },
                                        '@class'     => 'ARCHETYPED',
                                        'rm_version' => '1.0.1'
                                    },
                                    '@class' => 'CLUSTER',
                                    'archetype_node_id' =>
                                        'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                    'items' => [
                                        {   '@class' => 'CLUSTER',
                                            'name'   => {
                                                'value' =>
                                                    'Laboratory result',
                                                '@class' => 'DV_TEXT'
                                            },
                                            'items' => [
                                                {   'value' => {
                                                        'normal_range' => {
                                                            'upper' => {
                                                                'magnitude'
                                                                    => '60',
                                                                'units' =>
                                                                    'mmol/l',
                                                                '@class' =>
                                                                    'DV_QUANTITY'
                                                            },
                                                            'lower' => {
                                                                'units' =>
                                                                    'mmol/l',
                                                                'magnitude'
                                                                    => '50',
                                                                '@class' =>
                                                                    'DV_QUANTITY'
                                                            },
                                                            '@class' =>
                                                                'DV_INTERVAL',
                                                            'lower_unbounded'
                                                                => bless(
                                                                do {
                                                                    \(  my $o
                                                                            = 0
                                                                    );
                                                                },
                                                                'JSON::PP::Boolean'
                                                                ),
                                                            'upper_unbounded'
                                                                => $VAR1->{
                                                                'content'}[0]
                                                                {'data'}
                                                                {'events'}[0]
                                                                {'data'}
                                                                {'items'}[5]
                                                                {'items'}[0]
                                                                {'items'}[0]
                                                                {'value'}{
                                                                'normal_range'
                                                                }{
                                                                'lower_unbounded'
                                                                }
                                                        },
                                                        'magnitude' => '59',
                                                        'units' => 'mmol/l',
                                                        'magnitude_status' =>
                                                            '<',
                                                        '@class' =>
                                                            'DV_QUANTITY'
                                                    },
                                                    'archetype_node_id' =>
                                                        'at0001',
                                                    'name' => {
                                                        'value' => 'Sodium',
                                                        'defining_code' => {
                                                            '@class' =>
                                                                'CODE_PHRASE',
                                                            'terminology_id'
                                                                => {
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID',
                                                                'value' =>
                                                                    'Local'
                                                                },
                                                            'code_string' =>
                                                                'NA'
                                                        },
                                                        '@class' =>
                                                            'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {   'value' => {
                                                        'value' =>
                                                            'this is the sodium result',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT',
                                                    'archetype_node_id' =>
                                                        'at0003',
                                                    'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value'  => 'Comment'
                                                    }
                                                },
                                                {   'value' => {
                                                        'value'  => '50 - 60',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'archetype_node_id' =>
                                                        'at0004',
                                                    'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value' =>
                                                            'Reference range guidance'
                                                    },
                                                    '@class' => 'ELEMENT'
                                                },
                                                {   'value' => {
                                                        '@class' =>
                                                            'DV_CODED_TEXT',
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            '@class' =>
                                                                'CODE_PHRASE',
                                                            'code_string' =>
                                                                'at0009',
                                                            'terminology_id'
                                                                => {
                                                                'value' =>
                                                                    'local',
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID'
                                                                }
                                                        }
                                                    },
                                                    '@class' => 'ELEMENT',
                                                    'archetype_node_id' =>
                                                        'at0005',
                                                    'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value' =>
                                                            'Result status'
                                                    }
                                                }
                                            ],
                                            'archetype_node_id' => 'at0002'
                                        },
                                        {   '@class' => 'CLUSTER',
                                            'items'  => [
                                                {   '@class' => 'ELEMENT',
                                                    'archetype_node_id' =>
                                                        'at0001',
                                                    'name' => {
                                                        'defining_code' => {
                                                            '@class' =>
                                                                'CODE_PHRASE',
                                                            'code_string' =>
                                                                'K',
                                                            'terminology_id'
                                                                => {
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID',
                                                                'value' =>
                                                                    'Local'
                                                                }
                                                        },
                                                        'value' =>
                                                            'Potassium',
                                                        '@class' =>
                                                            'DV_CODED_TEXT'
                                                    },
                                                    'value' => {
                                                        '@class' =>
                                                            'DV_QUANTITY',
                                                        'normal_range' => {
                                                            'upper_unbounded'
                                                                => $VAR1->{
                                                                'content'}[0]
                                                                {'data'}
                                                                {'events'}[0]
                                                                {'data'}
                                                                {'items'}[5]
                                                                {'items'}[0]
                                                                {'items'}[0]
                                                                {'value'}{
                                                                'normal_range'
                                                                }{
                                                                'lower_unbounded'
                                                                },
                                                            'lower_unbounded'
                                                                => $VAR1->{
                                                                'content'}[0]
                                                                {'data'}
                                                                {'events'}[0]
                                                                {'data'}
                                                                {'items'}[5]
                                                                {'items'}[0]
                                                                {'items'}[0]
                                                                {'value'}{
                                                                'normal_range'
                                                                }{
                                                                'lower_unbounded'
                                                                },
                                                            '@class' =>
                                                                'DV_INTERVAL',
                                                            'lower' => {
                                                                '@class' =>
                                                                    'DV_QUANTITY',
                                                                'magnitude'
                                                                    => '80',
                                                                'units' =>
                                                                    'g/dl'
                                                            },
                                                            'upper' => {
                                                                '@class' =>
                                                                    'DV_QUANTITY',
                                                                'magnitude'
                                                                    => '90',
                                                                'units' =>
                                                                    'g/dl'
                                                            }
                                                        },
                                                        'units'     => 'g/dl',
                                                        'magnitude' => '88'
                                                    }
                                                },
                                                {   '@class' => 'ELEMENT',
                                                    'archetype_node_id' =>
                                                        'at0003',
                                                    'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value'  => 'Comment'
                                                    },
                                                    'value' => {
                                                        'value' =>
                                                            'this is the potassium result',
                                                        '@class' => 'DV_TEXT'
                                                    }
                                                },
                                                {   '@class' => 'ELEMENT',
                                                    'archetype_node_id' =>
                                                        'at0004',
                                                    'name' => {
                                                        'value' =>
                                                            'Reference range guidance',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    'value' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value'  => '80 - 90'
                                                    }
                                                },
                                                {   'archetype_node_id' =>
                                                        'at0005',
                                                    'name' => {
                                                        'value' =>
                                                            'Result status',
                                                        '@class' => 'DV_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT',
                                                    'value'  => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            '@class' =>
                                                                'CODE_PHRASE',
                                                            'code_string' =>
                                                                'at0009',
                                                            'terminology_id'
                                                                => {
                                                                'value' =>
                                                                    'local',
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID'
                                                                }
                                                        },
                                                        '@class' =>
                                                            'DV_CODED_TEXT'
                                                    }
                                                }
                                            ],
                                            'archetype_node_id' => 'at0002',
                                            'name'              => {
                                                '@class' => 'DV_TEXT',
                                                'value' =>
                                                    'Laboratory result #2'
                                            }
                                        },
                                        {   '@class'            => 'CLUSTER',
                                            'archetype_node_id' => 'at0002',
                                            'items'             => [
                                                {   'archetype_node_id' =>
                                                        'at0001',
                                                    'name' => {
                                                        'defining_code' => {
                                                            'code_string' =>
                                                                'F',
                                                            'terminology_id'
                                                                => {
                                                                'value' =>
                                                                    'Local',
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID'
                                                                },
                                                            '@class' =>
                                                                'CODE_PHRASE'
                                                        },
                                                        'value' =>
                                                            'Flourosine',
                                                        '@class' =>
                                                            'DV_CODED_TEXT'
                                                    },
                                                    '@class' => 'ELEMENT',
                                                    'value'  => {
                                                        '@class' => 'DV_TEXT',
                                                        'value'  => '88%
this is the flourosine result'
                                                    }
                                                },
                                                {   'name' => {
                                                        '@class' => 'DV_TEXT',
                                                        'value' =>
                                                            'Result status'
                                                    },
                                                    'archetype_node_id' =>
                                                        'at0005',
                                                    '@class' => 'ELEMENT',
                                                    'value'  => {
                                                        'value' => 'Final',
                                                        'defining_code' => {
                                                            '@class' =>
                                                                'CODE_PHRASE',
                                                            'code_string' =>
                                                                'at0009',
                                                            'terminology_id'
                                                                => {
                                                                '@class' =>
                                                                    'TERMINOLOGY_ID',
                                                                'value' =>
                                                                    'local'
                                                                }
                                                        },
                                                        '@class' =>
                                                            'DV_CODED_TEXT'
                                                    }
                                                }
                                            ],
                                            'name' => {
                                                'value' =>
                                                    'Laboratory result #3',
                                                '@class' => 'DV_TEXT'
                                            }
                                        }
                                    ],
                                    'name' => {
                                        'value'  => 'Laboratory test panel',
                                        '@class' => 'DV_TEXT'
                                    }
                                }
                            ],
                            'archetype_node_id' => 'at0003',
                            '@class'            => 'ITEM_TREE'
                        }
                    }
                ],
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Event Series'
                },
                'archetype_node_id' => 'at0001',
                'origin'            => {
                    '@class' => 'DV_DATE_TIME',
                    'value'  => '2018-09-06T15:55:24+01:00'
                }
            }
        },
        {   'encoding' => {
                '@class'         => 'CODE_PHRASE',
                'code_string'    => 'UTF-8',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'IANA_character-sets'
                }
            },
            'data' => {
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'List'
                },
                'items' => [
                    {   'value' => {
                            'value'  => 'Patient feeling poorly',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Comment'
                        },
                        'archetype_node_id' => 'at0002'
                    }
                ],
                'archetype_node_id' => 'at0001',
                '@class'            => 'ITEM_TREE'
            },
            'language' => {
                'code_string'    => 'en',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'ISO_639-1'
                },
                '@class' => 'CODE_PHRASE'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            '@class' => 'EVALUATION',
            'name'   => {
                '@class' => 'DV_TEXT',
                'value'  => 'Patient comment'
            },
            'archetype_node_id' =>
                'openEHR-EHR-EVALUATION.clinical_synopsis.v1',
            'subject' => { '@class' => 'PARTY_SELF' }
        }
    ],
    'context' => {
        'other_context' => {
            '@class' => 'ITEM_TREE',
            'items'  => [
                {   'value' => {
                        '@class' => 'DV_TEXT',
                        'value'  => '17V999333'
                    },
                    'name' => {
                        'value'  => 'Report ID',
                        '@class' => 'DV_TEXT'
                    },
                    'archetype_node_id' => 'at0002',
                    '@class'            => 'ELEMENT'
                }
            ],
            'archetype_node_id' => 'at0001',
            'name'              => {
                'value'  => 'Tree',
                '@class' => 'DV_TEXT'
            }
        },
        'setting' => {
            'defining_code' => {
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'openehr'
                },
                'code_string' => '238'
            },
            'value'  => 'other care',
            '@class' => 'DV_CODED_TEXT'
        },
        'start_time' => {
            '@class' => 'DV_DATE_TIME',
            'value'  => '2018-09-06T16:55:24.208+01:00'
        },
        'health_care_facility' => {
            'name'         => 'UCLH NHS Foundation Trust',
            '@class'       => 'PARTY_IDENTIFIED',
            'external_ref' => {
                'namespace' => 'UCLH-NS',
                'type'      => 'PARTY',
                'id'        => {
                    'scheme' => 'UCLH-NS',
                    '@class' => 'GENERIC_ID',
                    'value'  => 'RRV'
                },
                '@class' => 'PARTY_REF'
            }
        },
        '@class' => 'EVENT_CONTEXT'
    }
};
