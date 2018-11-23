#c2374981-e030-4f7c-8781-1e5911c266b1::default::1
$VAR1 = {
    'gel_cancer_diagnosis' => {
        'territory' => [
            {
                '|code'        => 'GB',
                '|terminology' => 'ISO_3166-1'
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
                        '|name'         => 'UCLH NHS Foundation Trust',
                        '|id_namespace' => 'UCLH-NS',
                        '|id_scheme'    => 'UCLH-NS'
                    }
                ],
                'start_time' => [ '2018-11-23T10:35:41.253Z' ],
                'setting'    => [
                    {
                        '|code'        => '238',
                        '|terminology' => 'openehr',
                        '|value'       => 'other care'
                    }
                ],
                'participant' => [
                    {
                        'participant_identifier' => [
                            {
                                '|id' => '85e10b15-7b79-46c0-8d94-892cad063048',
                                '|assigner' => 'Assigner',
                                '|issuer'   => 'Issuer',
                                '|type'     => 'Prescription'
                            }
                        ],
                        'study_identifier' => [
                            {
                                '|id' => '0a9db4b5-44cb-4254-ae23-722c1178c265',
                                '|assigner' => 'Assigner',
                                '|issuer'   => 'Issuer',
                                '|type'     => 'Prescription'
                            }
                        ]
                    }
                ],
                'report_id' => [ '436e93d8-18e8-498c-9b1a-45011d562374CREP' ]
            }
        ],
        'category' => [
            {
                '|code'        => '433',
                '|terminology' => 'openehr',
                '|value'       => 'event'
            }
        ],
        'composer' => [
            {
                '|name' => 'OpenEHR-Perl-FLAT'
            }
        ],
        'problem_diagnosis' => [
            {
                'ajcc_stage' => [
                    {
                        'ajcc_stage_version'  => [ 'AJCC Stage version 55' ],
                        'ajcc_stage_grouping' => [ 'Stage IB' ]
                    }
                ],
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'colorectal_diagnosis' => [
                    {
                        'synchronous_tumour_indicator' => [
                            {
                                '|code'        => 'at0003',
                                '|terminology' => 'local',
                                '|value'       => '2 Appendix'
                            }
                        ]
                    }
                ],
                'diagnosis' => [
                    {
                        '|code'        => 'C71.6',
                        '|terminology' => 'ICD-10',
                        '|value' => 'Malignant neoplasm of cerebrum, cerebellum'
                    }
                ],
                'modified_dukes_stage' => [
                    {
                        'modified_dukes_stage' => [
                            {
                                '|code'        => 'at0003',
                                '|terminology' => 'local',
                                '|value' =>
'Dukes B Tumour penetrates through the muscularis propia to involve extramural tissues, nodes negative.'
                            }
                        ]
                    }
                ],
                'tumour_id' => [
                    {
                        'tumour_identifier' => [
                            {
                                '|id'       => 'aassdddffee',
                                '|assigner' => 'cancer care',
                                '|issuer'   => 'uclh',
                                '|type'     => 'local'
                            }
                        ]
                    }
                ],
                'clinical_evidence' => [
                    {
                        'base_of_diagnosis' => [
'2 Clinical investigation including all diagnostic techniques'
                        ]
                    }
                ],
                'upper_gi_staging' => [
                    {
                        'transarterial_chemoembolisation' => [
                            {
                                '|code'        => 'at0015',
                                '|terminology' => 'local',
                                '|value' =>
'Transarterial chemoembolisation is deemed to be present.'
                            }
                        ],
                        'portal_invasion' => [
                            {
                                '|code'        => 'at0005',
                                '|terminology' => 'local',
                                '|value'       => 'N'
                            }
                        ],
                        'child-pugh_score' => [
                            {
                                'grade' => [
                                    {
                                        '|code'        => 'at0027',
                                        '|terminology' => 'local',
                                        '|value' => 'Class A 5 to 6 points.'
                                    }
                                ]
                            }
                        ],
                        'pancreatic_clinical_stage' => [
                            {
                                '|code'        => 'at0012',
                                '|terminology' => 'local',
                                '|value' =>
'Stage is deemed to be unresectable (locally advanced).'
                            }
                        ],
                        'bclc_stage' => [
                            {
                                'bclc_stage' => [
                                    {
                                        '|code'        => 'at0007',
                                        '|terminology' => 'local',
                                        '|value'       => 'D'
                                    }
                                ]
                            }
                        ],
                        'number_of_lesions' => [ 95 ]
                    }
                ],
                'integrated_tnm' => [
                    {
                        'integrated_stage_grouping' =>
                          [ 'Integrated Stage grouping 31' ],
                        'integrated_tnm_edition' =>
                          [ 'Integrated TNM Edition 44' ],
                        'integrated_n' => [ 'Integrated N 15' ],
                        'grading_at_diagnosis' =>
                          [ 'G4 Undifferentiated / anaplastic' ],
                        'integrated_m' => [ 'Integrated M 25' ],
                        'integrated_t' => [ 'Integrated T 90' ]
                    }
                ],
                'inrg_staging' => [
                    {
                        'inrg_stage' => [
                            {
                                '|code'        => 'at0005',
                                '|terminology' => 'local',
                                '|value'       => 'N'
                            }
                        ]
                    }
                ],
                'cancer_diagnosis' => [
                    {
                        'recurrence_indicator' => [
                            {
                                '|code'        => 'at0016',
                                '|terminology' => 'local',
                                '|value'       => 'NN'
                            }
                        ],
                        'tumour_laterality' => [
                            {
                                '|code'        => 'at0029',
                                '|terminology' => 'local',
                                '|value' =>
'The tumour is situated on both sides of the body.'
                            }
                        ],
                        'metastatic_site' => [
                            {
                                '|code'        => 'at0023',
                                '|terminology' => 'local',
                                '|value'       => '08 Skin'
                            }
                        ],
                        'topography' => [ 'Topography String' ],
                        'morphology' => [ 'Morphology String' ]
                    }
                ],
                'final_figo_stage' => [
                    {
                        'figo_grade' => [
                            {
                                '|code'        => 'at0008',
                                '|terminology' => 'local',
                                '|value'       => 'ib'
                            }
                        ],
                        'figo_version' => [ 'Figo Version 89' ]
                    }
                ],
                'encoding' => [
                    {
                        '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'event_date'         => [ '2018-11-23T10:35:41Z' ],
                'testicular_staging' => [
                    {
                        'lung_metastases_sub-stage_grouping' => [
                            {
                                '|code'        => 'at0021',
                                '|terminology' => 'local',
                                '|value' =>
                                  'L1 less than or equal to 4 metastases'
                            }
                        ],
                        'extranodal_metastases' => [
                            {
                                '|code'        => 'at0019',
                                '|terminology' => 'local',
                                '|value'       => 'L Lung involvement'
                            }
                        ],
                        'stage_grouping_testicular' => [
                            {
                                '|code'        => 'at0010',
                                '|terminology' => 'local',
                                '|value'       => '3C adjusted'
                            }
                        ]
                    }
                ]
            }
        ],
        '_uid' => [ 'c2374981-e030-4f7c-8781-1e5911c266b1::default::1' ]
    }
};
