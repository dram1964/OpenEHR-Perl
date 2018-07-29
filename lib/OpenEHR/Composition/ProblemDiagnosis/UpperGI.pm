package OpenEHR::Composition::ProblemDiagnosis::UpperGI;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

=head2 bclc_stage($bclc_stage_obj)

Used to get or set the BCLC Stage item in an Upper GI Staging item

=cut 

has bclc_stage => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::BCLC_Stage]',
);

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'child-pugh_score'  => [ { 'grade' => [ { '|code' => 'at0028' } ] } ],
        'transarterial_chemoembolisation' => [ { '|code' => 'at0015' } ],
        'pancreatic_clinical_stage'       => [ { '|code' => 'at0009' } ],
        'portal_invasion'                 => [ { '|code' => 'at0004' } ],
        'number_of_lesions' => [578],
    };
    if ( $self->bclc_stage ) {
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            push @{ $composition->{bclc_stage} },
                $bclc_stage->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
        '@class'            => 'CLUSTER',
        'name'              => {
            '@class' => 'DV_TEXT',
            'value'  => 'Upper GI staging'
        },
        'items' => [
            {   'archetype_details' => {
                    'rm_version'   => '1.0.1',
                    'archetype_id' => {
                        '@class' => 'ARCHETYPE_ID',
                        'value'  => 'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                    },
                    '@class' => 'ARCHETYPED'
                },
                'items' => [
                    {   '@class'            => 'ELEMENT',
                        'archetype_node_id' => 'at0026',
                        'value'             => {
                            '@class'        => 'DV_CODED_TEXT',
                            'value'         => 'Class A 5 to 6 points.',
                            'defining_code' => {
                                'terminology_id' => {
                                    'value'  => 'local',
                                    '@class' => 'TERMINOLOGY_ID'
                                },
                                'code_string' => 'at0027',
                                '@class'      => 'CODE_PHRASE'
                            }
                        },
                        'name' => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Grade'
                        }
                    }
                ],
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Child-Pugh score'
                },
                '@class' => 'CLUSTER',
                'archetype_node_id' =>
                    'openEHR-EHR-CLUSTER.child_pugh_score.v0'
            },
            {   'name' => {
                    'value'  => 'Portal invasion',
                    '@class' => 'DV_TEXT'
                },
                'value' => {
                    'value'         => 'N Not present',
                    'defining_code' => {
                        'terminology_id' => {
                            'value'  => 'local',
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => 'at0005'
                    },
                    '@class' => 'DV_CODED_TEXT'
                },
                'archetype_node_id' => 'at0003',
                '@class'            => 'ELEMENT'
            },
            {   '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0007',
                'value'             => {
                    'magnitude' => 96,
                    '@class'    => 'DV_COUNT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Number of lesions'
                }
            },
            {   '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0008',
                'value'             => {
                    '@class'        => 'DV_CODED_TEXT',
                    'defining_code' => {
                        'code_string'    => 'at0012',
                        '@class'         => 'CODE_PHRASE',
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => 'local'
                        }
                    },
                    'value' => '31 Unresectable locally advanced'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Pancreatic clinical stage'
                }
            },
            {   'value' => {
                    'value'         => 'Y Yes',
                    'defining_code' => {
                        'terminology_id' => {
                            'value'  => 'local',
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => 'at0015'
                    },
                    '@class' => 'DV_CODED_TEXT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Transarterial chemoembolisation'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0014'
            }
        ],
        'archetype_details' => {
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
            },
            'rm_version' => '1.0.1',
            '@class'     => 'ARCHETYPED'
        }
    };
    if ( $self->bclc_stage ) {
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            push @{ $composition->{items} },
                $bclc_stage->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/portal_invasion|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/portal_invasion|code'
            => 'at0005',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/portal_invasion|value'
            => 'N Not present',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage|value'
            => '31 Unresectable locally advanced',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage|code'
            => 'at0012',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/child-pugh_score:0/grade|code'
            => 'at0027',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/child-pugh_score:0/grade|value'
            => 'Class A 5 to 6 points.',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/child-pugh_score:0/grade|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation|value'
            => 'Y Yes',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation|code'
            => 'at0015',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/number_of_lesions'
            => 97,
    };
    if ( $self->bclc_stage ) {
        my $bclc_stage_index = '0';
        my $bclc_stage_comp;
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            my $composition_fragment = $bclc_stage->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$bclc_stage_index/;
                $bclc_stage_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $bclc_stage_index++;
            $composition = { ( %$composition, %{$bclc_stage_comp} ) };
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::ProblemDiagnosis::UpperGI - composition element


=head1 VERSION

This document describes OpenEHR::Composition::ProblemDiagnosis::UpperGI version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::ProblemDiagnosis::UpperGI;
    my $template = OpenEHR::Composition::ProblemDiagnosis::UpperGI->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a template element for adding to a Problem Diagnosis composition object. 

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

OpenEHR::Composition::ProblemDiagnosis::UpperGI requires no configuration files or 
environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

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
