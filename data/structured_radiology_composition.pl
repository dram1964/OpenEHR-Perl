#6482d43d-bcc7-45a3-b078-9e33c9d88907::default::1
$VAR1 = {
    'radiology_result_report' => {
        '_uid'     => [ '6482d43d-bcc7-45a3-b078-9e33c9d88907::default::1' ],
        'category' => [
            {
                '|code'        => '433',
                '|value'       => 'event',
                '|terminology' => 'openehr'
            }
        ],
        'language' => [
            {
                '|code'        => 'en',
                '|terminology' => 'ISO_639-1'
            }
        ],
        'composer' => [
            {
                '|name' => 'OpenEHR-Perl-FLAT'
            }
        ],
        'imaging_examination_result' => [
            {
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'encoding' => [
                    {
                        '|terminology' => 'IANA_character-sets',
                        '|code'        => 'UTF-8'
                    }
                ],
                'any_event' => [
                    {
                        'modality'        => [ 'Ultrasound' ],
                        'anatomical_side' => [
                            {
                                'anatomical_side' => [
                                    {
                                        '|value'       => 'N/A',
                                        '|terminology' => 'local',
                                        '|code'        => 'at0006'
                                    }
                                ]
                            }
                        ],
                        'overall_result_status' => [
                            {
                                '|code'        => 'at0011',
                                '|value'       => 'F',
                                '|terminology' => 'local'
                            }
                        ],
                        'imaging_report_text' => [
                            ' 7034346 25/09/2017 Ultrasound (US) Abdomen


7034346 25/09/2017 Ultrasound (US) Liver


The pancreas has a normal appearance and structure.  

The liver is normal in structure.   No focal lesion is seen.  Flow within the portal vein is hepatopetal.  There is no obstruction to the IHDs.  CBD =  3.0 mm.
The gallbladder is fluid filled.  No focal lesion is seen within.  The wall thickness is normal.

Both kidneys are normal in structure with no focal lesion and no sign of obstruction.
The right kidney measures 8.3cm.  The left kidney measures 9.1 cm.  

The spleen has a normal appearance and measures  7.9 cm.

There is no abdominal ascites seen.

Impression:  Normal study.    

J Trewin, Sonographer UCLH
HCPC:RA41509
External contact: Imaging.secretaries@uclh.nhs.uk: ext 79070
Internal contact: Via UCLH email

 
'
                        ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [
                                    {
                                        '|value'       => 'Abdominal',
                                        '|terminology' => 'GEL-REGION',
                                        '_mapping'     => [
                                            {
                                                'target' => [
                                                    {
                                                        '|code' => 'Z92.6',
                                                        '|terminology' =>
                                                          'OPCS-4-SITE'
                                                    }
                                                ],
                                                '|match' => '='
                                            }
                                        ],
                                        '|code' => 'Abdominal'
                                    }
                                ]
                            }
                        ],
                        'time'                   => [ '2017-09-25T09:02:38Z' ],
                        'datetime_result_issued' => [ '2017-09-25T09:02:38Z' ],
                        'imaging_code'           => [
                            {
                                '|code'        => 'UABDO',
                                '|terminology' => 'NICIP',
                                '|value'       => 'UABDO',
                                '_mapping'     => [
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|code'        => 'U34',
                                                '|terminology' => 'NICIP'
                                            }
                                        ]
                                    },
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|terminology' =>
                                                  'SNOMED-CT-CODE',
                                                '|code' => '45036003'
                                            }
                                        ]
                                    },
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|terminology' =>
                                                  'SNOMED-CT-DESCRIPTION',
                                                '|code' =>
'Ultrasonography of abdomen (procedure)'
                                            }
                                        ]
                                    },
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|code' => 'U08.2',
                                                '|terminology' =>
                                                  'OPCS-4-PRIMARY'
                                            }
                                        ]
                                    },
                                    {
                                        'target' => [
                                            {
                                                '|code' => 'Y98.1',
                                                '|terminology' =>
                                                  'OPCS-4-METHOD'
                                            }
                                        ],
                                        '|match' => '='
                                    }
                                ]
                            }
                        ]
                    }
                ],
                'examination_request_details' => [
                    {
                        'imaging_report_reference' => [
                            {
                                '|issuer'   => 'UCLH',
                                '|assigner' => 'UCLH RIS',
                                '|id'       => '52874656',
                                '|type'     => 'local'
                            }
                        ],
                        'examination_requested_name' =>
                          [ 'Ultrasound (US) Abdomen' ]
                    }
                ]
            },
            {
                'encoding' => [
                    {
                        '|code'        => 'UTF-8',
                        '|terminology' => 'IANA_character-sets'
                    }
                ],
                'language' => [
                    {
                        '|code'        => 'en',
                        '|terminology' => 'ISO_639-1'
                    }
                ],
                'examination_request_details' => [
                    {
                        'imaging_report_reference' => [
                            {
                                '|issuer'   => 'UCLH',
                                '|assigner' => 'UCLH RIS',
                                '|id'       => '52874656',
                                '|type'     => 'local'
                            }
                        ],
                        'examination_requested_name' =>
                          [ 'Ultrasound (US) Liver' ]
                    }
                ],
                'any_event' => [
                    {
                        'time'         => [ '2017-09-25T09:02:38Z' ],
                        'imaging_code' => [
                            {
                                '|code'        => 'UABDO',
                                '|value'       => 'UABDO',
                                '|terminology' => 'NICIP',
                                '_mapping'     => [
                                    {
                                        'target' => [
                                            {
                                                '|code'        => 'U44',
                                                '|terminology' => 'NICIP'
                                            }
                                        ],
                                        '|match' => '='
                                    },
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|code' => '45036003',
                                                '|terminology' =>
                                                  'SNOMED-CT-CODE'
                                            }
                                        ]
                                    },
                                    {
                                        '|match' => '=',
                                        'target' => [
                                            {
                                                '|code' =>
'Ultrasonography of abdomen (procedure)',
                                                '|terminology' =>
                                                  'SNOMED-CT-DESCRIPTION'
                                            }
                                        ]
                                    },
                                    {
                                        'target' => [
                                            {
                                                '|code' => 'U08.2',
                                                '|terminology' =>
                                                  'OPCS-4-PRIMARY'
                                            }
                                        ],
                                        '|match' => '='
                                    },
                                    {
                                        'target' => [
                                            {
                                                '|terminology' =>
                                                  'OPCS-4-METHOD',
                                                '|code' => 'Y98.1'
                                            }
                                        ],
                                        '|match' => '='
                                    }
                                ]
                            }
                        ],
                        'datetime_result_issued' => [ '2017-09-25T09:02:38Z' ],
                        'overall_result_status'  => [
                            {
                                '|terminology' => 'local',
                                '|value'       => 'F',
                                '|code'        => 'at0011'
                            }
                        ],
                        'anatomical_side' => [
                            {
                                'anatomical_side' => [
                                    {
                                        '|value'       => 'N/A',
                                        '|terminology' => 'local',
                                        '|code'        => 'at0006'
                                    }
                                ]
                            }
                        ],
                        'modality'            => [ 'Ultrasound' ],
                        'imaging_report_text' => [
                            ' 7034346 25/09/2017 Ultrasound (US) Abdomen


7034346 25/09/2017 Ultrasound (US) Liver


The pancreas has a normal appearance and structure.  

The liver is normal in structure.   No focal lesion is seen.  Flow within the portal vein is hepatopetal.  There is no obstruction to the IHDs.  CBD =  3.0 mm.
The gallbladder is fluid filled.  No focal lesion is seen within.  The wall thickness is normal.

Both kidneys are normal in structure with no focal lesion and no sign of obstruction.
The right kidney measures 8.3cm.  The left kidney measures 9.1 cm.  

The spleen has a normal appearance and measures  7.9 cm.

There is no abdominal ascites seen.

Impression:  Normal study.    

J Trewin, Sonographer UCLH
HCPC:RA41509
External contact: Imaging.secretaries@uclh.nhs.uk: ext 79070
Internal contact: Via UCLH email

 
'
                        ],
                        'anatomical_location' => [
                            {
                                'anatomical_site' => [
                                    {
                                        '|code'        => 'Abdominal',
                                        '|terminology' => 'GEL-REGION',
                                        '_mapping'     => [
                                            {
                                                '|match' => '=',
                                                'target' => [
                                                    {
                                                        '|terminology' =>
                                                          'OPCS-4-SITE',
                                                        '|code' => 'Z92.6'
                                                    }
                                                ]
                                            }
                                        ],
                                        '|value' => 'Abdominal'
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ],
        'context' => [
            {
                'report_id'             => [ '7034346' ],
                '_health_care_facility' => [
                    {
                        '|name'         => 'UCLH NHS Foundation Trust',
                        '|id_namespace' => 'UCLH-NS',
                        '|id_scheme'    => 'UCLH-NS',
                        '|id'           => 'RRV'
                    }
                ],
                'setting' => [
                    {
                        '|code'        => '238',
                        '|value'       => 'other care',
                        '|terminology' => 'openehr'
                    }
                ],
                'start_time' => [ '2017-09-25T09:02:38Z' ]
            }
        ],
        'territory' => [
            {
                '|code'        => 'GB',
                '|terminology' => 'ISO_3166-1'
            }
        ]
    }
};
