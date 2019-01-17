use strict;
use warnings;

use Test::More;
use Data::Dumper;
use OpenEHR::REST::AQL;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;

my $uid =  '4c76ad9d-24c5-4ba6-a3c9-7439c48baf8f::default::1'; #$ENV{TEST_UID};
note("UID: $uid");

my $retrieval = OpenEHR::REST::Composition->new();
$retrieval->request_format('STRUCTURED');
$retrieval->find_by_uid($uid);
my $composition = $retrieval->composition_response;
print "Original order can be found at: " . $retrieval->href . "\n";

if ( $retrieval->response_code eq '204' ) {
    print "No orders found for $uid\n";
    exit 1;
}
if ( $retrieval->err_msg ) {
    die $retrieval->err_msg;
}

ok(my $target = OpenEHR::Composition::InformationOrder->new(), "Create blank Information Order");
ok($target->decompose_structured($composition), "Populate the Order with data from an existing Order");
is($target->composer_name, 'OpenEHR-Perl-STRUCTURED', 'composer_name set from composition');
is($target->facility_id, 'RRV', 'facility_id set from composition');
is($target->facility_name, 'UCLH', 'facility_name set from composition');
is($target->id_namespace, 'UCLH-NAMESPACE', 'id_namespace set from composition');
is($target->id_scheme, 'UCLH-SCHEME', 'id_scheme set from composition');
ok($target->current_state('planned'), "Change state to aborted");
is($target->current_state_code, 529, "Current state code updated to 531");

#print Dumper $target->compose;

my $data = {
    subject_ehr_id     => '',
    subject_id_type    => '',
    composition_uid    => '',
    narrative          => '',
    order_type         => '',
    ordered_by         => '',
    order_id           => '',
    unique_message_id  => '',
    start_date         => '',
    end_date           => '',
    service_type       => '',
    data_start_date    => '',
    data_end_date      => '',
    current_state      => '',
    current_state_code => '',
};


done_testing;

__DATA__

my $result = {
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
        'value'  => '22ae73c6-9fcd-4324-abf6-5829c87c9c1e::default::2',
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
                            'value'  => '2-20190110-784044',
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
                'value'  => '67c5456e-f3c1-4705-80a8-5716269efe3e',
                '@class' => 'HIER_OBJECT_ID'
            },
            'subject' => {
                '@class' => 'PARTY_SELF'
            },
            'activities' => [
                {
                    'action_archetype_id' => '/.*/',
                    'timing'              => {
                        'value'     => '2019-01-10T13:52:37',
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
            'expiry_time' => {
                'value'  => '2019-01-10T16:01:31Z',
                '@class' => 'DV_DATE_TIME'
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
            'protocol' => {
                'archetype_node_id' => 'at0015',
                'name'              => {
                    'value'  => 'Tree',
                    '@class' => 'DV_TEXT'
                },
                'items' => [
                    {
                        'archetype_node_id' => 'at0016',
                        'value'             => {
                            'type'     => 'Test',
                            'id'       => '2-20190110-784044',
                            'issuer'   => 'UCLH',
                            'assigner' => 'OpenEHR-Perl',
                            '@class'   => 'DV_IDENTIFIER'
                        },
                        'name' => {
                            'value'  => 'Requestor identifier',
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
            'archetype_node_id' => 'openEHR-EHR-ACTION.service.v0',
            'time'              => {
                'value'  => '2019-01-10T16:01:31Z',
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
                    'value'         => 'scheduled',
                    'defining_code' => {
                        'terminology_id' => {
                            'value'  => 'openehr',
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        'code_string' => '529',
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
            'value'  => '2019-01-10T16:01:31.421Z',
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
        'name'   => 'OpenEHR-Perl-STRUCTURED',
        '@class' => 'PARTY_IDENTIFIED'
    }
};
