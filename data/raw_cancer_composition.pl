#dd08d80c-f5a7-4ab7-a50e-68afd6879bb5::default::1
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
        'value'  => 'dd08d80c-f5a7-4ab7-a50e-68afd6879bb5::default::1',
        '@class' => 'OBJECT_VERSION_ID'
    },
    'content' => [
        {
            'protocol' => {
                'archetype_node_id' => 'at0032',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0070',
                        'value'             => {
                            'value'  => '2018-11-23T16:40:57Z',
                            '@class' => 'DV_DATE_TIME'
                        },
                        'name' => {
                            'value'  => 'Event date',
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
            'archetype_node_id' =>
              'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'name' => {
                'value'  => 'Problem/Diagnosis',
                '@class' => 'DV_TEXT'
            },
            'data' => {
                'archetype_node_id' => 'at0001',
                'name'              => {
                    'value'  => 'structure',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0002',
                        'value'             => {
                            'value' =>
                              'Malignant neoplasm of cerebrum, cerebellum',
                            'defining_code' => {
                                'terminology_id' => {
                                    'value'  => 'ICD-10',
                                    '@class' => 'TERMINOLOGY_ID'
                                },
                                'code_string' => 'C71.6',
                                '@class'      => 'CODE_PHRASE'
                            },
                            '@class' => 'DV_CODED_TEXT'
                        },
                        'name' => {
                            'value'  => 'Diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        '@class' => 'ELEMENT'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                        'name' => {
                            'value'  => 'Tumour ID',
                            '@class' => 'DV_TEXT'
                        },
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
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'type'     => 'local',
                                    'id'       => 'aassdddffee',
                                    'issuer'   => 'uclh',
                                    'assigner' => 'cancer care',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'name' => {
                                    'value'  => 'Tumour identifier',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.clinical_evidence.v1',
                        'name' => {
                            'value'  => 'Clinical evidence',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.clinical_evidence.v1',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value' =>
'2 Clinical investigation including all diagnostic techniques',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Base of diagnosis',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                        'name' => {
                            'value'  => 'Cancer diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0013',
                                'value'             => {
                                    'value'         => 'No, not recurrence',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0016',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Recurrence indicator',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => '8071/3',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => '8071/3',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Morphology',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0002',
                                'value'             => {
                                    'value'         => 'C06.9',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'C06.9',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Topography',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
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
                                        'code_string' => 'at0023',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Metastatic site',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0028',
                                'value'             => {
                                    'value' =>
'The tumour is situated on both sides of the body.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0029',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Tumour laterality',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'name' => {
                            'value'  => 'Integrated TNM',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'  => 'Integrated T 90',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Integrated T',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0002',
                                'value'             => {
                                    'value'  => 'Integrated N 15',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Integrated N',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value'  => 'Integrated M 25',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Integrated M',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0005',
                                'value'             => {
                                    'value' =>
                                      'G4 Undifferentiated / anaplastic',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Grading at diagnosis',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    'value'  => 'Integrated Stage grouping 31',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Integrated Stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
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
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.inrg_staging.v0',
                        'name' => {
                            'value'  => 'INRG staging',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.inrg_staging.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => 'N',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0005',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'INRG stage',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                        'name' => {
                            'value'  => 'Modified Dukes stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value' =>
'Dukes B Tumour penetrates through the muscularis propia to involve extramural tissues, nodes negative.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0003',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Modified Dukes stage',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                        'name' => {
                            'value'  => 'AJCC stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    'value'  => 'Stage IB',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'AJCC Stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0017',
                                'value'             => {
                                    'value'  => 'AJCC Stage version 55',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'AJCC Stage version',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.figo_grade.v0',
                        'name' => {
                            'value'  => 'Final FIGO stage',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value'  => 'openEHR-EHR-CLUSTER.figo_grade.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => 'ib',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0008',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'FIGO grade',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0005',
                                'value'             => {
                                    'value'  => 'Figo Version 89',
                                    '@class' => 'DV_TEXT'
                                },
                                'name' => {
                                    'value'  => 'FIGO version',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                        'name' => {
                            'value'  => 'Upper GI staging',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                  'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.bclc_stage.v0',
                                'name' => {
                                    'value'  => 'BCLC stage',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
                                          'openEHR-EHR-CLUSTER.bclc_stage.v0',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {
                                        'archetype_node_id' => 'at0001',
                                        'value'             => {
                                            'value'         => 'D',
                                            'defining_code' => {
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                'code_string' => 'at0007',
                                                '@class'      => 'CODE_PHRASE'
                                            },
                                            '@class' => 'DV_CODED_TEXT'
                                        },
                                        'name' => {
                                            'value'  => 'BCLC stage',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER'
                            },
                            {
                                'archetype_node_id' =>
                                  'openEHR-EHR-CLUSTER.child_pugh_score.v0',
                                'name' => {
                                    'value'  => 'Child-Pugh score',
                                    '@class' => 'DV_TEXT'
                                },
                                'archetype_details' => {
                                    'rm_version'   => '1.0.1',
                                    'archetype_id' => {
                                        'value' =>
'openEHR-EHR-CLUSTER.child_pugh_score.v0',
                                        '@class' => 'ARCHETYPE_ID'
                                    },
                                    '@class' => 'ARCHETYPED'
                                },
                                'items' => [
                                    {
                                        'archetype_node_id' => 'at0026',
                                        'value'             => {
                                            'value' => 'Class A 5 to 6 points.',
                                            'defining_code' => {
                                                'terminology_id' => {
                                                    'value'  => 'local',
                                                    '@class' => 'TERMINOLOGY_ID'
                                                },
                                                'code_string' => 'at0027',
                                                '@class'      => 'CODE_PHRASE'
                                            },
                                            '@class' => 'DV_CODED_TEXT'
                                        },
                                        'name' => {
                                            'value'  => 'Grade',
                                            '@class' => 'DV_TEXT'
                                        },
                                        '@class' => 'ELEMENT'
                                    }
                                ],
                                '@class' => 'CLUSTER'
                            },
                            {
                                'archetype_node_id' => 'at0003',
                                'value'             => {
                                    'value'         => 'N',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0005',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Portal invasion',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0007',
                                'value'             => {
                                    'magnitude' => 95,
                                    '@class'    => 'DV_COUNT'
                                },
                                'name' => {
                                    'value'  => 'Number of lesions',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0008',
                                'value'             => {
                                    'value' =>
'Stage is deemed to be unresectable (locally advanced).',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0012',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Pancreatic clinical stage',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0014',
                                'value'             => {
                                    'value' =>
'Transarterial chemoembolisation is deemed to be present.',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0015',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value' =>
                                      'Transarterial chemoembolisation',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                        'name' => {
                            'value'  => 'Testicular staging',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => '3C adjusted',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0010',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Stage grouping testicular',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0014',
                                'value'             => {
                                    'value'         => 'L Lung involvement',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0019',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Extranodal metastases',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            },
                            {
                                'archetype_node_id' => 'at0020',
                                'value'             => {
                                    'value' =>
                                      'L1 less than or equal to 4 metastases',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0021',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value' =>
                                      'Lung metastases sub-stage grouping',
                                    '@class' => 'DV_TEXT'
                                },
                                '@class' => 'ELEMENT'
                            }
                        ],
                        '@class' => 'CLUSTER'
                    },
                    {
                        'archetype_node_id' =>
                          'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                        'name' => {
                            'value'  => 'Colorectal diagnosis',
                            '@class' => 'DV_TEXT'
                        },
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {
                                'archetype_node_id' => 'at0001',
                                'value'             => {
                                    'value'         => '2 Appendix',
                                    'defining_code' => {
                                        'terminology_id' => {
                                            'value'  => 'local',
                                            '@class' => 'TERMINOLOGY_ID'
                                        },
                                        'code_string' => 'at0003',
                                        '@class'      => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'name' => {
                                    'value'  => 'Synchronous tumour indicator',
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
            'archetype_details' => {
                'rm_version'   => '1.0.1',
                'archetype_id' => {
                    'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
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
        'value'  => 'GEL Cancer diagnosis',
        '@class' => 'DV_TEXT'
    },
    'archetype_details' => {
        'template_id' => {
            'value'  => 'GEL Cancer diagnosis input.v0',
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
            'value'  => '2018-11-23T16:40:57.212Z',
            '@class' => 'DV_DATE_TIME'
        },
        'health_care_facility' => {
            'name'         => 'UCLH NHS Foundation Trust',
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
                        'value'  => '7275aa5d-50b0-4bad-b9c6-d296c528fa52CREP',
                        '@class' => 'DV_TEXT'
                    },
                    'name' => {
                        'value'  => 'Report ID',
                        '@class' => 'DV_TEXT'
                    },
                    '@class' => 'ELEMENT'
                },
                {
                    'archetype_node_id' =>
                      'openEHR-EHR-CLUSTER.participant_gel.v0',
                    'name' => {
                        'value'  => 'Participant',
                        '@class' => 'DV_TEXT'
                    },
                    'archetype_details' => {
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            'value' => 'openEHR-EHR-CLUSTER.participant_gel.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        '@class' => 'ARCHETYPED'
                    },
                    'items' => [
                        {
                            'archetype_node_id' => 'at0015',
                            'value'             => {
                                'type' => 'Prescription',
                                'id' => '85e10b15-7b79-46c0-8d94-892cad063048',
                                'issuer'   => 'Issuer',
                                'assigner' => 'Assigner',
                                '@class'   => 'DV_IDENTIFIER'
                            },
                            'name' => {
                                'value'  => 'Participant identifier',
                                '@class' => 'DV_TEXT'
                            },
                            '@class' => 'ELEMENT'
                        },
                        {
                            'archetype_node_id' => 'at0016',
                            'value'             => {
                                'type' => 'Prescription',
                                'id' => '0a9db4b5-44cb-4254-ae23-722c1178c265',
                                'issuer'   => 'Issuer',
                                'assigner' => 'Assigner',
                                '@class'   => 'DV_IDENTIFIER'
                            },
                            'name' => {
                                'value'  => 'Study identifier',
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
        'name'   => 'OpenEHR-Perl-FLAT',
        '@class' => 'PARTY_IDENTIFIED'
    }
};
