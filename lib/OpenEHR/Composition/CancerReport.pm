package OpenEHR::Composition::CancerReport;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has problem_diagnoses => (
    is      => 'rw',
    isa     => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis]',
    default => sub { [] }
);

has contexts => (
    is  => 'rw',
    isa => 'ArrayRef',
);

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );

    for my $problem_diagnosis (@{ $self->problem_diagnoses } ) {
        $problem_diagnosis->composition_format($self->composition_format);
    }
    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'ctx/id_namespace'              => 'HOSPITAL-NS',
        'ctx/health_care_facility|name' => 'Hospital',
        'ctx/id_scheme'                 => 'HOSPITAL-NS',
        'ctx/composer_name'             => 'STRUCTURED',
        'ctx/health_care_facility|id'   => '9091',
        'ctx/territory'                 => 'GB',
        'ctx/language'                  => 'en',
        'ctx/participation_function:1'  => 'performer',
        'ctx/participation_function'    => 'requester',
        'ctx/participation_name:1'      => 'Lara Markham',
        'ctx/participation_name'        => 'Dr. Marcus Johnson',
        'ctx/participation_mode'        => 'face-to-face communication',
        'ctx/participation_id:1'        => '198',
        'ctx/participation_id'          => '199',
        'gel_cancer_diagnosis'          => {
            'context' => [
                {   'participant' => [
                        {   'study_identifier' => [
                                {   '|assigner' => 'Assigner',
                                    '|id' =>
                                        '718ffece-da5e-4d17-8e13-470aff5e98a8',
                                    '|issuer' => 'Issuer',
                                    '|type'   => 'Prescription'
                                }
                            ],
                            'participant_identifier' => [
                                {   '|type'   => 'Prescription',
                                    '|issuer' => 'Issuer',
                                    '|id' =>
                                        '4227c2cb-8f0c-49b6-bd93-345b6174324b',
                                    '|assigner' => 'Assigner'
                                }
                            ]
                        }
                    ],
                    'report_id' => ['Report ID 93']
                }
            ]
        },
    };
    my $problem_diagnoses;
    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        push @{$problem_diagnoses}, $problem_diagnosis->compose;
    }
    $composition->{gel_cancer_diagnosis}->{problem_diagnosis} = $problem_diagnoses;

    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
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
        'territory' => {
            '@class'         => 'CODE_PHRASE',
            'code_string'    => 'GB',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => 'ISO_3166-1'
            }
        },
        'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
        'uid'               => {
            '@class' => 'OBJECT_VERSION_ID',
            'value'  => 'de7b024f-aba4-4401-ab73-4d18bb49d60d::default::1'
        },
        'composer' => {
            '@class' => 'PARTY_IDENTIFIED',
            'name'   => 'RAW'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-COMPOSITION.report.v1'
            },
            'template_id' => {
                'value'  => 'GEL Cancer diagnosis input.v0',
                '@class' => 'TEMPLATE_ID'
            }
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'GEL Cancer diagnosis'
        },
        '@class'   => 'COMPOSITION',
        'language' => {
            '@class'         => 'CODE_PHRASE',
            'code_string'    => 'en',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => 'ISO_639-1'
            }
        },
        'context' => {
            'health_care_facility' => {
                'external_ref' => {
                    'id' => {
                        'scheme' => 'UCLH-NS',
                        '@class' => 'GENERIC_ID',
                        'value'  => 'RRV'
                    },
                    '@class'    => 'PARTY_REF',
                    'namespace' => 'UCLH-NS',
                    'type'      => 'PARTY'
                },
                'name'   => 'UCLH NHS Foundation Trust',
                '@class' => 'PARTY_IDENTIFIED'
            },
            '@class'        => 'EVENT_CONTEXT',
            'other_context' => {
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Tree'
                },
                'items' => [
                    {   'value' => {
                            'value'  => 'Report ID 75',
                            '@class' => 'DV_TEXT'
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Report ID'
                        },
                        '@class'            => 'ELEMENT',
                        'archetype_node_id' => 'at0002'
                    },
                    {   'archetype_node_id' =>
                            'openEHR-EHR-CLUSTER.participant_gel.v0',
                        '@class'            => 'CLUSTER',
                        'archetype_details' => {
                            'rm_version'   => '1.0.1',
                            'archetype_id' => {
                                'value' =>
                                    'openEHR-EHR-CLUSTER.participant_gel.v0',
                                '@class' => 'ARCHETYPE_ID'
                            },
                            '@class' => 'ARCHETYPED'
                        },
                        'items' => [
                            {   'name' => {
                                    'value'  => 'Participant identifier',
                                    '@class' => 'DV_TEXT'
                                },
                                'value' => {
                                    'issuer' => 'Issuer',
                                    'id' =>
                                        '85e10b15-7b79-46c0-8d94-892cad063048',
                                    'assigner' => 'Assigner',
                                    'type'     => 'Prescription',
                                    '@class'   => 'DV_IDENTIFIER'
                                },
                                'archetype_node_id' => 'at0015',
                                '@class'            => 'ELEMENT'
                            },
                            {   'value' => {
                                    'id' =>
                                        '0a9db4b5-44cb-4254-ae23-722c1178c265',
                                    'issuer'   => 'Issuer',
                                    '@class'   => 'DV_IDENTIFIER',
                                    'type'     => 'Prescription',
                                    'assigner' => 'Assigner'
                                },
                                'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Study identifier'
                                },
                                '@class'            => 'ELEMENT',
                                'archetype_node_id' => 'at0016'
                            }
                        ],
                        'name' => {
                            'value'  => 'Participant',
                            '@class' => 'DV_TEXT'
                        }
                    }
                ],
                '@class'            => 'ITEM_TREE',
                'archetype_node_id' => 'at0001'
            },
            'start_time' => {
                'value'  => '2018-07-27T07:44:28+01:00',
                '@class' => 'DV_DATE_TIME'
            },
            'setting' => {
                '@class'        => 'DV_CODED_TEXT',
                'value'         => 'other care',
                'defining_code' => {
                    'terminology_id' => {
                        '@class' => 'TERMINOLOGY_ID',
                        'value'  => 'openehr'
                    },
                    '@class'      => 'CODE_PHRASE',
                    'code_string' => '238'
                }
            }
        }
    };
    for my $problem_diagnosis (@{$self->problem_diagnoses}) {
        push @{ $composition->{content} }, $problem_diagnosis->compose;
    }

    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $composition; 

    my $problem_diagnosis_index = '0';
    my $problem_diagnosis_comp;
    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        my $composition_fragment = $problem_diagnosis->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__TEST__/$problem_diagnosis_index/;
            $problem_diagnosis_comp->{$new_key} = $composition_fragment->{$key};
        }
        $problem_diagnosis_index++;
    }

    $composition = {
        'gel_cancer_diagnosis/category|terminology' => 'openehr',
        'gel_cancer_diagnosis/_uid' =>
            'de7b024f-aba4-4401-ab73-4d18bb49d60d::default::1',
        'gel_cancer_diagnosis/language|terminology'  => 'ISO_639-1',
        'gel_cancer_diagnosis/composer|name'         => 'FLAT',
        'gel_cancer_diagnosis/territory|terminology' => 'ISO_3166-1',
        'gel_cancer_diagnosis/language|code'         => 'en',
        'gel_cancer_diagnosis/territory|code'        => 'GB',
        'gel_cancer_diagnosis/category|code'         => '433',
        'gel_cancer_diagnosis/category|value'        => 'event',

        # Context
        'gel_cancer_diagnosis/context/start_time' =>
            '2018-07-27T07:44:28+01:00',
        'gel_cancer_diagnosis/context/setting|value' => 'other care',
        'gel_cancer_diagnosis/context/participant/participant_identifier|type'
            => 'Prescription',
        'gel_cancer_diagnosis/context/participant/study_identifier|type' =>
            'Prescription',
        'gel_cancer_diagnosis/context/participant/participant_identifier|assigner'
            => 'Assigner',
        'gel_cancer_diagnosis/context/_health_care_facility|id' => 'RRV',
        'gel_cancer_diagnosis/context/participant/participant_identifier' =>
            '85e10b15-7b79-46c0-8d94-892cad063048',
        'gel_cancer_diagnosis/context/setting|code' => '238',
        'gel_cancer_diagnosis/context/_health_care_facility|name' =>
            'UCLH NHS Foundation Trust',
        'gel_cancer_diagnosis/context/_health_care_facility|id_namespace' =>
            'UCLH-NS',
        'gel_cancer_diagnosis/context/setting|terminology' => 'openehr',
        'gel_cancer_diagnosis/context/participant/study_identifier|assigner'
            => 'Assigner',
        'gel_cancer_diagnosis/context/participant/study_identifier' =>
            '0a9db4b5-44cb-4254-ae23-722c1178c265',
        'gel_cancer_diagnosis/context/_health_care_facility|id_scheme' =>
            'UCLH-NS',
        'gel_cancer_diagnosis/context/participant/participant_identifier|issuer'
            => 'Issuer',
        'gel_cancer_diagnosis/context/report_id' => 'Report ID 75',
        'gel_cancer_diagnosis/context/participant/study_identifier|issuer' =>
            'Issuer',

        %{$problem_diagnosis_comp},

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

    use OpenEHR::Composition::CancerReport;
    my $planned_order = OpenEHR::Composition::CancerReport->new(
    );
    my $info_order_hash = $planned_order->compose;


  
=head1 DESCRIPTION

Used to create a hashref element of an cancer report 
composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

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

OpenEHR::Composition::CancerReport requires no configuration files or 
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
