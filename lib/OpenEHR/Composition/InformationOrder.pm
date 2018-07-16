package OpenEHR::Composition::InformationOrder;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'CurrentState' => [qw( planned scheduled aborted completed )];

has current_state => (
    is       => 'rw',
    isa      => 'CurrentState',
    required => 1,
    trigger  => \&_set_state_code,
);
has current_state_code => (
    is  => 'rw',
    isa => 'Str',
);
has service_type => (
    is      => 'rw',
    isa     => 'Str',
    default => 'pathology',
);
has service_name => (
    is      => 'rw', 
    isa     => 'Str',
    default => 'GEL Information data request',
);

sub _set_state_code {
    my $self   = shift;
    my $states = {
        planned   => 526,
        scheduled => 529,
        aborted   => 531,
        completed => 532,
    };
    $self->current_state_code( $states->{ $self->current_state } );
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'ctx/language'                  => $self->language_code,
        'ctx/territory'                 => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name,
        'ctx/id_namespace'              => 'UCLH-NS',
        'ctx/id_scheme'                 => 'UCLH-NS',
        'ctx/health_care_facility|name' => 'UCLH',
        'ctx/health_care_facility|id'   => 'RRV',
        'gel_data_request_summary'      => {
            'service_request' => [
                {
                    'narrative' => [
                        $self->service_name . ' - ' . $self->service_type
                    ],
                    'request' => [
                        {
                            'gel_information_request_details' => [
                                {
                                    'patient_information_request_end_date' =>
                                      ['2018-07-12T12:23:08.531+01:00'],
                                    'patient_information_request_start_date' =>
                                      [ DateTime->now->datetime ]
                                }
                            ],
                            'service_type' => [ $self->service_type ],
                            'timing'       => [
                                {
                                    '|value' => DateTime->now->datetime
                                }
                            ],
                            'service_name' => [ $self->service_name]
                        }
                    ],
                    'requestor_identifier' => ['Ident. 43'],
                    'expiry_time'          => ['2018-08-12T12:23:08.531+01:00'],
                }
            ],
            'service' => [
                {
                    'service_type'         => [ $self->service_type ],
                    'service_name'         => [ $self->service_name ],
                    'comment'              => ['Comment 25'],
                    'time'                 => [ DateTime->now->datetime ],
                    'requestor_identifier' => [
                        {
                            '|id' => '9b9a4864-3062-4ef6-bf92-71ee72351f3a',
                            '|assigner' => 'OpenEHR-Perl',
                            '|issuer'   => 'UCLH',
                            '|type'     => 'Test'
                        }
                    ],
                    'ism_transition' => [
                        {
                            'current_state' => [
                                {
                                    '|code'  => $self->current_state_code,
                                    '|value' => $self->current_state
                                }
                            ]
                        }
                    ]
                }
            ]
        },
    };
    return $composition;
}

#    'ctx/participation_mode'      => 'face-to-face communication',
#    'ctx/participation_id'        => '199',
#    'ctx/participation_function:1'  => 'performer',
#    'ctx/participation_name:1'      => 'Lara Markham',
#    'ctx/participation_id:1'        => '198',
#    'ctx/participation_name'        => 'Dr. Marcus Johnson',
#    'ctx/participation_function'    => 'requester',
#        'context' => [
#            {
#                'individual_professional_demographics_uk' => [
#                    {
#                        'grade'                   => [ 'Grade 46' ],
#                        'professional_identifier' => [
#                            {
#                                '|id' =>
#                                  '51c464b4-234f-447c-8c62-266af833fc06',
#                                '|assigner' => 'Assigner',
#                                '|issuer'   => 'Issuer',
#                                '|type'     => 'Prescription'
#                            }
#                        ],
#                        'team'               => [ 'Team 17' ],
#                        'professional_group' => [ 'Professional group 88' ]
#                    }
#                ]
#            }
#        ],
sub compose_raw {
    my $self        = shift;
    my $composition = {
        'territory' => {
            'terminology_id' => {
                'value'  => $self->territory_terminology,
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => $self->territory_code,
            '@class'      => 'CODE_PHRASE'
        },
        'language' => {
            'terminology_id' => {
                'value'  => $self->language_terminology,
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => $self->language_code,
            '@class'      => 'CODE_PHRASE'
        },
        'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
#       'uid'               => {
#           'value'  => '81a78d8a-a4d0-4c20-b6a5-69c203f969fe::default::1',
#           '@class' => 'OBJECT_VERSION_ID'
#       },
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
                                'value'  => 'Ident. 6',
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
                        'value'  => $self->language_terminology,
                        '@class' => 'TERMINOLOGY_ID'
                    },
                    'code_string' => $self->language_code,
                    '@class'      => 'CODE_PHRASE'
                },
                'archetype_node_id' => 'openEHR-EHR-INSTRUCTION.request.v0',
#               'uid'               => {
#                   'value'  => '',
#                   '@class' => 'HIER_OBJECT_ID'
#               },
                'subject' => {
                    '@class' => 'PARTY_SELF'
                },
                'activities' => [
                    {
                        'action_archetype_id' => '/.*/',
                        'timing'              => {
                            'value'     => DateTime->now->datetime,
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
                                        'value' =>
                                          $self->service_name,
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
                    'value'  => '2018-07-14T11:16:32.485+01:00',
                    '@class' => 'DV_DATE_TIME'
                },
                '@class'    => 'INSTRUCTION',
                'narrative' => {
                    'value'  => $self->service_name . ' - ' . $self->service_type,
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
                    'value'  => '2018-07-13T08:36:44+01:00',
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
                                'value'  => $self->service_type,
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
                        'value'         => $self->current_state,
                        'defining_code' => {
                            'terminology_id' => {
                                'value'  => 'openehr',
                                '@class' => 'TERMINOLOGY_ID'
                            },
                            'code_string' => $self->current_state_code,
                            '@class'      => 'CODE_PHRASE'
                        },
                        '@class' => 'DV_CODED_TEXT'
                    },
                    '@class' => 'ISM_TRANSITION'
                },
                'encoding' => {
                    'terminology_id' => {
                        'value'  => $self->encoding_terminology,
                        '@class' => 'TERMINOLOGY_ID'
                    },
                    'code_string' => $self->encoding_code,
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
                'value'  => DateTime->now->datetime,
                '@class' => 'DV_DATE_TIME'
            },
            'health_care_facility' => {
                'name'         => 'UCLH',
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
            'name'   => $self->composer_name,
            '@class' => 'PARTY_IDENTIFIED'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path =
      'laboratory_result_report/laboratory_test:__TEST__/test_request_details/';
    my $composition = {
        'ctx/language'                  => $self->language_code,
        'ctx/territory'                 => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name,
        'ctx/time'                      => DateTime->now->datetime,
        'ctx/id_namespace'              => 'UCLH-NS',
        'ctx/id_scheme'                 => 'UCLH-NS',
        'ctx/health_care_facility|name' => 'UCLH',
        'ctx/health_care_facility|id'   => 'RRV',
        'gel_data_request_summary/service_request:0/request:0/service_name' =>
          $self->service_name,
        'gel_data_request_summary/service_request:0/request:0/service_type' =>
          $self->service_type,
        'gel_data_request_summary/service_request:0/request:0/timing' =>
          DateTime->now->datetime,
        'gel_data_request_summary/service_request:0/narrative' =>
          $self->service_name . ' - ' . $self->service_type,
        'gel_data_request_summary/service_request:0/requestor_identifier' =>
          'Ident. 6',
        'gel_data_request_summary/service_request:0/expiry_time' =>
          '2018-07-14T11:16:32.485+01:00',
        'gel_data_request_summary/service:0/ism_transition/current_state|code'
          => $self->current_state_code,
        'gel_data_request_summary/service:0/ism_transition/current_state|value'
          => $self->current_state,
        'gel_data_request_summary/service:0/service_name' =>
          $self->service_name,
        'gel_data_request_summary/service:0/service_type' => 'pathology',
        'gel_data_request_summary/service:0/time' => DateTime->now->datetime,
    };

    return $composition;
}

#        'ctx/participation_id'          => '199',
#        'ctx/participation_function'    => 'requester',
#        'ctx/participation_name'        => 'Dr. Marcus Johnson',
#        'ctx/participation_mode'        => 'face-to-face communication',
#        'ctx/participation_id:1'        => '198',
#        'ctx/participation_function:1'  => 'performer',
#        'ctx/participation_name:1'      => 'Lara Markham',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0'
#          => '3cee91a5-eba2-42b0-9bfa-21fe3a7c5b38',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|issuer'
#          => 'Issuer',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/grade'
#          => 'Grade 11',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|assigner'
#          => 'Assigner',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_group'
#          => 'Professional group 18',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/team'
#          => 'Team 36',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|type'
#          => 'Prescription',
#        'gel_data_request_summary/service:0/requestor_identifier|issuer' =>
#          'Issuer',
#        'gel_data_request_summary/service_request:0/_uid' =>
#          'e0d413ed-5c42-4257-8eed-9de8806d7782',
#        'gel_data_request_summary/service:0/requestor_identifier|type' =>
#          'Prescription',
#        'gel_data_request_summary/service:0/comment' => 'Comment 45',
#'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_end_date'
#          => '2018-07-12T11:16:32.485+01:00',
#        'gel_data_request_summary/service:0/requestor_identifier' =>
#          '0cce9c45-861f-4d4e-8102-0a9c96cf59dc',
#'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_start_date'
#          => '2018-07-12T11:16:32.485+01:00',
#        'gel_data_request_summary/service:0/requestor_identifier|assigner' =>
#          'Assigner',

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::InformationOrder - Information Order composition element


=head1 VERSION

This document describes OpenEHR::Composition::InformationOrder version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::InformationOrder;
    my $planned_order = OpenEHR::Composition::InformationOrder->new(
        current_state      => 'planned',
    );
    my $info_order_hash = $planned_order->compose;


  
=head1 DESCRIPTION

Used to create a hashref element of an information order 
composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 current_state

Text value for the current completeness state of the 
information order. Can be one of 
['planned'|'scheduled'|'aborted'|'completed']

=head2 current_state_code

Numeric code value for the current completeness state
of the information order. Set automatically based on 
the current_state attribute

=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format


=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::InformationOrder requires no configuration files or 
environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

When using the RAW format compositions, uids are not automatically assigned to 
instructions or actions

Please report any bugs or feature requests to
C<bug-openehr-composition-filler@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Ramlakhan  C<< <dram1964@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2017, David Ramlakhan C<< <dram1964@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
