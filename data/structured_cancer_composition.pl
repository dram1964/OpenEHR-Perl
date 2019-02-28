$VAR1 = {
    'gel_cancer_diagnosis' => {
        '_uid'     => [ 'e1eea189-ab15-4f49-9cb2-14d4c0091894::default::1' ],
        'category' => [
            {
                '|value'       => 'event',
                '|code'        => '433',
                '|terminology' => 'openehr'
            }
        ],
        'context' => [
            {
                '_health_care_facility' => [
                    {
                        '|id_namespace' => 'UCLH-NS',
                        '|name'         => 'UCLH NHS Foundation Trust',
                        '|id_scheme'    => 'UCLH-NS',
                        '|id'           => 'RRV'
                    }
                ],
                'start_time' => [ '2019-02-28T00:00Z' ],
                'report_id'  => [ 'TT123123Z' ],
                'setting'    => [
                    {
                        '|value'       => 'other care',
                        '|terminology' => 'openehr',
                        '|code'        => '238'
                    }
                ]
            }
        ],
        'territory' => [
            {
                '|terminology' => 'ISO_3166-1',
                '|code'        => 'GB'
            }
        ],
        'problem_diagnosis' => [
            {
                'testicular_staging' => [
                    {
                        'stage_grouping_testicular' => [
                            {
                                '|value'       => 'Stage 3C',
                                '|terminology' => 'local',
                                '|code'        => 'at0010'
                            }
                        ],
                        'extranodal_metastases' => [
                            {
                                '|value' => 'Brain involvement is present.',
                                '|code'  => 'at0016',
                                '|terminology' => 'local'
                            }
                        ],
                        'lung_metastases_sub-stage_grouping' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0021',
                                '|value' =>
'Less than or equal to 3 lung metastases are present.'
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
                'encoding' => [
                    {
                        '|terminology' => 'IANA_character-sets',
                        '|code'        => 'UTF-8'
                    }
                ],
                'cancer_diagnosis' => [
                    {
                        'metastatic_site' => [
                            {
                                '|value' =>
                                  'Metastatic disease is located in the skin',
                                '|code'        => 'at0023',
                                '|terminology' => 'local'
                            }
                        ],
                        'recurrence_indicator' => [
                            {
                                '|value'       => 'No, not recurrence',
                                '|code'        => 'at0016',
                                '|terminology' => 'local'
                            }
                        ],
                        'morphology' => [
                            {
                                '|value'       => '8071/3',
                                '|terminology' => 'ICD-O-3',
                                '|code'        => '8071/3'
                            }
                        ],
                        'topography' => [
                            {
                                '|value'       => 'C06.9',
                                '|terminology' => 'ICD-O-3',
                                '|code'        => 'C06.9'
                            }
                        ],
                        'tumour_laterality' => [
                            {
                                '|value'       => '9',
                                '|code'        => 'at0033',
                                '|terminology' => 'local'
                            }
                        ]
                    }
                ],
                '_feeder_audit' => [
                    {
                        'originating_system_audit' => [
                            {
                                '|system_id' => 'Infoflex',
                                '|time'      => '2011-01-01T00:00Z',
                                '|version_id' =>
                                  '5C0734F2-512-A414-9CAE-BF1AF760D0AQ'
                            }
                        ]
                    }
                ],
                'colorectal_diagnosis' => [
                    {
                        'synchronous_tumour_indicator' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0003',
                                '|value'       => '2 Appendix'
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
                'ajcc_stage' => [
                    {
                        'ajcc_stage_version'  => [ 'AJCC Stage version 55' ],
                        'ajcc_stage_grouping' => [ 'Stage IB' ]
                    }
                ],
                'upper_gi_staging' => [
                    {
                        'transarterial_chemoembolisation' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0015',
                                '|value' =>
'Transarterial chemoembolisation is deemed to be present.'
                            }
                        ],
                        'number_of_lesions'         => [ 95 ],
                        'pancreatic_clinical_stage' => [
                            {
                                '|code'        => 'at0009',
                                '|terminology' => 'local',
                                '|value' =>
'Stage is deemed to be localised and resectable.'
                            }
                        ],
                        'portal_invasion' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0005',
                                '|value'       => 'N'
                            }
                        ],
                        'bclc_stage' => [
                            {
                                'bclc_stage' => [
                                    {
                                        '|terminology' => 'local',
                                        '|code'        => 'at0007',
                                        '|value'       => 'D'
                                    }
                                ]
                            }
                        ],
                        'child-pugh_score' => [
                            {
                                'grade' => [
                                    {
                                        '|terminology' => 'local',
                                        '|code'        => 'at0028',
                                        '|value' =>
'The Child-Pugh grade is Class B with a total score of 7 to 9 points.'
                                    }
                                ]
                            }
                        ]
                    }
                ],
                'integrated_tnm' => [
                    {
                        'grading_at_diagnosis' =>
                          [ 'G4 Undifferentiated / anaplastic' ],
                        'integrated_stage_grouping' =>
                          [ 'Integrated Stage grouping 31' ],
                        'integrated_m' => [ 'Integrated M 25' ],
                        'integrated_n' => [ 'Integrated N 15' ],
                        'integrated_tnm_edition' =>
                          [ 'Integrated TNM Edition 44' ],
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
                'tumour_id' => [
                    {
                        'tumour_identifier' => [
                            {
                                '|issuer'   => 'uclh',
                                '|id'       => 'aassdddffee',
                                '|assigner' => 'cancer care',
                                '|type'     => 'local'
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
                'final_figo_stage' => [
                    {
                        'figo_grade' => [
                            {
                                '|value'       => 'IB',
                                '|code'        => 'at0008',
                                '|terminology' => 'local'
                            }
                        ],
                        'figo_version' => [ 'Figo Version 89' ]
                    }
                ],
                'modified_dukes_stage' => [
                    {
                        'modified_dukes_stage' => [
                            {
                                '|value'       => 'Dukes Stage D',
                                '|code'        => 'at0006',
                                '|terminology' => 'local'
                            }
                        ]
                    }
                ]
            },
            {
                'upper_gi_staging' => [
                    {
                        'transarterial_chemoembolisation' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0015',
                                '|value' =>
'Transarterial chemoembolisation is deemed to be present.'
                            }
                        ],
                        'pancreatic_clinical_stage' => [
                            {
                                '|value' =>
'Stage is deemed to be localised and resectable.',
                                '|code'        => 'at0009',
                                '|terminology' => 'local'
                            }
                        ],
                        'number_of_lesions' => [ 95 ],
                        'portal_invasion'   => [
                            {
                                '|value'       => 'N',
                                '|terminology' => 'local',
                                '|code'        => 'at0005'
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
                        ]
                    }
                ],
                'ajcc_stage' => [
                    {
                        'ajcc_stage_version'  => [ 'AJCC Stage version 55' ],
                        'ajcc_stage_grouping' => [ 'Stage IB' ]
                    }
                ],
                'colorectal_diagnosis' => [
                    {
                        'synchronous_tumour_indicator' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0003',
                                '|value'       => '2 Appendix'
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
                '_feeder_audit' => [
                    {
                        'originating_system_audit' => [
                            {
                                '|version_id' =>
                                  '5CO83D33-512-A414-835A-FC3232835656',
                                '|time'      => '2015-05-05T00:00Z',
                                '|system_id' => 'Infoflex'
                            }
                        ]
                    }
                ],
                'encoding' => [
                    {
                        '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'cancer_diagnosis' => [
                    {
                        'topography' => [
                            {
                                '|terminology' => 'ICD-O-3',
                                '|code'        => 'C06.9',
                                '|value'       => 'C06.9'
                            }
                        ],
                        'tumour_laterality' => [
                            {
                                '|code'        => 'at0033',
                                '|terminology' => 'local',
                                '|value'       => '9'
                            }
                        ],
                        'recurrence_indicator' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0016',
                                '|value'       => 'No, not recurrence'
                            }
                        ],
                        'morphology' => [
                            {
                                '|value'       => '8071/3',
                                '|terminology' => 'ICD-O-3',
                                '|code'        => '8071/3'
                            }
                        ],
                        'metastatic_site' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0023',
                                '|value' =>
                                  'Metastatic disease is located in the skin'
                            }
                        ]
                    }
                ],
                'diagnosis' => [
                    {
                        '|terminology' => 'ICD-10',
                        '|code'        => 'C71.6',
                        '|value' => 'Malignant neoplasm of cerebrum, cerebellum'
                    }
                ],
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
                        'stage_grouping_testicular' => [
                            {
                                '|value'       => 'Stage 3C',
                                '|terminology' => 'local',
                                '|code'        => 'at0010'
                            }
                        ],
                        'extranodal_metastases' => [
                            {
                                '|code'        => 'at0016',
                                '|terminology' => 'local',
                                '|value' => 'Brain involvement is present.'
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
                'final_figo_stage' => [
                    {
                        'figo_grade' => [
                            {
                                '|terminology' => 'local',
                                '|code'        => 'at0008',
                                '|value'       => 'IB'
                            }
                        ],
                        'figo_version' => [ 'Figo Version 89' ]
                    }
                ],
                'tumour_id' => [
                    {
                        'tumour_identifier' => [
                            {
                                '|assigner' => 'cancer care',
                                '|type'     => 'local',
                                '|id'       => 'aassdddffee',
                                '|issuer'   => 'uclh'
                            }
                        ]
                    }
                ],
                'integrated_tnm' => [
                    {
                        'integrated_stage_grouping' =>
                          [ 'Integrated Stage grouping 31' ],
                        'grading_at_diagnosis' =>
                          [ 'G4 Undifferentiated / anaplastic' ],
                        'integrated_t' => [ 'Integrated T 90' ],
                        'integrated_tnm_edition' =>
                          [ 'Integrated TNM Edition 44' ],
                        'integrated_m' => [ 'Integrated M 25' ],
                        'integrated_n' => [ 'Integrated N 15' ]
                    }
                ],
                'inrg_staging' => [
                    {
                        'inrg_stage' => [
                            {
                                '|value'       => 'M',
                                '|code'        => 'at0004',
                                '|terminology' => 'local'
                            }
                        ]
                    }
                ]
            }
        ],
        'composer' => [
            {
                '|name' => 'OpenEHR-Perl-FLAT'
            }
        ],
        'language' => [
            {
                '|code'        => 'en',
                '|terminology' => 'ISO_639-1'
            }
        ]
    }
};
