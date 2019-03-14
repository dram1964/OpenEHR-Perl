6482d43d-bcc7-45a3-b078-9e33c9d88907::default::1
$VAR1 = {
          'name' => {
                      '@class' => 'DV_TEXT',
                      'value' => 'Radiology Result Report'
                    },
          'content' => [
                         {
                           '@class' => 'OBSERVATION',
                           'archetype_node_id' => 'openEHR-EHR-OBSERVATION.imaging_exam.v0',
                           'language' => {
                                           'terminology_id' => {
                                                                 'value' => 'ISO_639-1',
                                                                 '@class' => 'TERMINOLOGY_ID'
                                                               },
                                           'code_string' => 'en',
                                           '@class' => 'CODE_PHRASE'
                                         },
                           'encoding' => {
                                           'terminology_id' => {
                                                                 'value' => 'IANA_character-sets',
                                                                 '@class' => 'TERMINOLOGY_ID'
                                                               },
                                           'code_string' => 'UTF-8',
                                           '@class' => 'CODE_PHRASE'
                                         },
                           'subject' => {
                                          '@class' => 'PARTY_SELF'
                                        },
                           'protocol' => {
                                           '@class' => 'ITEM_TREE',
                                           'items' => [
                                                        {
                                                          '@class' => 'CLUSTER',
                                                          'archetype_node_id' => 'at0027',
                                                          'items' => [
                                                                       {
                                                                         'name' => {
                                                                                     'value' => 'Examination requested name',
                                                                                     '@class' => 'DV_TEXT'
                                                                                   },
                                                                         'value' => {
                                                                                      '@class' => 'DV_TEXT',
                                                                                      'value' => 'Ultrasound (US) Abdomen'
                                                                                    },
                                                                         '@class' => 'ELEMENT',
                                                                         'archetype_node_id' => 'at0029'
                                                                       },
                                                                       {
                                                                         '@class' => 'ELEMENT',
                                                                         'archetype_node_id' => 'at0033',
                                                                         'value' => {
                                                                                      'assigner' => 'UCLH RIS',
                                                                                      'type' => 'local',
                                                                                      'id' => '52874656',
                                                                                      'issuer' => 'UCLH',
                                                                                      '@class' => 'DV_IDENTIFIER'
                                                                                    },
                                                                         'name' => {
                                                                                     '@class' => 'DV_TEXT',
                                                                                     'value' => 'Imaging report reference'
                                                                                   }
                                                                       }
                                                                     ],
                                                          'name' => {
                                                                      'value' => 'Examination request details',
                                                                      '@class' => 'DV_TEXT'
                                                                    }
                                                        }
                                                      ],
                                           'archetype_node_id' => 'at0025',
                                           'name' => {
                                                       'value' => 'Tree',
                                                       '@class' => 'DV_TEXT'
                                                     }
                                         },
                           'archetype_details' => {
                                                    'rm_version' => '1.0.2',
                                                    '@class' => 'ARCHETYPED',
                                                    'archetype_id' => {
                                                                        'value' => 'openEHR-EHR-OBSERVATION.imaging_exam.v0',
                                                                        '@class' => 'ARCHETYPE_ID'
                                                                      }
                                                  },
                           'data' => {
                                       'events' => [
                                                     {
                                                       'time' => {
                                                                   '@class' => 'DV_DATE_TIME',
                                                                   'value' => '2017-09-25T09:02:38Z'
                                                                 },
                                                       '@class' => 'POINT_EVENT',
                                                       'archetype_node_id' => 'at0002',
                                                       'data' => {
                                                                   'name' => {
                                                                               '@class' => 'DV_TEXT',
                                                                               'value' => 'Tree'
                                                                             },
                                                                   '@class' => 'ITEM_TREE',
                                                                   'items' => [
                                                                                {
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'mappings' => [
                                                                                                               {
                                                                                                                 'target' => {
                                                                                                                               'terminology_id' => {
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                     'value' => 'NICIP'
                                                                                                                                                   },
                                                                                                                               'code_string' => 'U34',
                                                                                                                               '@class' => 'CODE_PHRASE'
                                                                                                                             },
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'match' => '='
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               'code_string' => '45036003',
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                     'value' => 'SNOMED-CT-CODE'
                                                                                                                                                   }
                                                                                                                             }
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 'target' => {
                                                                                                                               'code_string' => 'Ultrasonography of abdomen (procedure)',
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'SNOMED-CT-DESCRIPTION',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   }
                                                                                                                             },
                                                                                                                 '@class' => 'TERM_MAPPING'
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'code_string' => 'U08.2',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'OPCS-4-PRIMARY',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   }
                                                                                                                             }
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 'target' => {
                                                                                                                               'code_string' => 'Y98.1',
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'OPCS-4-METHOD',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   }
                                                                                                                             },
                                                                                                                 '@class' => 'TERM_MAPPING'
                                                                                                               }
                                                                                                             ],
                                                                                               'value' => 'UABDO',
                                                                                               'defining_code' => {
                                                                                                                    'terminology_id' => {
                                                                                                                                          'value' => 'NICIP',
                                                                                                                                          '@class' => 'TERMINOLOGY_ID'
                                                                                                                                        },
                                                                                                                    '@class' => 'CODE_PHRASE',
                                                                                                                    'code_string' => 'UABDO'
                                                                                                                  }
                                                                                             },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0004',
                                                                                  'name' => {
                                                                                              'value' => 'Imaging code',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'value' => {
                                                                                               'value' => 'Ultrasound',
                                                                                               '@class' => 'DV_TEXT'
                                                                                             },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0005',
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Modality'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'archetype_details' => {
                                                                                                           'rm_version' => '1.0.2',
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'archetype_id' => {
                                                                                                                               '@class' => 'ARCHETYPE_ID',
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.anatomical_location.v1'
                                                                                                                             }
                                                                                                         },
                                                                                  'items' => [
                                                                                               {
                                                                                                 '@class' => 'ELEMENT',
                                                                                                 'archetype_node_id' => 'at0001',
                                                                                                 'value' => {
                                                                                                              'defining_code' => {
                                                                                                                                   'terminology_id' => {
                                                                                                                                                         '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                         'value' => 'GEL-REGION'
                                                                                                                                                       },
                                                                                                                                   'code_string' => 'Abdominal',
                                                                                                                                   '@class' => 'CODE_PHRASE'
                                                                                                                                 },
                                                                                                              '@class' => 'DV_CODED_TEXT',
                                                                                                              'mappings' => [
                                                                                                                              {
                                                                                                                                'target' => {
                                                                                                                                              '@class' => 'CODE_PHRASE',
                                                                                                                                              'code_string' => 'Z92.6',
                                                                                                                                              'terminology_id' => {
                                                                                                                                                                    'value' => 'OPCS-4-SITE',
                                                                                                                                                                    '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                                  }
                                                                                                                                            },
                                                                                                                                '@class' => 'TERM_MAPPING',
                                                                                                                                'match' => '='
                                                                                                                              }
                                                                                                                            ],
                                                                                                              'value' => 'Abdominal'
                                                                                                            },
                                                                                                 'name' => {
                                                                                                             'value' => 'Anatomical site',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           }
                                                                                               }
                                                                                             ],
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.anatomical_location.v1',
                                                                                  '@class' => 'CLUSTER',
                                                                                  'name' => {
                                                                                              'value' => 'Anatomical location',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'archetype_details' => {
                                                                                                           'archetype_id' => {
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.anatomical_side_gel.v0',
                                                                                                                               '@class' => 'ARCHETYPE_ID'
                                                                                                                             },
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'rm_version' => '1.0.2'
                                                                                                         },
                                                                                  'items' => [
                                                                                               {
                                                                                                 'name' => {
                                                                                                             'value' => 'Anatomical side',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           },
                                                                                                 '@class' => 'ELEMENT',
                                                                                                 'archetype_node_id' => 'at0001',
                                                                                                 'value' => {
                                                                                                              'defining_code' => {
                                                                                                                                   'terminology_id' => {
                                                                                                                                                         'value' => 'local',
                                                                                                                                                         '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                       },
                                                                                                                                   'code_string' => 'at0006',
                                                                                                                                   '@class' => 'CODE_PHRASE'
                                                                                                                                 },
                                                                                                              '@class' => 'DV_CODED_TEXT',
                                                                                                              'value' => 'N/A'
                                                                                                            }
                                                                                               }
                                                                                             ],
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.anatomical_side_gel.v0',
                                                                                  '@class' => 'CLUSTER',
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Anatomical side'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Overall result status'
                                                                                            },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0007',
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'value' => 'F',
                                                                                               'defining_code' => {
                                                                                                                    'code_string' => 'at0011',
                                                                                                                    '@class' => 'CODE_PHRASE',
                                                                                                                    'terminology_id' => {
                                                                                                                                          'value' => 'local',
                                                                                                                                          '@class' => 'TERMINOLOGY_ID'
                                                                                                                                        }
                                                                                                                  }
                                                                                             }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              'value' => 'DateTime result issued',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'value' => {
                                                                                               'value' => '2017-09-25T09:02:38Z',
                                                                                               '@class' => 'DV_DATE_TIME'
                                                                                             },
                                                                                  'archetype_node_id' => 'at0024',
                                                                                  '@class' => 'ELEMENT'
                                                                                },
                                                                                {
                                                                                  'value' => {
                                                                                               'value' => ' 7034346 25/09/2017 Ultrasound (US) Abdomen


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

 
',
                                                                                               '@class' => 'DV_TEXT'
                                                                                             },
                                                                                  'archetype_node_id' => 'at0021',
                                                                                  '@class' => 'ELEMENT',
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Imaging report text'
                                                                                            }
                                                                                }
                                                                              ],
                                                                   'archetype_node_id' => 'at0003'
                                                                 },
                                                       'name' => {
                                                                   '@class' => 'DV_TEXT',
                                                                   'value' => 'Any event'
                                                                 }
                                                     }
                                                   ],
                                       'name' => {
                                                   'value' => 'Event Series',
                                                   '@class' => 'DV_TEXT'
                                                 },
                                       'origin' => {
                                                     '@class' => 'DV_DATE_TIME',
                                                     'value' => '2017-09-25T09:02:38Z'
                                                   },
                                       '@class' => 'HISTORY',
                                       'archetype_node_id' => 'at0001'
                                     },
                           'name' => {
                                       'value' => 'Imaging examination result',
                                       '@class' => 'DV_TEXT'
                                     }
                         },
                         {
                           'language' => {
                                           'terminology_id' => {
                                                                 'value' => 'ISO_639-1',
                                                                 '@class' => 'TERMINOLOGY_ID'
                                                               },
                                           'code_string' => 'en',
                                           '@class' => 'CODE_PHRASE'
                                         },
                           'archetype_node_id' => 'openEHR-EHR-OBSERVATION.imaging_exam.v0',
                           '@class' => 'OBSERVATION',
                           'name' => {
                                       '@class' => 'DV_TEXT',
                                       'value' => 'Imaging examination result #2'
                                     },
                           'data' => {
                                       'archetype_node_id' => 'at0001',
                                       '@class' => 'HISTORY',
                                       'origin' => {
                                                     'value' => '2017-09-25T09:02:38Z',
                                                     '@class' => 'DV_DATE_TIME'
                                                   },
                                       'name' => {
                                                   'value' => 'Event Series',
                                                   '@class' => 'DV_TEXT'
                                                 },
                                       'events' => [
                                                     {
                                                       'time' => {
                                                                   '@class' => 'DV_DATE_TIME',
                                                                   'value' => '2017-09-25T09:02:38Z'
                                                                 },
                                                       'archetype_node_id' => 'at0002',
                                                       '@class' => 'POINT_EVENT',
                                                       'name' => {
                                                                   'value' => 'Any event',
                                                                   '@class' => 'DV_TEXT'
                                                                 },
                                                       'data' => {
                                                                   'items' => [
                                                                                {
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'mappings' => [
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'NICIP',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   },
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'code_string' => 'U44'
                                                                                                                             }
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               'code_string' => '45036003',
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'SNOMED-CT-CODE',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   }
                                                                                                                             }
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               '@class' => 'CODE_PHRASE',
                                                                                                                               'code_string' => 'Ultrasonography of abdomen (procedure)',
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'SNOMED-CT-DESCRIPTION',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   }
                                                                                                                             }
                                                                                                               },
                                                                                                               {
                                                                                                                 'match' => '=',
                                                                                                                 'target' => {
                                                                                                                               'terminology_id' => {
                                                                                                                                                     'value' => 'OPCS-4-PRIMARY',
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                   },
                                                                                                                               'code_string' => 'U08.2',
                                                                                                                               '@class' => 'CODE_PHRASE'
                                                                                                                             },
                                                                                                                 '@class' => 'TERM_MAPPING'
                                                                                                               },
                                                                                                               {
                                                                                                                 '@class' => 'TERM_MAPPING',
                                                                                                                 'target' => {
                                                                                                                               'terminology_id' => {
                                                                                                                                                     '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                     'value' => 'OPCS-4-METHOD'
                                                                                                                                                   },
                                                                                                                               'code_string' => 'Y98.1',
                                                                                                                               '@class' => 'CODE_PHRASE'
                                                                                                                             },
                                                                                                                 'match' => '='
                                                                                                               }
                                                                                                             ],
                                                                                               'value' => 'UABDO',
                                                                                               'defining_code' => {
                                                                                                                    'code_string' => 'UABDO',
                                                                                                                    '@class' => 'CODE_PHRASE',
                                                                                                                    'terminology_id' => {
                                                                                                                                          'value' => 'NICIP',
                                                                                                                                          '@class' => 'TERMINOLOGY_ID'
                                                                                                                                        }
                                                                                                                  }
                                                                                             },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0004',
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Imaging code'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              'value' => 'Modality',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'value' => {
                                                                                               '@class' => 'DV_TEXT',
                                                                                               'value' => 'Ultrasound'
                                                                                             },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0005'
                                                                                },
                                                                                {
                                                                                  'archetype_details' => {
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'archetype_id' => {
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.anatomical_location.v1',
                                                                                                                               '@class' => 'ARCHETYPE_ID'
                                                                                                                             },
                                                                                                           'rm_version' => '1.0.2'
                                                                                                         },
                                                                                  'items' => [
                                                                                               {
                                                                                                 'name' => {
                                                                                                             '@class' => 'DV_TEXT',
                                                                                                             'value' => 'Anatomical site'
                                                                                                           },
                                                                                                 'value' => {
                                                                                                              'value' => 'Abdominal',
                                                                                                              'mappings' => [
                                                                                                                              {
                                                                                                                                'target' => {
                                                                                                                                              'code_string' => 'Z92.6',
                                                                                                                                              '@class' => 'CODE_PHRASE',
                                                                                                                                              'terminology_id' => {
                                                                                                                                                                    'value' => 'OPCS-4-SITE',
                                                                                                                                                                    '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                                  }
                                                                                                                                            },
                                                                                                                                '@class' => 'TERM_MAPPING',
                                                                                                                                'match' => '='
                                                                                                                              }
                                                                                                                            ],
                                                                                                              '@class' => 'DV_CODED_TEXT',
                                                                                                              'defining_code' => {
                                                                                                                                   '@class' => 'CODE_PHRASE',
                                                                                                                                   'code_string' => 'Abdominal',
                                                                                                                                   'terminology_id' => {
                                                                                                                                                         'value' => 'GEL-REGION',
                                                                                                                                                         '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                       }
                                                                                                                                 }
                                                                                                            },
                                                                                                 'archetype_node_id' => 'at0001',
                                                                                                 '@class' => 'ELEMENT'
                                                                                               }
                                                                                             ],
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.anatomical_location.v1',
                                                                                  '@class' => 'CLUSTER',
                                                                                  'name' => {
                                                                                              'value' => 'Anatomical location',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'archetype_details' => {
                                                                                                           'archetype_id' => {
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.anatomical_side_gel.v0',
                                                                                                                               '@class' => 'ARCHETYPE_ID'
                                                                                                                             },
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'rm_version' => '1.0.2'
                                                                                                         },
                                                                                  'items' => [
                                                                                               {
                                                                                                 'value' => {
                                                                                                              'defining_code' => {
                                                                                                                                   'code_string' => 'at0006',
                                                                                                                                   '@class' => 'CODE_PHRASE',
                                                                                                                                   'terminology_id' => {
                                                                                                                                                         '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                         'value' => 'local'
                                                                                                                                                       }
                                                                                                                                 },
                                                                                                              '@class' => 'DV_CODED_TEXT',
                                                                                                              'value' => 'N/A'
                                                                                                            },
                                                                                                 '@class' => 'ELEMENT',
                                                                                                 'archetype_node_id' => 'at0001',
                                                                                                 'name' => {
                                                                                                             'value' => 'Anatomical side',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           }
                                                                                               }
                                                                                             ],
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.anatomical_side_gel.v0',
                                                                                  '@class' => 'CLUSTER',
                                                                                  'name' => {
                                                                                              'value' => 'Anatomical side',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              'value' => 'Overall result status',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  '@class' => 'ELEMENT',
                                                                                  'archetype_node_id' => 'at0007',
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'value' => 'F',
                                                                                               'defining_code' => {
                                                                                                                    'terminology_id' => {
                                                                                                                                          'value' => 'local',
                                                                                                                                          '@class' => 'TERMINOLOGY_ID'
                                                                                                                                        },
                                                                                                                    'code_string' => 'at0011',
                                                                                                                    '@class' => 'CODE_PHRASE'
                                                                                                                  }
                                                                                             }
                                                                                },
                                                                                {
                                                                                  'value' => {
                                                                                               '@class' => 'DV_DATE_TIME',
                                                                                               'value' => '2017-09-25T09:02:38Z'
                                                                                             },
                                                                                  'archetype_node_id' => 'at0024',
                                                                                  '@class' => 'ELEMENT',
                                                                                  'name' => {
                                                                                              'value' => 'DateTime result issued',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              'value' => 'Imaging report text',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'value' => {
                                                                                               'value' => ' 7034346 25/09/2017 Ultrasound (US) Abdomen


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

 
',
                                                                                               '@class' => 'DV_TEXT'
                                                                                             },
                                                                                  'archetype_node_id' => 'at0021',
                                                                                  '@class' => 'ELEMENT'
                                                                                }
                                                                              ],
                                                                   'archetype_node_id' => 'at0003',
                                                                   '@class' => 'ITEM_TREE',
                                                                   'name' => {
                                                                               'value' => 'Tree',
                                                                               '@class' => 'DV_TEXT'
                                                                             }
                                                                 }
                                                     }
                                                   ]
                                     },
                           'archetype_details' => {
                                                    'rm_version' => '1.0.2',
                                                    'archetype_id' => {
                                                                        'value' => 'openEHR-EHR-OBSERVATION.imaging_exam.v0',
                                                                        '@class' => 'ARCHETYPE_ID'
                                                                      },
                                                    '@class' => 'ARCHETYPED'
                                                  },
                           'subject' => {
                                          '@class' => 'PARTY_SELF'
                                        },
                           'protocol' => {
                                           '@class' => 'ITEM_TREE',
                                           'archetype_node_id' => 'at0025',
                                           'items' => [
                                                        {
                                                          'name' => {
                                                                      '@class' => 'DV_TEXT',
                                                                      'value' => 'Examination request details'
                                                                    },
                                                          'items' => [
                                                                       {
                                                                         'name' => {
                                                                                     '@class' => 'DV_TEXT',
                                                                                     'value' => 'Examination requested name'
                                                                                   },
                                                                         'value' => {
                                                                                      'value' => 'Ultrasound (US) Liver',
                                                                                      '@class' => 'DV_TEXT'
                                                                                    },
                                                                         'archetype_node_id' => 'at0029',
                                                                         '@class' => 'ELEMENT'
                                                                       },
                                                                       {
                                                                         'archetype_node_id' => 'at0033',
                                                                         '@class' => 'ELEMENT',
                                                                         'value' => {
                                                                                      '@class' => 'DV_IDENTIFIER',
                                                                                      'type' => 'local',
                                                                                      'id' => '52874656',
                                                                                      'assigner' => 'UCLH RIS',
                                                                                      'issuer' => 'UCLH'
                                                                                    },
                                                                         'name' => {
                                                                                     'value' => 'Imaging report reference',
                                                                                     '@class' => 'DV_TEXT'
                                                                                   }
                                                                       }
                                                                     ],
                                                          'archetype_node_id' => 'at0027',
                                                          '@class' => 'CLUSTER'
                                                        }
                                                      ],
                                           'name' => {
                                                       'value' => 'Tree',
                                                       '@class' => 'DV_TEXT'
                                                     }
                                         },
                           'encoding' => {
                                           '@class' => 'CODE_PHRASE',
                                           'code_string' => 'UTF-8',
                                           'terminology_id' => {
                                                                 '@class' => 'TERMINOLOGY_ID',
                                                                 'value' => 'IANA_character-sets'
                                                               }
                                         }
                         }
                       ],
          'composer' => {
                          '@class' => 'PARTY_IDENTIFIED',
                          'name' => 'OpenEHR-Perl-FLAT'
                        },
          'archetype_details' => {
                                   'archetype_id' => {
                                                       '@class' => 'ARCHETYPE_ID',
                                                       'value' => 'openEHR-EHR-COMPOSITION.report.v1'
                                                     },
                                   '@class' => 'ARCHETYPED',
                                   'rm_version' => '1.0.2',
                                   'template_id' => {
                                                      '@class' => 'TEMPLATE_ID',
                                                      'value' => 'GEL Generic radiology report import.v0'
                                                    }
                                 },
          'category' => {
                          'defining_code' => {
                                               'terminology_id' => {
                                                                     'value' => 'openehr',
                                                                     '@class' => 'TERMINOLOGY_ID'
                                                                   },
                                               'code_string' => '433',
                                               '@class' => 'CODE_PHRASE'
                                             },
                          'value' => 'event',
                          '@class' => 'DV_CODED_TEXT'
                        },
          'territory' => {
                           'terminology_id' => {
                                                 '@class' => 'TERMINOLOGY_ID',
                                                 'value' => 'ISO_3166-1'
                                               },
                           '@class' => 'CODE_PHRASE',
                           'code_string' => 'GB'
                         },
          'context' => {
                         'other_context' => {
                                              'archetype_node_id' => 'at0001',
                                              'items' => [
                                                           {
                                                             'value' => {
                                                                          '@class' => 'DV_TEXT',
                                                                          'value' => '7034346'
                                                                        },
                                                             '@class' => 'ELEMENT',
                                                             'archetype_node_id' => 'at0002',
                                                             'name' => {
                                                                         'value' => 'Report ID',
                                                                         '@class' => 'DV_TEXT'
                                                                       }
                                                           }
                                                         ],
                                              '@class' => 'ITEM_TREE',
                                              'name' => {
                                                          'value' => 'Tree',
                                                          '@class' => 'DV_TEXT'
                                                        }
                                            },
                         '@class' => 'EVENT_CONTEXT',
                         'health_care_facility' => {
                                                     'external_ref' => {
                                                                         'namespace' => 'UCLH-NS',
                                                                         '@class' => 'PARTY_REF',
                                                                         'type' => 'PARTY',
                                                                         'id' => {
                                                                                   'scheme' => 'UCLH-NS',
                                                                                   '@class' => 'GENERIC_ID',
                                                                                   'value' => 'RRV'
                                                                                 }
                                                                       },
                                                     'name' => 'UCLH NHS Foundation Trust',
                                                     '@class' => 'PARTY_IDENTIFIED'
                                                   },
                         'start_time' => {
                                           'value' => '2017-09-25T09:02:38Z',
                                           '@class' => 'DV_DATE_TIME'
                                         },
                         'setting' => {
                                        'defining_code' => {
                                                             '@class' => 'CODE_PHRASE',
                                                             'code_string' => '238',
                                                             'terminology_id' => {
                                                                                   'value' => 'openehr',
                                                                                   '@class' => 'TERMINOLOGY_ID'
                                                                                 }
                                                           },
                                        'value' => 'other care',
                                        '@class' => 'DV_CODED_TEXT'
                                      }
                       },
          '@class' => 'COMPOSITION',
          'uid' => {
                     '@class' => 'OBJECT_VERSION_ID',
                     'value' => '6482d43d-bcc7-45a3-b078-9e33c9d88907::default::1'
                   },
          'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
          'language' => {
                          'terminology_id' => {
                                                '@class' => 'TERMINOLOGY_ID',
                                                'value' => 'ISO_639-1'
                                              },
                          'code_string' => 'en',
                          '@class' => 'CODE_PHRASE'
                        }
        };
