#cb1a8913-905d-4002-80c2-db23ae8f22bf::default::1
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
                'start_time' => [ '2018-11-26T12:11:27.200Z' ],
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
                'report_id' => [ 'TT123123Z' ]
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
                                '|code'        => 'at0006',
                                '|terminology' => 'local',
                                '|value'       => 'Dukes Stage D'
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
                                        '|code'        => 'at0028',
                                        '|terminology' => 'local',
                                        '|value' =>
'The Child-Pugh grade is Class B with a total score of 7 to 9 points.'
                                    }
                                ]
                            }
                        ],
                        'pancreatic_clinical_stage' => [
                            {
                                '|code'        => 'at0009',
                                '|terminology' => 'local',
                                '|value' =>
'Stage is deemed to be localised and resectable.'
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
                                '|code'        => 'at0004',
                                '|terminology' => 'local',
                                '|value'       => 'M'
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
                                '|value'       => 'No, not recurrence'
                            }
                        ],
                        'tumour_laterality' => [
                            {
                                '|code'        => 'at0033',
                                '|terminology' => 'local',
                                '|value' => 'Tumour laterality is unknown.'
                            }
                        ],
                        'metastatic_site' => [
                            {
                                '|code'        => 'at0023',
                                '|terminology' => 'local',
                                '|value' =>
                                  'Metastatic disease is located in the skin'
                            }
                        ],
                        'topography' => [
                            {
                                '|code'        => 'C06.9',
                                '|terminology' => 'local',
                                '|value'       => 'C06.9'
                            }
                        ],
                        'morphology' => [
                            {
                                '|code'        => '8071/3',
                                '|terminology' => 'local',
                                '|value'       => '8071/3'
                            }
                        ]
                    }
                ],
                'final_figo_stage' => [
                    {
                        'figo_grade' => [
                            {
                                '|code'        => 'at0008',
                                '|terminology' => 'local',
                                '|value'       => 'IB'
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
                'event_date'         => [ '2018-11-26T12:11:27Z' ],
                'testicular_staging' => [
                    {
                        'lung_metastases_sub-stage_grouping' => [
                            {
                                '|code'        => 'at0021',
                                '|terminology' => 'local',
                                '|value' =>
'Less than or equal to 3 lung metastases are present.'
                            }
                        ],
                        'extranodal_metastases' => [
                            {
                                '|code'        => 'at0016',
                                '|terminology' => 'local',
                                '|value' => 'Brain involvement is present.'
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
        '_uid' => [ 'cb1a8913-905d-4002-80c2-db23ae8f22bf::default::1' ]
    }
};
