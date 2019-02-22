package OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

=head2 integrated_m($integrated_m)

Used to get or set the integrated_m value

=cut 

has integrated_m => (
    is  => 'rw',
    isa => 'Str',
);

=head2 integrated_n($integrated_n)

Used to get or set the integrated_n value

=cut 

has integrated_n => (
    is  => 'rw',
    isa => 'Str',
);

=head2 integrated_t($integrated_t)

Used to get or set the integrated_t value

=cut 

has integrated_t => (
    is  => 'rw',
    isa => 'Str',
);

=head2 stage_grouping($stage_grouping)

Used to get or set the stage_grouping value

=cut 

has stage_grouping => (
    is  => 'rw',
    isa => 'Str',
);

=head2 tnm_edition($tnm_edition)

Used to get or set the tnm_edition value

=cut 

has tnm_edition => (
    is  => 'rw',
    isa => 'Str',
);

=head2 grading_at_diagnosis($grading_at_diagnosis)

Used to get or set the grading_at_diagnosis value

=cut 

has grading_at_diagnosis => (
    is  => 'rw',
    isa => 'Str',
);

has grading_at_diagnosis_text => (
    is => 'rw',
    lazy => 1,
    builder => '_set_grading_at_diagnosis_text',
);

=head2 _set_grading_at_diagnosis_text

Translates grading_at_diagnosis code value to appropriate 
text value

=cut

sub _set_grading_at_diagnosis_text {
    my $self = shift;
    if ($self->grading_at_diagnosis) {
        if ($self->grading_at_diagnosis eq 'GX') {
            $self->grading_at_diagnosis_text('GX Grade of differentiation is not appropriate or cannot be assessed');
        }
        elsif ($self->grading_at_diagnosis eq 'G1') {
            $self->grading_at_diagnosis_text('G1 Well differentiated');
        }
        elsif ($self->grading_at_diagnosis eq 'G2') {
            $self->grading_at_diagnosis_text('G2 Moderately differentiated');
        }
        elsif ($self->grading_at_diagnosis eq 'G3') {
            $self->grading_at_diagnosis_text('G3 Poorly differentiated');
        }
        elsif ($self->grading_at_diagnosis eq 'G4') {
            $self->grading_at_diagnosis_text('G4 Undifferentiated / anaplastic');
        }
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
        'integrated_m'              => [ $self->integrated_m ],
        'integrated_t'              => [ $self->integrated_t ],
        'integrated_stage_grouping' => [ $self->stage_grouping ],
        'integrated_n'              => [ $self->integrated_n ],
        'grading_at_diagnosis'      => [ $self->grading_at_diagnosis_text ],
        'integrated_tnm_edition'    => [ $self->tnm_edition ],
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'items' => [
            {   'archetype_node_id' => 'at0001',
                '@class'            => 'ELEMENT',
                'name'              => {
                    'value'  => 'Integrated T',
                    '@class' => 'DV_TEXT'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->integrated_t,    #'Integrated T 99'
                }
            },
            {   'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Integrated N'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->integrated_n,    #'Integrated N 15'
                },
                'archetype_node_id' => 'at0002',
                '@class'            => 'ELEMENT'
            },
            {   'archetype_node_id' => 'at0003',
                '@class'            => 'ELEMENT',
                'name'              => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Integrated M'
                },
                'value' => {
                    'value'  => $self->integrated_m,    #'Integrated M 25',
                    '@class' => 'DV_TEXT'
                }
            },
            {   'archetype_node_id' => 'at0007',
                '@class'            => 'ELEMENT',
                'name'              => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Integrated Stage grouping'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value' =>
                        $self->stage_grouping, #'Integrated Stage grouping 31'
                }
            },
            {   '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0017',
                'value'             => {
                    '@class' => 'DV_TEXT',
                    'value' =>
                        $self->tnm_edition,    #'Integrated TNM Edition 44'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Integrated TNM Edition'
                }
            }
        ],
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Integrated TNM'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
            }
        },
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
        '@class'            => 'CLUSTER'
    };

    if ( $self->grading_at_diagnosis ) {
        push @{ $composition->items }, 
            {   'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Grading at diagnosis'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->grading_at_diagnosis_text
                    ,    #'G4 Undifferentiated / anaplastic'
                },
                'archetype_node_id' => 'at0005',
                '@class'            => 'ELEMENT'
            };
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/integrated_t'
            => $self->integrated_t,    #'Integrated T 99',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/integrated_m'
            => $self->integrated_m,    #'Integrated M 25',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/integrated_stage_grouping'
            => $self->stage_grouping,    #'Integrated Stage grouping 31',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/integrated_tnm_edition'
            => $self->tnm_edition,       #'Integrated TNM Edition 44',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/integrated_n'
            => $self->integrated_n,      #'Integrated N 15',
    };
    if ( $self->grading_at_diagnosis ) {
        $composition->{ 'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm:__DIAG__/grading_at_diagnosis' }
            = $self->grading_at_diagnosis_text;
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM->new(
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

OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM requires no configuration files or 
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
