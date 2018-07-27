$VAR1 = {
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
    'territory' => {
        '@class'         => 'CODE_PHRASE',
        'code_string'    => 'GB',
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_3166-1'
        }
    },
    'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
    'uid'               => {
        '@class' => 'OBJECT_VERSION_ID',
        'value'  => 'de7b024f-aba4-4401-ab73-4d18bb49d60d::default::1'
    },
    'composer' => {
        '@class' => 'PARTY_IDENTIFIED',
        'name'   => 'Aupen Ayre'
    },
    'content' => [
        {   'archetype_node_id' =>
                'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
            'data' => {
                'name' => {
                    'value'  => 'structure',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {   'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Diagnosis'
                        },
                        'value' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Diagnosis 59'
                        },
                        'archetype_node_id' => 'at0002',
                        '@class'            => 'ELEMENT'
                    },
                    {   'name' => {
                            'value'  => 'Tumour ID',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {   'value' => {
                                    'id' =>
                                        '1b85693c-a17a-426c-ad74-0fb086375da3',
                                    'issuer'   => 'Issuer',
                                    '@class'   => 'DV_IDENTIFIER',
                                    'assigner' => 'Assigner',
                                    'type'     => 'Prescription'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Tumour identifier'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        'archetype_details' => {
                            'archetype_id' => {
                                'value' =>
                                    'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1',
                            '@class'     => 'ARCHETYPED'
                        },
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                        '@class' => 'CLUSTER'
                    },
                    {   'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                            }
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Clinical evidence'
                        },
                        'items' => [
                            {   'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => '6 Histology of metastasis'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Base of diagnosis'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0003'
                            }
                        ],
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.clinical_evidence.v1',
                        '@class' => 'CLUSTER'
                    },
                    {   '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                        'name' => {
                            'value'  => 'Cancer diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        'items' => [
                            {   'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0016'
                                    },
                                    'value' => 'NN'
                                },
                                'name' => {
                                    'value'  => 'Recurrence indicator',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0013'
                            },
                            {   'value' => {
                                    'value'  => 'Morphology 46',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Morphology'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001'
                            },
                            {   'archetype_node_id' => 'at0002',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Topography'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Topography 75'
                                }
                            },
                            {   'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => '08 Skin',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0023',
                                        '@class'      => 'CODE_PHRASE'
                                    }
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Metastatic site'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0017'
                            },
                            {   'archetype_node_id' => 'at0028',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Tumour laterality'
                                },
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => 'Not known',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0033',
                                        '@class'      => 'CODE_PHRASE'
                                    }
                                }
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
                        }
                    },
                    {   'items' => [
                            {   'archetype_node_id' => 'at0001',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    'value'  => 'Integrated T',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated T 99'
                                }
                            },
                            {   'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated N'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated N 15'
                                },
                                'archetype_node_id' => 'at0002',
                                '@class'            => 'ELEMENT'
                            },
                            {   'archetype_node_id' => 'at0003',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated M'
                                },
                                'value' => {
                                    'value'  => 'Integrated M 25',
                                    '@class' => 'DV_TEXT'
                                }
                            },
                            {   'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Grading at diagnosis'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value' =>
                                        'G4 Undifferentiated / anaplastic'
                                },
                                'archetype_node_id' => 'at0005',
                                '@class'            => 'ELEMENT'
                            },
                            {   'archetype_node_id' => 'at0007',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated Stage grouping'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated Stage grouping 31'
                                }
                            },
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0017',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated TNM Edition 44'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Integrated TNM Edition'
                                }
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Integrated TNM'
                        },
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                            }
                        },
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        '@class' => 'CLUSTER'
                    },
                    {   'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.inrg_staging.v0'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'INRG staging'
                        },
                        'items' => [
                            {   'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'at0004',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value' => 'M'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'INRG stage'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001'
                            }
                        ],
                        '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.inrg_staging.v0'
                    },
                    {   'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                        '@class'            => 'CLUSTER',
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
                                    'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Modified Dukes stage'
                        },
                        'items' => [
                            {   'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'at0006',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value' => 'Dukes Stage D'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Modified Dukes stage'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001'
                            }
                        ]
                    },
                    {   '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'items' => [
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Stage IB'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'AJCC Stage grouping'
                                }
                            },
                            {   'archetype_node_id' => 'at0017',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    'value'  => 'AJCC Stage version',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'AJCC Stage version 55'
                                }
                            }
                        ],
                        'name' => {
                            'value'  => 'AJCC stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                            },
                            'rm_version' => '1.0.1'
                        }
                    },
                    {   '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.figo_grade.v0',
                        'items' => [
                            {   'archetype_node_id' => 'at0001',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'FIGO grade'
                                },
                                'value' => {
                                    'value'         => 'ib',
                                    'defining_code' => {
                                        'code_string'    => 'at0008',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                }
                            },
                            {   'archetype_node_id' => 'at0005',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    'value'  => 'FIGO version',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    'value'  => 'FIGO version 99',
                                    '@class' => 'DV_TEXT'
                                }
                            }
                        ],
                        'name' => {
                            'value'  => 'Final FIGO stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                    'openEHR-EHR-CLUSTER.figo_grade.v0',
                                '@class' => 'ARCHETYPE_ID'
                            }
                        }
                    },
                    {   'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                        '@class' => 'CLUSTER',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Upper GI staging'
                        },
                        'items' => [
                            {   'archetype_node_id' =>
                                    'openEHR-EHR-CLUSTER.bclc_stage.v0',
                                '@class' => 'CLUSTER',
                                'items'  => [
                                    {   'value' => {
                                            '@class' => 'DV_CODED_TEXT',
                                            'defining_code' => {
                                                'terminology_id' => {
                                                    'value' => 'local',
                                                    '@class' =>
                                                        'TERMINOLOGY_ID'
                                                },
                                                '@class' => 'CODE_PHRASE',
                                                'code_string' => 'at0007'
                                            },
                                            'value' => 'D'
                                        },
                                        'name' => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'BCLC stage'
                                        },
                                        '@class'            => 'ELEMENT',
                                        'archetype_node_id' => 'at0001'
                                    }
                                ],
                                'name' => {
                                    'value'  => 'BCLC stage',
                                    '@class' => 'DV_TEXT'
                                },
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
                            {   'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        '@class' => 'ARCHETYPE_ID',
                                        'value' =>
                                            'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {   '@class'            => 'ELEMENT',
                                        'archetype_node_id' => 'at0026',
                                        'value'             => {
                                            '@class' => 'DV_CODED_TEXT',
                                            'value' =>
                                                'Class A 5 to 6 points.',
                                            'defining_code' => {
                                                'terminology_id' => {
                                                    'value' => 'local',
                                                    '@class' =>
                                                        'TERMINOLOGY_ID'
                                                },
                                                'code_string' => 'at0027',
                                                '@class'      => 'CODE_PHRASE'
                                            }
                                        },
                                        'name' => {
                                            '@class' => 'DV_TEXT',
                                            'value'  => 'Grade'
                                        }
                                    }
                                ],
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Child-Pugh score'
                                },
                                '@class' => 'CLUSTER',
                                'archetype_node_id' =>
                                    'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                            },
                            {   'name' => {
                                    'value'  => 'Portal invasion',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    'value'         => 'N Not present',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0005'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0003',
                                '@class'            => 'ELEMENT'
                            },
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    'magnitude' => 96,
                                    '@class'    => 'DV_COUNT'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Number of lesions'
                                }
                            },
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0008',
                                'value'             => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'at0012',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        }
                                    },
                                    'value' =>
                                        '31 Unresectable locally advanced'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Pancreatic clinical stage'
                                }
                            },
                            {   'value' => {
                                    'value'         => 'Y Yes',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        '@class'      => 'CODE_PHRASE',
                                        'code_string' => 'at0015'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value' =>
                                        'Transarterial chemoembolisation'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0014'
                            }
                        ],
                        'archetype_details' => {
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
                            },
                            'rm_version' => '1.0.1',
                            '@class'     => 'ARCHETYPED'
                        }
                    },
                    {   'items' => [
                            {   'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'value'         => '3C',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0010',
                                        '@class'      => 'CODE_PHRASE'
                                    }
                                },
                                'name' => {
                                    'value'  => 'Stage grouping testicular',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001'
                            },
                            {   'archetype_node_id' => 'at0014',
                                '@class'            => 'ELEMENT',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Extranodal metastases'
                                },
                                'value' => {
                                    '@class'        => 'DV_CODED_TEXT',
                                    'defining_code' => {
                                        'code_string'    => 'at0019',
                                        '@class'         => 'CODE_PHRASE',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    'value' => 'L Lung involvement'
                                }
                            },
                            {   'name' => {
                                    'value' =>
                                        'Lung metastases sub-stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    'value' =>
                                        'L1 less than or equal to 3 metastases',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' => 'at0021',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0020',
                                '@class'            => 'ELEMENT'
                            }
                        ],
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Testicular staging'
                        },
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'archetype_id' => {
                                'value' =>
                                    'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            'rm_version' => '1.0.1'
                        },
                        '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.testicular_staging_gel.v0'
                    },
                    {   'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Colorectal diagnosis'
                        },
                        'items' => [
                            {   '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => '2 Appendix',
                                    'defining_code' => {
                                        '@class'         => 'CODE_PHRASE',
                                        'code_string'    => 'at0003',
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        }
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value' => 'Synchronous tumour indicator',
                                    '@class' => 'DV_TEXT'
                                }
                            }
                        ],
                        'archetype_details' => {
                            '@class'       => 'ARCHETYPED',
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                '@class' => 'ARCHETYPE_ID',
                                'value' =>
                                    'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0'
                            }
                        },
                        '@class' => 'CLUSTER',
                        'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0'
                    }
                ],
                '@class'            => 'ITEM_TREE',
                'archetype_node_id' => 'at0001'
            },
            'name' => {
                '@class' => 'DV_TEXT',
                'value'  => 'Problem/Diagnosis'
            },
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
                    '@class' => 'ARCHETYPE_ID'
                },
                '@class' => 'ARCHETYPED'
            },
            'protocol' => {
                'archetype_node_id' => 'at0032',
                '@class'            => 'ITEM_TREE',
                'items'             => [
                    {   '@class'            => 'ELEMENT',
                        'archetype_node_id' => 'at0070',
                        'value'             => {
                            '@class' => 'DV_DATE_TIME',
                            'value'  => '2018-07-24T14:05:01.806+01:00'
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Event date'
                        }
                    }
                ],
                'name' => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                }
            },
            'language' => {
                'code_string'    => 'en',
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'ISO_639-1'
                }
            },
            'encoding' => {
                'terminology_id' => {
                    'value'  => 'IANA_character-sets',
                    '@class' => 'TERMINOLOGY_ID'
                },
                'code_string' => 'UTF-8',
                '@class'      => 'CODE_PHRASE'
            },
            '@class'  => 'EVALUATION',
            'subject' => { '@class' => 'PARTY_SELF' }
        }
    ],
    'archetype_details' => {
        '@class'       => 'ARCHETYPED',
        'rm_version'   => '1.0.1',
        'archetype_id' => {
            '@class' => 'ARCHETYPE_ID',
            'value'  => 'openEHR-EHR-COMPOSITION.report.v1'
        },
        'template_id' => {
            'value'  => 'GEL Cancer diagnosis input.v0',
            '@class' => 'TEMPLATE_ID'
        }
    },
    'name' => {
        '@class' => 'DV_TEXT',
        'value'  => 'GEL Cancer diagnosis'
    },
    '@class'   => 'COMPOSITION',
    'language' => {
        '@class'         => 'CODE_PHRASE',
        'code_string'    => 'en',
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value'  => 'ISO_639-1'
        }
    },
    'context' => {
        'health_care_facility' => {
            'external_ref' => {
                'id' => {
                    'scheme' => 'UCLH-NS',
                    '@class' => 'GENERIC_ID',
                    'value'  => 'RRV'
                },
                '@class'    => 'PARTY_REF',
                'namespace' => 'UCLH-NS',
                'type'      => 'PARTY'
            },
            'name'   => 'UCLH NHS Foundation Trust',
            '@class' => 'PARTY_IDENTIFIED'
        },
        '@class'        => 'EVENT_CONTEXT',
        'other_context' => {
            'name' => {
                '@class' => 'DV_TEXT',
                'value'  => 'Tree'
            },
            'items' => [
                {   'value' => {
                        'value'  => 'Report ID 75',
                        '@class' => 'DV_TEXT'
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Report ID'
                    },
                    '@class'            => 'ELEMENT',
                    'archetype_node_id' => 'at0002'
                },
                {   'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.participant_gel.v0',
                    '@class'            => 'CLUSTER',
                    'archetype_details' => {
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            'value' =>
                                'openEHR-EHR-CLUSTER.participant_gel.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        '@class' => 'ARCHETYPED'
                    },
                    'items' => [
                        {   'name' => {
                                'value'  => 'Participant identifier',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                'issuer' => 'Issuer',
                                'id' =>
                                    '85e10b15-7b79-46c0-8d94-892cad063048',
                                'assigner' => 'Assigner',
                                'type'     => 'Prescription',
                                '@class'   => 'DV_IDENTIFIER'
                            },
                            'archetype_node_id' => 'at0015',
                            '@class'            => 'ELEMENT'
                        },
                        {   'value' => {
                                'id' =>
                                    '0a9db4b5-44cb-4254-ae23-722c1178c265',
                                'issuer'   => 'Issuer',
                                '@class'   => 'DV_IDENTIFIER',
                                'type'     => 'Prescription',
                                'assigner' => 'Assigner'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Study identifier'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0016'
                        }
                    ],
                    'name' => {
                        'value'  => 'Participant',
                        '@class' => 'DV_TEXT'
                    }
                }
            ],
            '@class'            => 'ITEM_TREE',
            'archetype_node_id' => 'at0001'
        },
        'start_time' => {
            'value'  => '2018-07-27T07:44:28+01:00',
            '@class' => 'DV_DATE_TIME'
        },
        'setting' => {
            '@class'        => 'DV_CODED_TEXT',
            'value'         => 'other care',
            'defining_code' => {
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'openehr'
                },
                '@class'      => 'CODE_PHRASE',
                'code_string' => '238'
            }
        }
    }
};
