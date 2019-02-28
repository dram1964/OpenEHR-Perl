$VAR1 = {
    'language' => {
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_639-1'
        },
        '@class'      => 'CODE_PHRASE',
        'code_string' => 'en'
    },
    'category' => {
        '@class'        => 'DV_CODED_TEXT',
        'defining_code' => {
            '@class'         => 'CODE_PHRASE',
            'terminology_id' => {
                'value'  => 'openehr',
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => '433'
        },
        'value' => 'event'
    },
    'territory' => {
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_3166-1'
        },
        '@class'      => 'CODE_PHRASE',
        'code_string' => 'GB'
    },
    'content' => [
        {
            '@class' => 'EVALUATION',
            'name'   => {
                '@class' => 'DV_TEXT',
                'value'  => 'Problem/Diagnosis'
            },
            'encoding' => {
                'code_string'    => 'UTF-8',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'IANA_character-sets'
                },
                '@class' => 'CODE_PHRASE'
            },
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'data' => {
                'items' => [
                    {
                        '@class' => 'ELEMENT',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Diagnosis'
                        },
                        'archetype_node_id' => 'at0002',
                        'value'             => {
                            'defining_code' => {
                                'code_string'    => 'C71.6',
                                'terminology_id' => {
                                    '@class' => 'TERMINOLOGY_ID',
                                    'value'  => 'ICD-10'
                                },
                                '@class' => 'CODE_PHRASE'
                            },
                            'value' =>
                              'Malignant neoplasm of cerebrum, cerebellum',
                            '@class' => 'DV_CODED_TEXT'
                        }
                    },
                    {
                        'items' => [
                            {
                                'name' => {
                                    'value'  => 'Tumour identifier',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'type'     => 'local',
                                    'assigner' => 'cancer care',
                                    'id'       => 'aassdddffee',
                                    '@class'   => 'DV_IDENTIFIER',
                                    'issuer'   => 'uclh'
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'name' => {
                            'value'  => 'Tumour ID',
                            '@class' => 'DV_TEXT'
                        },
                        '@class'            => 'CLUSTER',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            }
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tumour_id_gel.v0'
                    },
                    {
                        'items' => [
                            {
                                'name' => {
                                    'value'  => 'Base of diagnosis',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value' =>
'2 Clinical investigation including all diagnostic techniques'
                                }
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Clinical evidence'
                        },
                        '@class'            => 'CLUSTER',
                        'archetype_details' => {
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                            },
                            'rm_version' => '1.0.1',
                            '@class'     => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                    },
                    {
                        'name' => {
                            'value'  => 'Cancer diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'archetype_node_id' => 'at0013',
                                'value'             => {
                                    'defining_code' => {
                                        'code_string'    => 'at0016',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value'  => 'No, not recurrence',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Recurrence indicator',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'ICD-O-3'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => '8071/3'
                                    },
                                    'value' => '8071/3'
                                },
                                'archetype_node_id' => 'at0001',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Morphology'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'C06.9',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'ICD-O-3',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value' => 'C06.9'
                                },
                                'archetype_node_id' => 'at0002',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    'value'  => 'Topography',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Metastatic site'
                                },
                                'archetype_node_id' => 'at0017',
                                'value'             => {
                                    'defining_code' => {
                                        'code_string'    => 'at0023',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    'value' =>
'Metastatic disease is located in the skin',
                                    '@class' => 'DV_CODED_TEXT'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0028',
                                'value'             => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => '9',
                                    'defining_code' => {
                                        'code_string'    => 'at0033',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    }
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Tumour laterality'
                                }
                            }
                        ],
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0'
                    },
                    {
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Integrated TNM'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated T'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'value'  => 'Integrated T 90',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            },
                            {
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated N 15'
                                },
                                'archetype_node_id' => 'at0002',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated N'
                                }
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Integrated M',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated M 25'
                                }
                            },
                            {
                                'value' => {
                                    'value' =>
                                      'G4 Undifferentiated / anaplastic',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0005',
                                'name'              => {
                                    'value'  => 'Grading at diagnosis',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'value' => {
                                    'value'  => 'Integrated Stage grouping 31',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0007',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated Stage grouping'
                                }
                            },
                            {
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated TNM Edition 44'
                                },
                                'archetype_node_id' => 'at0017',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated TNM Edition'
                                }
                            }
                        ],
                        'archetype_details' => {
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1',
                            '@class'     => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                    },
                    {
                        'name' => {
                            'value'  => 'INRG staging',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'INRG stage'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'defining_code' => {
                                        'code_string'    => 'at0004',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    'value'  => 'M',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.inrg_staging.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.inrg_staging.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        }
                    },
                    {
                        'items' => [
                            {
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0006'
                                    },
                                    'value' => 'Dukes Stage D'
                                },
                                'archetype_node_id' => 'at0001',
                                'name'              => {
                                    'value'  => 'Modified Dukes stage',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Modified Dukes stage'
                        },
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.modified_dukes_stage.v0'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.modified_dukes_stage.v0'
                    },
                    {
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'AJCC stage',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Stage IB'
                                },
                                'name' => {
                                    'value'  => 'AJCC Stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'AJCC Stage version',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'AJCC Stage version 55'
                                },
                                'archetype_node_id' => 'at0017'
                            }
                        ],
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                            }
                        }
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.figo_grade.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value'  => 'openEHR-EHR-CLUSTER.figo_grade.v0',
                                '@class' => 'ARCHETYPE_ID'
                            }
                        },
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'Final FIGO stage',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => 'IB',
                                    'defining_code' => {
                                        'code_string'    => 'at0008',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'FIGO grade'
                                }
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'FIGO version',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0005',
                                'value'             => {
                                    'value'  => 'Figo Version 89',
                                    '@class' => 'DV_TEXT'
                                }
                            }
                        ]
                    },
                    {
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
                            }
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'Upper GI staging',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'BCLC stage'
                                },
                                '@class' => 'CLUSTER',
                                'items'  => [
                                    {
                                        '@class' => 'ELEMENT',
                                        'name'   => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'BCLC stage'
                                        },
                                        'archetype_node_id' => 'at0001',
                                        'value'             => {
                                            '@class'        => 'DV_CODED_TEXT',
                                            'value'         => 'D',
                                            'defining_code' => {
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                '@class'      => 'CODE_PHRASE',
                                                'code_string' => 'at0007'
                                            }
                                        }
                                    }
                                ],
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.bclc_stage.v0',
                                'archetype_details' => {
                                    'archetype_id' => {
                                        '@class' => 'ARCHETYPE_ID',
                                        'value' =>
                                          'openEHR-EHR-CLUSTER.bclc_stage.v0'
                                    },
                                    'rm_version' => '1.0.1',
                                    '@class'     => 'ARCHETYPED'
                                }
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Child-Pugh score'
                                },
                                '@class' => 'CLUSTER',
                                'items'  => [
                                    {
                                        'value' => {
                                            'defining_code' => {
                                                '@class' => 'CODE_PHRASE',
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                'code_string' => 'at0028'
                                            },
                                            'value' =>
'The Child-Pugh grade is Class B with a total score of 7 to 9 points.',
                                            '@class' => 'DV_CODED_TEXT'
                                        },
                                        'archetype_node_id' => 'at0026',
                                        'name'              => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'Grade'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                'archetype_details' => {
                                    '@class'       => 'ARCHETYPED',
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
'openEHR-EHR-CLUSTER.child_pugh_score.v0',
                                        '@class' => 'ARCHETYPE_ID'
                                    }
                                },
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                            },
                            {
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'N',
                                    'defining_code' => {
                                        'code_string'    => 'at0005',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class' => 'CODE_PHRASE'
                                    }
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Portal invasion'
                                }
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Number of lesions'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'magnitude' => 95,
                                    '@class'    => 'DV_COUNT'
                                },
                                'archetype_node_id' => 'at0007'
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Pancreatic clinical stage'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'value' =>
'Stage is deemed to be localised and resectable.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0009'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0008'
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value' => 'Transarterial chemoembolisation'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    '@class' => 'DV_CODED_TEXT',
                                    'value' =>
'Transarterial chemoembolisation is deemed to be present.',
                                    'defining_code' => {
                                        'code_string'    => 'at0015',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class' => 'CODE_PHRASE'
                                    }
                                },
                                'archetype_node_id' => 'at0014'
                            }
                        ]
                    },
                    {
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
'openEHR-EHR-CLUSTER.testicular_staging_gel.v0'
                            }
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                        'items' => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Stage grouping testicular'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'Stage 3C',
                                    'defining_code' => {
                                        'code_string'    => 'at0010',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class' => 'CODE_PHRASE'
                                    }
                                }
                            },
                            {
                                'name' => {
                                    'value'  => 'Extranodal metastases',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0014',
                                'value'             => {
                                    'value' => 'Brain involvement is present.',
                                    'defining_code' => {
                                        'code_string'    => 'at0016',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0020',
                                'value'             => {
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0021'
                                    },
                                    'value' =>
'Less than or equal to 3 lung metastases are present.',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value' =>
                                      'Lung metastases sub-stage grouping'
                                }
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'Testicular staging',
                            '@class' => 'DV_TEXT'
                        }
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            }
                        },
                        'items' => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Synchronous tumour indicator'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'defining_code' => {
                                        'code_string'    => 'at0003',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    'value'  => '2 Appendix',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'name' => {
                            'value'  => 'Colorectal diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER'
                    }
                ],
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'structure'
                },
                '@class'            => 'ITEM_TREE',
                'archetype_node_id' => 'at0001'
            },
            'archetype_node_id' =>
              'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
            'language' => {
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'ISO_639-1'
                },
                '@class'      => 'CODE_PHRASE',
                'code_string' => 'en'
            },
            'feeder_audit' => {
                '@class'                   => 'FEEDER_AUDIT',
                'originating_system_audit' => {
                    'time' => {
                        '@class' => 'DV_DATE_TIME',
                        'value'  => '2011-01-01T00:00:00Z'
                    },
                    '@class'     => 'FEEDER_AUDIT_DETAILS',
                    'system_id'  => 'Infoflex',
                    'version_id' => '5C0734F2-512-A414-9CAE-BF1AF760D0AQ'
                }
            },
            'archetype_details' => {
                '@class'       => 'ARCHETYPED',
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
                    '@class' => 'ARCHETYPE_ID'
                }
            }
        },
        {
            'archetype_details' => {
                '@class'       => 'ARCHETYPED',
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
                    '@class' => 'ARCHETYPE_ID'
                }
            },
            'feeder_audit' => {
                '@class'                   => 'FEEDER_AUDIT',
                'originating_system_audit' => {
                    '@class'     => 'FEEDER_AUDIT_DETAILS',
                    'system_id'  => 'Infoflex',
                    'version_id' => '5CO83D33-512-A414-835A-FC3232835656',
                    'time'       => {
                        'value'  => '2015-05-05T00:00:00Z',
                        '@class' => 'DV_DATE_TIME'
                    }
                }
            },
            'language' => {
                'code_string'    => 'en',
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    'value'  => 'ISO_639-1',
                    '@class' => 'TERMINOLOGY_ID'
                }
            },
            'archetype_node_id' =>
              'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
            'data' => {
                'items' => [
                    {
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Diagnosis'
                        },
                        '@class'            => 'ELEMENT',
                        'archetype_node_id' => 'at0002',
                        'value'             => {
                            '@class'        => 'DV_CODED_TEXT',
                            'defining_code' => {
                                'code_string'    => 'C71.6',
                                'terminology_id' => {
                                    '@class' => 'TERMINOLOGY_ID',
                                    'value'  => 'ICD-10'
                                },
                                '@class' => 'CODE_PHRASE'
                            },
                            'value' =>
                              'Malignant neoplasm of cerebrum, cerebellum'
                        }
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Tumour identifier'
                                },
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'id'       => 'aassdddffee',
                                    'assigner' => 'cancer care',
                                    'type'     => 'local',
                                    '@class'   => 'DV_IDENTIFIER',
                                    'issuer'   => 'uclh'
                                }
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Tumour ID'
                        },
                        '@class' => 'CLUSTER'
                    },
                    {
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Clinical evidence'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Base of diagnosis'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value' =>
'2 Clinical investigation including all diagnostic techniques',
                                    '@class' => 'DV_TEXT'
                                }
                            }
                        ],
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                    },
                    {
                        'name' => {
                            'value'  => 'Cancer diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Recurrence indicator'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'No, not recurrence',
                                    'defining_code' => {
                                        'code_string'    => 'at0016',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class' => 'CODE_PHRASE'
                                    }
                                },
                                'archetype_node_id' => 'at0013'
                            },
                            {
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => '8071/3',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'ICD-O-3'
                                        },
                                        'code_string' => '8071/3'
                                    }
                                },
                                'archetype_node_id' => 'at0001',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Morphology'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0002',
                                'value'             => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'C06.9',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'ICD-O-3',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value' => 'C06.9'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Topography',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0017',
                                'value'             => {
                                    'value' =>
'Metastatic disease is located in the skin',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0023'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Metastatic site'
                                }
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Tumour laterality'
                                },
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => '9',
                                    'defining_code' => {
                                        'code_string'    => 'at0033',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    }
                                },
                                'archetype_node_id' => 'at0028'
                            }
                        ],
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Integrated TNM'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                'value' => {
                                    'value'  => 'Integrated T 90',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0001',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated T'
                                }
                            },
                            {
                                'name' => {
                                    'value'  => 'Integrated N',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'value'  => 'Integrated N 15',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0002'
                            },
                            {
                                'name' => {
                                    'value'  => 'Integrated M',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value'  => 'Integrated M 25',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0005',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value' =>
                                      'G4 Undifferentiated / anaplastic'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Grading at diagnosis'
                                }
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated Stage grouping'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    'value'  => 'Integrated Stage grouping 31',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0017',
                                'value'             => {
                                    'value'  => 'Integrated TNM Edition 44',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Integrated TNM Edition',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ]
                    },
                    {
                        'name' => {
                            'value'  => 'INRG staging',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER',
                        'items'  => [
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'INRG stage',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'M',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0004'
                                    }
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' => 'openEHR-EHR-CLUSTER.inrg_staging.v0'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.inrg_staging.v0'
                    },
                    {
                        'archetype_details' => {
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1',
                            '@class'     => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                        'items' => [
                            {
                                'value' => {
                                    'value'         => 'Dukes Stage D',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0006'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0001',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Modified Dukes stage'
                                }
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Modified Dukes stage'
                        },
                        '@class' => 'CLUSTER'
                    },
                    {
                        'items' => [
                            {
                                'value' => {
                                    'value'  => 'Stage IB',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0007',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    'value'  => 'AJCC Stage grouping',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'AJCC Stage version'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'value'  => 'AJCC Stage version 55',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0017'
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'AJCC stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                            }
                        }
                    },
                    {
                        'items' => [
                            {
                                'name' => {
                                    'value'  => 'FIGO grade',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0008'
                                    },
                                    'value'  => 'IB',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            },
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'FIGO version'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0005',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Figo Version 89'
                                }
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Final FIGO stage'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.figo_grade.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value'  => 'openEHR-EHR-CLUSTER.figo_grade.v0',
                                '@class' => 'ARCHETYPE_ID'
                            }
                        }
                    },
                    {
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                  'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
                            }
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                        'items' => [
                            {
                                'archetype_details' => {
                                    '@class'       => 'ARCHETYPED',
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        '@class' => 'ARCHETYPE_ID',
                                        'value' =>
                                          'openEHR-EHR-CLUSTER.bclc_stage.v0'
                                    }
                                },
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.bclc_stage.v0',
                                'items' => [
                                    {
                                        'archetype_node_id' => 'at0001',
                                        'value'             => {
                                            'value'         => 'D',
                                            'defining_code' => {
                                                'code_string'    => 'at0007',
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                '@class' => 'CODE_PHRASE'
                                            },
                                            '@class' => 'DV_CODED_TEXT'
                                        },
                                        'name' => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'BCLC stage'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'BCLC stage'
                                }
                            },
                            {
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        '@class' => 'ARCHETYPE_ID',
                                        'value' =>
'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.child_pugh_score.v0',
                                'items' => [
                                    {
                                        'value' => {
                                            'defining_code' => {
                                                '@class' => 'CODE_PHRASE',
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                'code_string' => 'at0028'
                                            },
                                            'value' =>
'The Child-Pugh grade is Class B with a total score of 7 to 9 points.',
                                            '@class' => 'DV_CODED_TEXT'
                                        },
                                        'archetype_node_id' => 'at0026',
                                        'name'              => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'Grade'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                'name' => {
                                    'value'  => 'Child-Pugh score',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'CLUSTER'
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Portal invasion',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value'         => 'N',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0005'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                }
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    'value'  => 'Number of lesions',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    '@class'    => 'DV_COUNT',
                                    'magnitude' => 95
                                }
                            },
                            {
                                'value' => {
                                    '@class' => 'DV_CODED_TEXT',
                                    'value' =>
'Stage is deemed to be localised and resectable.',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0009'
                                    }
                                },
                                'archetype_node_id' => 'at0008',
                                'name'              => {
                                    'value'  => 'Pancreatic clinical stage',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value' => 'Transarterial chemoembolisation'
                                },
                                'value' => {
                                    'value' =>
'Transarterial chemoembolisation is deemed to be present.',
                                    'defining_code' => {
                                        'code_string'    => 'at0015',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class' => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0014'
                            }
                        ],
                        'name' => {
                            'value'  => 'Upper GI staging',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'CLUSTER'
                    },
                    {
                        '@class' => 'CLUSTER',
                        'name'   => {
                            'value'  => 'Testicular staging',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'Stage 3C',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0010'
                                    }
                                },
                                'archetype_node_id' => 'at0001',
                                'name'              => {
                                    'value'  => 'Stage grouping testicular',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0014',
                                'value'             => {
                                    'value' => 'Brain involvement is present.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0016'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Extranodal metastases'
                                }
                            },
                            {
                                'archetype_node_id' => 'at0020',
                                'value'             => {
                                    '@class' => 'DV_CODED_TEXT',
                                    'value' =>
'Less than or equal to 3 lung metastases are present.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0021'
                                    }
                                },
                                'name' => {
                                    'value' =>
                                      'Lung metastases sub-stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
'openEHR-EHR-CLUSTER.testicular_staging_gel.v0'
                            },
                            'rm_version' => '1.0.1'
                        }
                    },
                    {
                        'items' => [
                            {
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Synchronous tumour indicator'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0003'
                                    },
                                    'value'  => '2 Appendix',
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Colorectal diagnosis'
                        },
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        }
                    }
                ],
                'name' => {
                    'value'  => 'structure',
                    '@class' => 'DV_TEXT'
                },
                '@class'            => 'ITEM_TREE',
                'archetype_node_id' => 'at0001'
            },
            'encoding' => {
                'code_string'    => 'UTF-8',
                'terminology_id' => {
                    'value'  => 'IANA_character-sets',
                    '@class' => 'TERMINOLOGY_ID'
                },
                '@class' => 'CODE_PHRASE'
            },
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            '@class' => 'EVALUATION',
            'name'   => {
                'value'  => 'Problem/Diagnosis #2',
                '@class' => 'DV_TEXT'
            }
        }
    ],
    'composer' => {
        'name'   => 'OpenEHR-Perl-FLAT',
        '@class' => 'PARTY_IDENTIFIED'
    },
    'archetype_details' => {
        'archetype_id' => {
            '@class' => 'ARCHETYPE_ID',
            'value'  => 'openEHR-EHR-COMPOSITION.report.v1'
        },
        'rm_version'  => '1.0.1',
        'template_id' => {
            'value'  => 'GEL Cancer diagnosis input.v0',
            '@class' => 'TEMPLATE_ID'
        },
        '@class' => 'ARCHETYPED'
    },
    'name' => {
        'value'  => 'GEL Cancer diagnosis',
        '@class' => 'DV_TEXT'
    },
    '@class' => 'COMPOSITION',
    'uid'    => {
        '@class' => 'OBJECT_VERSION_ID',
        'value'  => 'e1eea189-ab15-4f49-9cb2-14d4c0091894::default::1'
    },
    'context' => {
        'health_care_facility' => {
            'name'         => 'UCLH NHS Foundation Trust',
            '@class'       => 'PARTY_IDENTIFIED',
            'external_ref' => {
                'type' => 'PARTY',
                'id'   => {
                    'scheme' => 'UCLH-NS',
                    'value'  => 'RRV',
                    '@class' => 'GENERIC_ID'
                },
                'namespace' => 'UCLH-NS',
                '@class'    => 'PARTY_REF'
            }
        },
        'setting' => {
            '@class'        => 'DV_CODED_TEXT',
            'value'         => 'other care',
            'defining_code' => {
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'openehr'
                },
                'code_string' => '238'
            }
        },
        'start_time' => {
            'value'  => '2019-02-28T00:00:00Z',
            '@class' => 'DV_DATE_TIME'
        },
        '@class'        => 'EVENT_CONTEXT',
        'other_context' => {
            'items' => [
                {
                    '@class' => 'ELEMENT',
                    'name'   => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Report ID'
                    },
                    'archetype_node_id' => 'at0002',
                    'value'             => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'TT123123Z'
                    }
                }
            ],
            'name' => {
                '@class' => 'DV_TEXT',
                'value'  => 'Tree'
            },
            '@class'            => 'ITEM_TREE',
            'archetype_node_id' => 'at0001'
        }
    },
    'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1'
};
