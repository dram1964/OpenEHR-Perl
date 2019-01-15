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
    'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
    'uid'               => {
        'value'  => '79fa1261-5fe2-44a2-b3fb-e594ea4c0463::default::1',
        '@class' => 'OBJECT_VERSION_ID'
    },
    'content' => [
        {
            'protocol' => {
                'archetype_node_id' => 'at0008',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0010',
                        'value'             => {
                            'value'  => '1-20190110-656620',
                            '@class' => 'DV_TEXT'
                        },
                        'name' => {
                            'value'  => 'Requestor Identifier',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT'
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
            'archetype_node_id' => 'openEHR-EHR-INSTRUCTION.request.v0',
            'uid'               => {
                'value'  => 'a98526fb-fdcb-4665-967c-103f300b6435',
                '@class' => 'HIER_OBJECT_ID'
            },
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'activities' => [
                {
                    'action_archetype_id' => '/.*/',
                    'timing'              => {
                        'value'     => '2019-01-10T13:52:35',
                        'formalism' => 'timing',
                        '@class'    => 'DV_PARSABLE'
                    },
                    'archetype_node_id' => 'at0001',
                    'name'              => {
                        'value'  => 'Request',
                        '@class' => 'DV_TEXT'
                    },
                    'description' => {
                        'archetype_node_id' => 'at0009',
                        'name'              => {
                            'value'  => 'Tree',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0121',
                                'value'             => {
                                    'value'  => 'GEL Information data request',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Service name',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0148',
                                'value'             => {
                                    'value'  => 'pathology',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Service type',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' =>
'openEHR-EHR-CLUSTER.information_request_details_gel.v0',
                                'name' => {
                                    'value' =>
                                      'GEL information request details',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
'openEHR-EHR-CLUSTER.information_request_details_gel.v0',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {
                                        'archetype_node_id' => 'at0001',
                                        'value'             => {
                                            'value' =>
                                              '1970-03-16T00:00:00+01:00',
                                            '@class' => 'DV_DATE_TIME'
                                        },
                                        'name' => {
                                            'value' =>
'Patient information request start date',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    },
                                    {
                                        'archetype_node_id' => 'at0002',
                                        'value'             => {
                                            'value'  => '2018-01-09T00:00:00Z',
                                            '@class' => 'DV_DATE_TIME'
                                        },
                                        'name' => {
                                            'value' =>
'Patient information request end date',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER'
                            }
                        ],
                        '@class' => 'ITEM_TREE'
                    },
                    '@class' => 'ACTIVITY'
                }
            ],
            'name' => {
                'value'  => 'Service request',
                '@class' => 'DV_TEXT'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-INSTRUCTION.request.v0',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            '@class'    => 'INSTRUCTION',
            'narrative' => {
                'value'  => 'GEL Information data request - pathology',
                '@class' => 'DV_TEXT'
            },
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
            'archetype_node_id' => 'openEHR-EHR-ACTION.service.v0',
            'time'              => {
                'value'  => '2019-01-10T13:52:35Z',
                '@class' => 'DV_DATE_TIME'
            },
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'name' => {
                'value'  => 'Service',
                '@class' => 'DV_TEXT'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-ACTION.service.v0',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            'description' => {
                'archetype_node_id' => 'at0001',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0011',
                        'value'             => {
                            'value'  => 'GEL Information data request',
                            '@class' => 'DV_TEXT'
                        },
                        'name' => {
                            'value'  => 'Service name',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT'
                    },
                    {
                        'archetype_node_id' => 'at0014',
                        'value'             => {
                            'value'  => 'pathology',
                            '@class' => 'DV_TEXT'
                        },
                        'name' => {
                            'value'  => 'Service type',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT'
                    }
                ],
                '@class' => 'ITEM_TREE'
            },
            '@class'         => 'ACTION',
            'ism_transition' => {
                'current_state' => {
                    'value'         => 'planned',
                    'defining_code' => {
                        'terminology_id' => {
                            'value'  => 'openehr',
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        'code_string' => '526',
                        '@class'      => 'CODE_PHRASE'
                    },
                    '@class' => 'DV_CODED_TEXT'
                },
                '@class' => 'ISM_TRANSITION'
            },
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
        'value'  => 'GEL Data request summary',
        '@class' => 'DV_TEXT'
    },
    'archetype_details' => {
        'template_id' => {
            'value'  => 'GEL - Data request Summary.v1',
            '@class' => 'TEMPLATE_ID'
        },
        'rm_version'   => '1.0.1',
        'archetype_id' => {
            'value'  => 'openEHR-EHR-COMPOSITION.report.v1',
            '@class' => 'ARCHETYPE_ID'
        },
        '@class' => 'ARCHETYPED'
    },
    '@class'  => 'COMPOSITION',
    'context' => {
        'start_time' => {
            'value'  => '2019-01-10T13:52:35Z',
            '@class' => 'DV_DATE_TIME'
        },
        'health_care_facility' => {
            'name'         => 'Great Ormond Street Hospital',
            'external_ref' => {
                'namespace' => 'NTGMC_NAMESPACE',
                'type'      => 'PARTY',
                'id'        => {
                    'value'  => 'GOSH',
                    'scheme' => 'NTGMC_SCHEME',
                    '@class' => 'GENERIC_ID'
                },
                '@class' => 'PARTY_REF'
            },
            '@class' => 'PARTY_IDENTIFIED'
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
        'name'   => 'GENIE',
        '@class' => 'PARTY_IDENTIFIED'
    }
};
