package OpenEHR::Composition::InformationOrder;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
use DateTime::Format::Pg;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'CurrentState' => [qw( planned scheduled aborted complete )];

enum 'ServiceType' => [qw( pathology radiology cancer )];

has narrative => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => \&_set_narrative,
);

has requestor_id => (
    is  => 'rw',
    isa => 'Str',
);

has current_state => (
    is      => 'rw',
    isa     => 'CurrentState',
    trigger => \&_set_state_code,
);
has current_state_code => (
    is  => 'rw',
    isa => 'Str',
);
has service_type => (
    is      => 'rw',
    isa     => 'ServiceType',
    default => 'pathology',
);
has service_name => (
    is      => 'rw',
    isa     => 'Str',
    default => 'GEL Information data request',
);
has start_date => (
    is  => 'rw',
    isa => 'DateTime',
);
has end_date => (
    is  => 'rw',
    isa => 'DateTime',
);
has timing => (
    is  => 'rw',
    isa => 'DateTime',
);
has expiry_time => (
    is  => 'rw',
    isa => 'DateTime',
);

sub _set_state_code {
    my $self   = shift;
    my $states = {
        planned   => 526,
        scheduled => 529,
        aborted   => 531,
        complete  => 532,
    };
    $self->current_state_code( $states->{ $self->current_state } );
}

sub _set_narrative {
    my $self      = shift;
    my $narrative = $self->service_name . ' - ' . $self->service_type;
    $self->narrative($narrative);
}

sub decompose {
    my ( $self, $composition ) = @_;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    my $formatter = 'decompose_' . lc( $self->composition_format );
    $self->$formatter($composition);
}

sub decompose_flat {
    my ( $self, $composition ) = @_;
    $self->composition_uid( $composition->{'gel_data_request_summary/_uid'} );
    $self->requestor_id( $composition->{ 'gel_data_request_summary/service_request:0/requestor_identifier' } );
    $self->current_state( $composition->{ 'gel_data_request_summary/service:0/ism_transition/current_state|value' });
    $self->start_date( format_datetime( $composition->{ 'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_start_date' } ));
    $self->end_date( format_datetime( $composition->{ 'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_end_date' } ));
    $self->timing( format_datetime( $composition->{ 'gel_data_request_summary/service_request:0/request:0/timing'} ) );
    $self->expiry_time( format_datetime( $composition->{'gel_data_request_summary/service_request:0/expiry_time'} ));
    $self->composer_name( $composition->{'gel_data_request_summary/composer|name'} );
    $self->facility_id( $composition->{ 'gel_data_request_summary/context/_health_care_facility|id'} );
    $self->facility_name( $composition->{ 'gel_data_request_summary/context/_health_care_facility|name'} );
    $self->id_scheme( $composition->{ 'gel_data_request_summary/context/_health_care_facility|id_scheme'});
    $self->id_namespace( $composition->{ 'gel_data_request_summary/context/_health_care_facility|id_namespace' });
    $self->language_code( $composition->{'gel_data_request_summary/language|code'} );
    $self->language_terminology( $composition->{'gel_data_request_summary/language|terminology'} );
    $self->service_name( $composition->{'gel_data_request_summary/service:0/service_name'} );
    $self->service_type( $composition->{'gel_data_request_summary/service:0/service_type'} );
    $self->encoding_code( $composition->{'gel_data_request_summary/service:0/encoding|code'} );
    $self->encoding_terminology( $composition->{ 'gel_data_request_summary/service:0/encoding|terminology'} );
    $self->narrative( $composition->{'gel_data_request_summary/service_request:0/narrative'});
    $self->requestor_id( $composition->{ 'gel_data_request_summary/service_request:0/requestor_identifier'});
    $self->territory_code( $composition->{'gel_data_request_summary/territory|code'} );
    $self->territory_terminology( $composition->{'gel_data_request_summary/territory|terminology'} );

    return 1;
}

sub decompose_structured {
    my ( $self, $composition ) = @_;
    croak "Not an information order compostion"
      if ( !defined( $composition->{gel_data_request_summary} ) );
    my $service = $composition->{gel_data_request_summary}->{service}->[0];
    my $service_request = $composition->{gel_data_request_summary}->{service_request}->[0];
    my $request_details = $service_request->{request}->[0]->{gel_information_request_details}->[0];
    my $context = $composition->{gel_data_request_summary}->{context}->[0];

    $self->facility_id( $context->{'_health_care_facility'}->[0]->{'|id'} );
    $self->facility_name( $context->{'_health_care_facility'}->[0]->{'|name'} );
    $self->id_namespace( $context->{'_health_care_facility'}->[0]->{'|id_namespace'} );
    $self->id_scheme( $context->{'_health_care_facility'}->[0]->{'|id_scheme'} );

    $self->current_state( $service->{ism_transition}->[0]->{current_state}->[0]->{'|value'} );

    my $expiry_time = &format_datetime( $service_request->{expiry_time}->[0] );
    $self->expiry_time($expiry_time);

    my $start_date;
    if ( $request_details->{patient_information_request_start_date} ) {
        $start_date = &format_datetime( $request_details->{patient_information_request_start_date}->[0] );
    }
    elsif ( $context->{start_time} ) {
        $start_date = &format_datetime( $context->{start_time}->[0] );
    }
    $self->start_date($start_date);

    my $end_date;
    if ( $request_details->{patient_information_request_end_date} ) {
        $end_date = &format_datetime( $request_details->{patient_information_request_end_date}->[0] );
    }
    elsif ( $context->{_end_time}->[0] ) {
        $end_date = &format_datetime( $context->{_end_time}->[0] );
    }
    $end_date = $end_date ? $end_date : DateTime->now;
    $self->end_date($end_date);

    my $timing = &format_datetime( $service_request->{request}->[0]->{timing}->[0]->{'|value'} );
    $self->timing($timing);

    $self->requestor_id( $service_request->{requestor_identifier}->[0] );
    $self->composer_name( $composition->{gel_data_request_summary}->{composer}->[0]->{'|name'} );
    $self->composition_uid( $composition->{gel_data_request_summary}->{'_uid'}->[0] );
    $self->requestor_id( $service_request->{requestor_identifier}->[0] );
    $self->language_code( $composition->{gel_data_request_summary}->{language}->[0]->{'|code'} );
    $self->language_terminology( $composition->{gel_data_request_summary}->{language}->[0]->{'|terminology'} );
    $self->service_name( $service->{service_name}->[0] );
    $self->service_type( $service->{service_type}->[0] );
    $self->encoding_code( $service->{encoding}->[0]->{'|code'} );
    $self->encoding_terminology( $service->{encoding}->[0]->{'|terminology'} );
    $self->narrative( $service_request->{narrative}->[0] );
    $self->territory_code( $composition->{gel_data_request_summary}->{territory}->[0]->{'|code'} );
    $self->territory_terminology( $composition->{gel_data_request_summary}->{territory}->[0]->{'|terminology'} );

    return 1;
}

=head1 attribute_list
$self->composition_uid
$self->requestor_id
$self->current_state
$self->start_date
$self->end_date
$self->timing
$self->expiry_time
$self->composer_name
$self->facility_id
$self->facility_name
$self->id_scheme
$self->id_namespace
$self->language_code
$self->language_terminology
$self->service_name
$self->service_type
$self->encoding_code
$self->encoding_terminology
$self->narrative
$self->requestor_id
$self->territory_code
$self->territory_terminology
=cut

sub decompose_raw {
    my ( $self, $composition ) = @_;
    for my $content ( @{ $composition->{content} } ) {
        if ( $content->{archetype_node_id} eq 'openEHR-EHR-ACTION.service.v0' )
        {
            $self->current_state( $content->{ism_transition}->{current_state}->{value} );
            $self->current_state_code( $content->{ism_transition}->{current_state}->{defining_code}->{code_string} );
        }
        elsif ( $content->{archetype_node_id} eq 'openEHR-EHR-INSTRUCTION.request.v0' )
        {
            $self->requestor_id( $content->{protocol}->{items}->[0]->{value}->{value} );
            my $timing = &format_datetime( $content->{activities}->[0]->{timing}->{value} );
            $self->timing($timing);

            my $expiry_time = &format_datetime( $content->{expiry_time}->{value} );
            $self->expiry_time($expiry_time);

            for my $request_item ( @{ $content->{activities}->[0]->{description}->{items} } ) {
                if ( $request_item->{archetype_node_id} eq 'openEHR-EHR-CLUSTER.information_request_details_gel.v0' ) {
                    for my $request_date ( @{ $request_item->{items} } ) {
                        if ( $request_date->{archetype_node_id} eq 'at0001' ) {
                            my $start_date = &format_datetime( $request_date->{value}->{value} );
                            $self->start_date($start_date);
                        }
                        elsif ( $request_date->{archetype_node_id} eq 'at0002' ) {
                            my $end_date = &format_datetime( $request_date->{value}->{value} );
                            $self->end_date($end_date);
                        }
                    }
                }
                elsif ( $request_item->{archetype_node_id} eq 'at0121' ) {
                    $self->service_name( $request_item->{value}->{value} );
                }
                elsif ( $request_item->{archetype_node_id} eq 'at0148' ) {
                    $self->service_type( $request_item->{value}->{value} );
                }
            }
        }

    }
    return 1;
}

sub format_datetime {
    my $date = shift;
    if ( !defined($date) ) {
        $date = DateTime->now->datetime;
    }
    if ( $date eq 'R1' ) {
        $date = DateTime->now->datetime;
    }
    if ( $date =~ /(\d{4}-\d{2}-\d{2}T\d{2}:\d{2})(\+\d{2}:\d{2})/ ) {
        my ( $part1, $part2 ) = ( $1, $2 );
        $part1 .= ':00';
        $date = $part1 . $part2;
    }
    $date =~ s/T/ /;
    $date =~ s/(\d{2,2}:\d{2,2}:\d{2,2})Z/$1/;
    $date =~ s/Z/\:00/;
    eval { $date = DateTime::Format::Pg->parse_datetime($date); };
    if ($@) {
        croak $@;
    }
    else {
        #$date = DateTime::Format::Pg->parse_datetime($date);
        return $date;
    }
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
        ctx => {
            'language'      => $self->language_code,
            'territory'     => $self->territory_code,
            'composer_name' => $self->composer_name,
            'id_namespace'              => $self->id_namespace,
            'id_scheme'                 => $self->id_scheme,
            'health_care_facility|name' => $self->facility_name,
            'health_care_facility|id'   => $self->facility_id,
        },
        'gel_data_request_summary' => {
            'service_request' => [
                {
                    'narrative' => [ $self->narrative ],
                    'request'   => [
                        {
                            'gel_information_request_details' => [
                                {
                                    'patient_information_request_end_date' =>
                                      $self->end_date->datetime,
                                    'patient_information_request_start_date' =>
                                      $self->start_date->datetime,
                                }
                            ],
                            'service_type' => [ $self->service_type ],
                            'timing'       => [
                                {
                                    '|value' => $self->timing->datetime,

                                }
                            ],
                            'service_name' => [ $self->service_name ]
                        }
                    ],
                    'requestor_identifier' => $self->requestor_id,
                    'expiry_time' => $self->expiry_time->datetime,
                }
            ],
            'service' => [
                {
                    'service_type' => [ $self->service_type ],
                    'service_name' => [ $self->service_name ],
                    'time'           => [ DateTime->now->datetime ],
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

sub compose_raw {
    my $self        = shift;
    my $composition = {
        category => {
            'value'         => 'event',
            '@class'        => 'DV_CODED_TEXT',
            'defining_code' => {
                'code_string'    => '433',
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'openehr'
                }
            }
        },
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
        'context' => {
            'start_time' => {
                'value'  => DateTime->now->datetime,
                '@class' => 'DV_DATE_TIME'
            },
            'health_care_facility' => {
                'name'         => $self->facility_name,
                'external_ref' => {
                    'namespace' => $self->id_namespace,
                    'type'      => 'PARTY',
                    'id'        => {
                        'value'  => $self->facility_id,
                        'scheme' => $self->id_scheme,
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
                '@class' => 'DV_CODED_TEXT',
            },
            '@class' => 'EVENT_CONTEXT',
        },
        'composer' => {
            'name'   => $self->composer_name,
            '@class' => 'PARTY_IDENTIFIED'
        },
        'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
        'content'           => [
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
                                'value'  => $self->requestor_id,
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

                'subject' => {
                    '@class' => 'PARTY_SELF'
                },
                'activities' => [
                    {
                        'action_archetype_id' => '/.*/',
                        'timing'              => {
                            'value'     => $self->timing->datetime,
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
                                        'value'  => $self->service_name,
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
                                        'value'  => $self->service_type,
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
                                                  $self->start_date->datetime,
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
                                                'value' =>
                                                  $self->end_date->datetime,
                                                '@class' => 'DV_DATE_TIME'
                                            },
                                            'name' => {
                                                'value' =>
'Patient information request end date',
                                                '@class' => 'DV_TEXT'
                                            },
                                            '@class' => 'ELEMENT'
                                        },
                                    ],
                                    '@class' => 'CLUSTER'
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
                    'value'  => $self->expiry_time->datetime,
                    '@class' => 'DV_DATE_TIME'
                },
                '@class'    => 'INSTRUCTION',
                'narrative' => {
                    'value'  => $self->narrative,
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
                    'value'  => DateTime->now->datetime,
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
                                'value'  => $self->service_name,
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
                                'value'  => $self->service_type,
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
        '@class' => 'COMPOSITION',
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'ctx/language'      => $self->language_code,
        'ctx/territory'     => $self->territory_code,
        'ctx/composer_name' => $self->composer_name,
        'ctx/id_namespace'              => $self->id_namespace,
        'ctx/id_scheme'                 => $self->id_scheme,
        'ctx/health_care_facility|name' => $self->facility_name,
        'ctx/health_care_facility|id'   => $self->facility_id,
        'gel_data_request_summary/service_request:0/request:0/service_name' =>
          $self->service_name,
        'gel_data_request_summary/service_request:0/request:0/service_type' =>
          $self->service_type,
        'gel_data_request_summary/service_request:0/request:0/timing' =>
          $self->timing->datetime,
        'gel_data_request_summary/service_request:0/narrative' =>
          $self->narrative,
        'gel_data_request_summary/service_request:0/requestor_identifier' =>
          $self->requestor_id,
        'gel_data_request_summary/service_request:0/expiry_time' => =>
          $self->expiry_time->datetime,
        'gel_data_request_summary/service:0/ism_transition/current_state|code'
          => $self->current_state_code,
        'gel_data_request_summary/service:0/ism_transition/current_state|value'
          => $self->current_state,
        'gel_data_request_summary/service:0/service_name' =>
          $self->service_name,
        'gel_data_request_summary/service:0/service_type' =>
          $self->service_type,
        'gel_data_request_summary/service:0/time' => DateTime->now->datetime,
'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_start_date'
          => $self->start_date->datetime,
'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_end_date'
          => $self->end_date->datetime,
          'gel_data_request_summary/service_request:0/requestor_identifier' => $self->requestor_id,
    };

    return $composition;
}

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
['planned'|'scheduled'|'aborted'|'complete']

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

=head2 format_datetime

Takes a date value in 'yyyy-dd-mmThh:mmZ' format and converts it to 'yyyy-mm-dd hh:mm' format

=head2 decompose

Populates an InformationOrder object with the values from a composition hashref

=head2 decompose_structured

Populates an InformationOrder object with the composition_response data 
recieved from a call to OpenEHR::REST::Composition->find_by_uid

=head2 decompose_raw

Populates an InformationOrder object with the composition_response data 
recieved from a call to OpenEHR::REST::Composition->find_by_uid

=head1 PRIVATE METHODS

=head1 _set_state_code

Derives the state_code attribute from the value of current_state

=cut

=head2 _set_narrative

Returns default value for narrative by concatenating
service_name and service_type with ' - '

=cut

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
