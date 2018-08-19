210c711a-76c7-412e-9da5-dfc6358c5876::default::1
$VAR1 = {
          'composer' => {
                          '@class' => 'PARTY_IDENTIFIED',
                          'name' => 'Aupen Ayre'
                        },
          'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report-result.v1',
          'territory' => {
                           'terminology_id' => {
                                                 '@class' => 'TERMINOLOGY_ID',
                                                 'value' => 'ISO_3166-1'
                                               },
                           '@class' => 'CODE_PHRASE',
                           'code_string' => 'GB'
                         },
          'context' => {
                         'setting' => {
                                        'defining_code' => {
                                                             '@class' => 'CODE_PHRASE',
                                                             'code_string' => '238',
                                                             'terminology_id' => {
                                                                                   '@class' => 'TERMINOLOGY_ID',
                                                                                   'value' => 'openehr'
                                                                                 }
                                                           },
                                        'value' => 'other care',
                                        '@class' => 'DV_CODED_TEXT'
                                      },
                         'other_context' => {
                                              'archetype_node_id' => 'at0001',
                                              'name' => {
                                                          '@class' => 'DV_TEXT',
                                                          'value' => 'Tree'
                                                        },
                                              'items' => [
                                                           {
                                                             '@class' => 'ELEMENT',
                                                             'name' => {
                                                                         '@class' => 'DV_TEXT',
                                                                         'value' => 'Report ID'
                                                                       },
                                                             'archetype_node_id' => 'at0002',
                                                             'value' => {
                                                                          'value' => '17V999333',
                                                                          '@class' => 'DV_TEXT'
                                                                        }
                                                           }
                                                         ],
                                              '@class' => 'ITEM_TREE'
                                            },
                         'start_time' => {
                                           '@class' => 'DV_DATE_TIME',
                                           'value' => '2018-08-19T09:44:08+01:00'
                                         },
                         'health_care_facility' => {
                                                     'name' => 'UCLH',
                                                     'external_ref' => {
                                                                         '@class' => 'PARTY_REF',
                                                                         'namespace' => 'UCLH-NS',
                                                                         'type' => 'PARTY',
                                                                         'id' => {
                                                                                   '@class' => 'GENERIC_ID',
                                                                                   'scheme' => 'UCLH-NS',
                                                                                   'value' => 'RRV'
                                                                                 }
                                                                       },
                                                     '@class' => 'PARTY_IDENTIFIED'
                                                   },
                         '@class' => 'EVENT_CONTEXT'
                       },
          'archetype_details' => {
                                   'template_id' => {
                                                      'value' => 'GEL - Generic Lab Report import.v0',
                                                      '@class' => 'TEMPLATE_ID'
                                                    },
                                   'archetype_id' => {
                                                       'value' => 'openEHR-EHR-COMPOSITION.report-result.v1',
                                                       '@class' => 'ARCHETYPE_ID'
                                                     },
                                   '@class' => 'ARCHETYPED',
                                   'rm_version' => '1.0.1'
                                 },
          '@class' => 'COMPOSITION',
          'uid' => {
                     '@class' => 'OBJECT_VERSION_ID',
                     'value' => '210c711a-76c7-412e-9da5-dfc6358c5876::default::1'
                   },
          'name' => {
                      'value' => 'Laboratory Result Report',
                      '@class' => 'DV_TEXT'
                    },
          'category' => {
                          '@class' => 'DV_CODED_TEXT',
                          'value' => 'event',
                          'defining_code' => {
                                               'code_string' => '433',
                                               '@class' => 'CODE_PHRASE',
                                               'terminology_id' => {
                                                                     '@class' => 'TERMINOLOGY_ID',
                                                                     'value' => 'openehr'
                                                                   }
                                             }
                        },
          'language' => {
                          'terminology_id' => {
                                                'value' => 'ISO_639-1',
                                                '@class' => 'TERMINOLOGY_ID'
                                              },
                          'code_string' => 'en',
                          '@class' => 'CODE_PHRASE'
                        },
          'content' => [
                         {
                           'name' => {
                                       '@class' => 'DV_TEXT',
                                       'value' => 'Laboratory test'
                                     },
                           'data' => {
                                       'origin' => {
                                                     '@class' => 'DV_DATE_TIME',
                                                     'value' => '2018-08-19T09:44:08+01:00'
                                                   },
                                       'archetype_node_id' => 'at0001',
                                       'name' => {
                                                   'value' => 'Event Series',
                                                   '@class' => 'DV_TEXT'
                                                 },
                                       '@class' => 'HISTORY',
                                       'events' => [
                                                     {
                                                       'time' => {
                                                                   '@class' => 'DV_DATE_TIME',
                                                                   'value' => '2018-08-19T09:44:08+01:00'
                                                                 },
                                                       '@class' => 'POINT_EVENT',
                                                       'data' => {
                                                                   '@class' => 'ITEM_TREE',
                                                                   'items' => [
                                                                                {
                                                                                  '@class' => 'ELEMENT',
                                                                                  'name' => {
                                                                                              'value' => 'Requested Test',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'archetype_node_id' => 'at0005',
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'defining_code' => {
                                                                                                                    'terminology_id' => {
                                                                                                                                          'value' => 'local',
                                                                                                                                          '@class' => 'TERMINOLOGY_ID'
                                                                                                                                        },
                                                                                                                    'code_string' => 'ELL',
                                                                                                                    '@class' => 'CODE_PHRASE'
                                                                                                                  },
                                                                                               'value' => 'Electrolytes'
                                                                                             }
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Specimen'
                                                                                            },
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.specimen.v0',
                                                                                  'items' => [
                                                                                               {
                                                                                                 'value' => {
                                                                                                              'value' => 'Blood',
                                                                                                              '@class' => 'DV_TEXT'
                                                                                                            },
                                                                                                 'archetype_node_id' => 'at0029',
                                                                                                 'name' => {
                                                                                                             '@class' => 'DV_TEXT',
                                                                                                             'value' => 'Specimen type'
                                                                                                           },
                                                                                                 '@class' => 'ELEMENT'
                                                                                               },
                                                                                               {
                                                                                                 'archetype_node_id' => 'at0015',
                                                                                                 'name' => {
                                                                                                             'value' => 'Datetime collected',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           },
                                                                                                 'value' => {
                                                                                                              'value' => '2017-11-20T14:31:00Z',
                                                                                                              '@class' => 'DV_DATE_TIME'
                                                                                                            },
                                                                                                 '@class' => 'ELEMENT'
                                                                                               },
                                                                                               {
                                                                                                 'value' => {
                                                                                                              'value' => 'Phlebotomy',
                                                                                                              '@class' => 'DV_TEXT'
                                                                                                            },
                                                                                                 'archetype_node_id' => 'at0007',
                                                                                                 'name' => {
                                                                                                             '@class' => 'DV_TEXT',
                                                                                                             'value' => 'Collection method'
                                                                                                           },
                                                                                                 '@class' => 'ELEMENT'
                                                                                               },
                                                                                               {
                                                                                                 '@class' => 'CLUSTER',
                                                                                                 'items' => [
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Datetime received',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0034',
                                                                                                                'value' => {
                                                                                                                             'value' => '2017-11-20T15:21:00Z',
                                                                                                                             '@class' => 'DV_DATE_TIME'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Laboratory specimen identifier',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0001',
                                                                                                                'value' => {
                                                                                                                             'type' => 'local',
                                                                                                                             'id' => 'bld',
                                                                                                                             'assigner' => 'Winpath',
                                                                                                                             'issuer' => 'UCLH Pathology',
                                                                                                                             '@class' => 'DV_IDENTIFIER'
                                                                                                                           }
                                                                                                              }
                                                                                                            ],
                                                                                                 'archetype_node_id' => 'at0046',
                                                                                                 'name' => {
                                                                                                             'value' => 'Processing',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           }
                                                                                               }
                                                                                             ],
                                                                                  '@class' => 'CLUSTER',
                                                                                  'archetype_details' => {
                                                                                                           'archetype_id' => {
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.specimen.v0',
                                                                                                                               '@class' => 'ARCHETYPE_ID'
                                                                                                                             },
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'rm_version' => '1.0.1'
                                                                                                         }
                                                                                },
                                                                                {
                                                                                  'value' => {
                                                                                               '@class' => 'DV_CODED_TEXT',
                                                                                               'value' => 'Final',
                                                                                               'defining_code' => {
                                                                                                                    'code_string' => 'at0038',
                                                                                                                    '@class' => 'CODE_PHRASE',
                                                                                                                    'terminology_id' => {
                                                                                                                                          '@class' => 'TERMINOLOGY_ID',
                                                                                                                                          'value' => 'local'
                                                                                                                                        }
                                                                                                                  }
                                                                                             },
                                                                                  'name' => {
                                                                                              'value' => 'Test status',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'archetype_node_id' => 'at0073',
                                                                                  '@class' => 'ELEMENT'
                                                                                },
                                                                                {
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Test status timestamp'
                                                                                            },
                                                                                  'archetype_node_id' => 'at0075',
                                                                                  'value' => {
                                                                                               '@class' => 'DV_DATE_TIME',
                                                                                               'value' => '2017-11-10T14:12:00Z'
                                                                                             },
                                                                                  '@class' => 'ELEMENT'
                                                                                },
                                                                                {
                                                                                  'value' => {
                                                                                               '@class' => 'DV_TEXT',
                                                                                               'value' => 'Feeling unwell'
                                                                                             },
                                                                                  'archetype_node_id' => 'at0100',
                                                                                  'name' => {
                                                                                              '@class' => 'DV_TEXT',
                                                                                              'value' => 'Clinical information provided'
                                                                                            },
                                                                                  '@class' => 'ELEMENT'
                                                                                },
                                                                                {
                                                                                  'archetype_node_id' => 'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                                                                  'name' => {
                                                                                              'value' => 'Laboratory test panel',
                                                                                              '@class' => 'DV_TEXT'
                                                                                            },
                                                                                  'archetype_details' => {
                                                                                                           'rm_version' => '1.0.1',
                                                                                                           '@class' => 'ARCHETYPED',
                                                                                                           'archetype_id' => {
                                                                                                                               'value' => 'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
                                                                                                                               '@class' => 'ARCHETYPE_ID'
                                                                                                                             }
                                                                                                         },
                                                                                  'items' => [
                                                                                               {
                                                                                                 'archetype_node_id' => 'at0002',
                                                                                                 'name' => {
                                                                                                             'value' => 'Laboratory result',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           },
                                                                                                 '@class' => 'CLUSTER',
                                                                                                 'items' => [
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'name' => {
                                                                                                                            '@class' => 'DV_CODED_TEXT',
                                                                                                                            'defining_code' => {
                                                                                                                                                 '@class' => 'CODE_PHRASE',
                                                                                                                                                 'code_string' => 'NA',
                                                                                                                                                 'terminology_id' => {
                                                                                                                                                                       'value' => 'Local',
                                                                                                                                                                       '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                                     }
                                                                                                                                               },
                                                                                                                            'value' => 'Sodium'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0001',
                                                                                                                'value' => {
                                                                                                                             'magnitude' => '59',
                                                                                                                             '@class' => 'DV_QUANTITY',
                                                                                                                             'magnitude_status' => '<',
                                                                                                                             'units' => 'mmol/l'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Comment',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0003',
                                                                                                                'value' => {
                                                                                                                             'value' => 'this is the sodium result',
                                                                                                                             '@class' => 'DV_TEXT'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'archetype_node_id' => 'at0004',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Reference range guidance',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'value' => {
                                                                                                                             'value' => '50-60',
                                                                                                                             '@class' => 'DV_TEXT'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                'value' => {
                                                                                                                             'defining_code' => {
                                                                                                                                                  'terminology_id' => {
                                                                                                                                                                        'value' => 'local',
                                                                                                                                                                        '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                                      },
                                                                                                                                                  'code_string' => 'at0009',
                                                                                                                                                  '@class' => 'CODE_PHRASE'
                                                                                                                                                },
                                                                                                                             'value' => 'Final',
                                                                                                                             '@class' => 'DV_CODED_TEXT'
                                                                                                                           },
                                                                                                                'name' => {
                                                                                                                            'value' => 'Result status',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0005',
                                                                                                                '@class' => 'ELEMENT'
                                                                                                              }
                                                                                                            ]
                                                                                               },
                                                                                               {
                                                                                                 '@class' => 'CLUSTER',
                                                                                                 'items' => [
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'archetype_node_id' => 'at0001',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Potassium',
                                                                                                                            'defining_code' => {
                                                                                                                                                 'code_string' => 'K',
                                                                                                                                                 '@class' => 'CODE_PHRASE',
                                                                                                                                                 'terminology_id' => {
                                                                                                                                                                       '@class' => 'TERMINOLOGY_ID',
                                                                                                                                                                       'value' => 'Local'
                                                                                                                                                                     }
                                                                                                                                               },
                                                                                                                            '@class' => 'DV_CODED_TEXT'
                                                                                                                          },
                                                                                                                'value' => {
                                                                                                                             'units' => 'g/dl',
                                                                                                                             'magnitude' => '88',
                                                                                                                             '@class' => 'DV_QUANTITY'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'name' => {
                                                                                                                            'value' => 'Comment',
                                                                                                                            '@class' => 'DV_TEXT'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0003',
                                                                                                                'value' => {
                                                                                                                             '@class' => 'DV_TEXT',
                                                                                                                             'value' => 'this is the potassium result'
                                                                                                                           }
                                                                                                              },
                                                                                                              {
                                                                                                                '@class' => 'ELEMENT',
                                                                                                                'value' => {
                                                                                                                             '@class' => 'DV_TEXT',
                                                                                                                             'value' => '80-90'
                                                                                                                           },
                                                                                                                'name' => {
                                                                                                                            '@class' => 'DV_TEXT',
                                                                                                                            'value' => 'Reference range guidance'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0004'
                                                                                                              },
                                                                                                              {
                                                                                                                'name' => {
                                                                                                                            '@class' => 'DV_TEXT',
                                                                                                                            'value' => 'Result status'
                                                                                                                          },
                                                                                                                'archetype_node_id' => 'at0005',
                                                                                                                'value' => {
                                                                                                                             '@class' => 'DV_CODED_TEXT',
                                                                                                                             'value' => 'Final',
                                                                                                                             'defining_code' => {
                                                                                                                                                  'terminology_id' => {
                                                                                                                                                                        'value' => 'local',
                                                                                                                                                                        '@class' => 'TERMINOLOGY_ID'
                                                                                                                                                                      },
                                                                                                                                                  'code_string' => 'at0009',
                                                                                                                                                  '@class' => 'CODE_PHRASE'
                                                                                                                                                }
                                                                                                                           },
                                                                                                                '@class' => 'ELEMENT'
                                                                                                              }
                                                                                                            ],
                                                                                                 'archetype_node_id' => 'at0002',
                                                                                                 'name' => {
                                                                                                             'value' => 'Laboratory result #2',
                                                                                                             '@class' => 'DV_TEXT'
                                                                                                           }
                                                                                               }
                                                                                             ],
                                                                                  '@class' => 'CLUSTER'
                                                                                }
                                                                              ],
                                                                   'name' => {
                                                                               '@class' => 'DV_TEXT',
                                                                               'value' => 'Tree'
                                                                             },
                                                                   'archetype_node_id' => 'at0003'
                                                                 },
                                                       'name' => {
                                                                   'value' => 'Any event',
                                                                   '@class' => 'DV_TEXT'
                                                                 },
                                                       'archetype_node_id' => 'at0002'
                                                     }
                                                   ]
                                     },
                           'language' => {
                                           'terminology_id' => {
                                                                 'value' => 'ISO_639-1',
                                                                 '@class' => 'TERMINOLOGY_ID'
                                                               },
                                           'code_string' => 'en',
                                           '@class' => 'CODE_PHRASE'
                                         },
                           'subject' => {
                                          '@class' => 'PARTY_SELF'
                                        },
                           'encoding' => {
                                           'terminology_id' => {
                                                                 '@class' => 'TERMINOLOGY_ID',
                                                                 'value' => 'IANA_character-sets'
                                                               },
                                           '@class' => 'CODE_PHRASE',
                                           'code_string' => 'UTF-8'
                                         },
                           'protocol' => {
                                           'name' => {
                                                       '@class' => 'DV_TEXT',
                                                       'value' => 'Tree'
                                                     },
                                           'archetype_node_id' => 'at0004',
                                           'items' => [
                                                        {
                                                          'archetype_node_id' => 'openEHR-EHR-CLUSTER.organisation.v1',
                                                          'name' => {
                                                                      'value' => 'Responsible laboratory',
                                                                      '@class' => 'DV_TEXT'
                                                                    },
                                                          'archetype_details' => {
                                                                                   'rm_version' => '1.0.1',
                                                                                   'archetype_id' => {
                                                                                                       'value' => 'openEHR-EHR-CLUSTER.organisation.v1',
                                                                                                       '@class' => 'ARCHETYPE_ID'
                                                                                                     },
                                                                                   '@class' => 'ARCHETYPED'
                                                                                 },
                                                          '@class' => 'CLUSTER',
                                                          'items' => [
                                                                       {
                                                                         '@class' => 'ELEMENT',
                                                                         'archetype_node_id' => 'at0001',
                                                                         'name' => {
                                                                                     'value' => 'Name of Organisation',
                                                                                     '@class' => 'DV_TEXT'
                                                                                   },
                                                                         'value' => {
                                                                                      'value' => 'Clinical Biochemistry',
                                                                                      '@class' => 'DV_TEXT'
                                                                                    }
                                                                       }
                                                                     ]
                                                        },
                                                        {
                                                          '@class' => 'CLUSTER',
                                                          'items' => [
                                                                       {
                                                                         'value' => {
                                                                                      'type' => 'local',
                                                                                      'id' => 'TQ001113333',
                                                                                      'assigner' => 'TQuest',
                                                                                      '@class' => 'DV_IDENTIFIER',
                                                                                      'issuer' => 'UCLH'
                                                                                    },
                                                                         'name' => {
                                                                                     '@class' => 'DV_TEXT',
                                                                                     'value' => 'Placer order number'
                                                                                   },
                                                                         'archetype_node_id' => 'at0062',
                                                                         '@class' => 'ELEMENT'
                                                                       },
                                                                       {
                                                                         '@class' => 'ELEMENT',
                                                                         'value' => {
                                                                                      '@class' => 'DV_IDENTIFIER',
                                                                                      'issuer' => 'UCLH Pathology',
                                                                                      'assigner' => 'Winpath',
                                                                                      'type' => 'local',
                                                                                      'id' => '17V333999'
                                                                                    },
                                                                         'archetype_node_id' => 'at0063',
                                                                         'name' => {
                                                                                     '@class' => 'DV_TEXT',
                                                                                     'value' => 'Filler order number'
                                                                                   }
                                                                       },
                                                                       {
                                                                         'archetype_node_id' => 'openEHR-EHR-CLUSTER.individual_professional.v1',
                                                                         'name' => {
                                                                                     '@class' => 'DV_TEXT',
                                                                                     'value' => 'Requester'
                                                                                   },
                                                                         'archetype_details' => {
                                                                                                  'rm_version' => '1.0.1',
                                                                                                  '@class' => 'ARCHETYPED',
                                                                                                  'archetype_id' => {
                                                                                                                      '@class' => 'ARCHETYPE_ID',
                                                                                                                      'value' => 'openEHR-EHR-CLUSTER.individual_professional.v1'
                                                                                                                    }
                                                                                                },
                                                                         '@class' => 'CLUSTER',
                                                                         'items' => [
                                                                                      {
                                                                                        'archetype_details' => {
                                                                                                                 'archetype_id' => {
                                                                                                                                     'value' => 'openEHR-EHR-CLUSTER.person_name.v1',
                                                                                                                                     '@class' => 'ARCHETYPE_ID'
                                                                                                                                   },
                                                                                                                 '@class' => 'ARCHETYPED',
                                                                                                                 'rm_version' => '1.0.1'
                                                                                                               },
                                                                                        'items' => [
                                                                                                     {
                                                                                                       '@class' => 'CLUSTER',
                                                                                                       'items' => [
                                                                                                                    {
                                                                                                                      '@class' => 'ELEMENT',
                                                                                                                      'value' => {
                                                                                                                                   'value' => 'A&E',
                                                                                                                                   '@class' => 'DV_TEXT'
                                                                                                                                 },
                                                                                                                      'archetype_node_id' => 'at0003',
                                                                                                                      'name' => {
                                                                                                                                  'value' => 'Given name',
                                                                                                                                  '@class' => 'DV_TEXT'
                                                                                                                                }
                                                                                                                    },
                                                                                                                    {
                                                                                                                      'name' => {
                                                                                                                                  '@class' => 'DV_TEXT',
                                                                                                                                  'value' => 'Family name'
                                                                                                                                },
                                                                                                                      'archetype_node_id' => 'at0005',
                                                                                                                      'value' => {
                                                                                                                                   '@class' => 'DV_TEXT',
                                                                                                                                   'value' => 'UCLH'
                                                                                                                                 },
                                                                                                                      '@class' => 'ELEMENT'
                                                                                                                    }
                                                                                                                  ],
                                                                                                       'archetype_node_id' => 'at0002',
                                                                                                       'name' => {
                                                                                                                   'value' => 'Ordering provider',
                                                                                                                   '@class' => 'DV_TEXT'
                                                                                                                 }
                                                                                                     }
                                                                                                   ],
                                                                                        '@class' => 'CLUSTER',
                                                                                        'name' => {
                                                                                                    '@class' => 'DV_TEXT',
                                                                                                    'value' => 'Ordering provider'
                                                                                                  },
                                                                                        'archetype_node_id' => 'openEHR-EHR-CLUSTER.person_name.v1'
                                                                                      },
                                                                                      {
                                                                                        'name' => {
                                                                                                    'value' => 'Professional Identifier',
                                                                                                    '@class' => 'DV_TEXT'
                                                                                                  },
                                                                                        'archetype_node_id' => 'at0011',
                                                                                        'value' => {
                                                                                                     'issuer' => 'UCLH',
                                                                                                     '@class' => 'DV_IDENTIFIER',
                                                                                                     'type' => 'local',
                                                                                                     'id' => 'AB01',
                                                                                                     'assigner' => 'Carecast'
                                                                                                   },
                                                                                        '@class' => 'ELEMENT'
                                                                                      }
                                                                                    ]
                                                                       }
                                                                     ],
                                                          'archetype_node_id' => 'at0094',
                                                          'name' => {
                                                                      '@class' => 'DV_TEXT',
                                                                      'value' => 'Test request details'
                                                                    }
                                                        }
                                                      ],
                                           '@class' => 'ITEM_TREE'
                                         },
                           'archetype_node_id' => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                           'archetype_details' => {
                                                    'rm_version' => '1.0.1',
                                                    '@class' => 'ARCHETYPED',
                                                    'archetype_id' => {
                                                                        'value' => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                                                                        '@class' => 'ARCHETYPE_ID'
                                                                      }
                                                  },
                           '@class' => 'OBSERVATION'
                         },
                         {
                           'archetype_node_id' => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1',
                           '@class' => 'EVALUATION',
                           'archetype_details' => {
                                                    'rm_version' => '1.0.1',
                                                    '@class' => 'ARCHETYPED',
                                                    'archetype_id' => {
                                                                        '@class' => 'ARCHETYPE_ID',
                                                                        'value' => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1'
                                                                      }
                                                  },
                           'subject' => {
                                          '@class' => 'PARTY_SELF'
                                        },
                           'language' => {
                                           'terminology_id' => {
                                                                 '@class' => 'TERMINOLOGY_ID',
                                                                 'value' => 'ISO_639-1'
                                                               },
                                           '@class' => 'CODE_PHRASE',
                                           'code_string' => 'en'
                                         },
                           'data' => {
                                       'name' => {
                                                   '@class' => 'DV_TEXT',
                                                   'value' => 'List'
                                                 },
                                       'archetype_node_id' => 'at0001',
                                       'items' => [
                                                    {
                                                      '@class' => 'ELEMENT',
                                                      'archetype_node_id' => 'at0002',
                                                      'name' => {
                                                                  'value' => 'Comment',
                                                                  '@class' => 'DV_TEXT'
                                                                },
                                                      'value' => {
                                                                   '@class' => 'DV_TEXT',
                                                                   'value' => 'Patient feeling poorly'
                                                                 }
                                                    }
                                                  ],
                                       '@class' => 'ITEM_TREE'
                                     },
                           'name' => {
                                       '@class' => 'DV_TEXT',
                                       'value' => 'Patient comment'
                                     },
                           'encoding' => {
                                           '@class' => 'CODE_PHRASE',
                                           'code_string' => 'UTF-8',
                                           'terminology_id' => {
                                                                 'value' => 'IANA_character-sets',
                                                                 '@class' => 'TERMINOLOGY_ID'
                                                               }
                                         }
                         }
                       ]
        };
