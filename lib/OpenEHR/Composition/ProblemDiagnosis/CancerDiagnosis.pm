package OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has tumour_laterality => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis::TumourLaterality]',
);

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
        'morphology'           => ['Morphology 86'],
        'metastatic_site'      => [ { '|code' => 'at0023' } ],
        'topography'           => ['Topography 90'],
        'recurrence_indicator' => [ { '|code' => 'at0014' } ]
    };
    if ( $self->tumour_laterality ) {
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            push @{ $composition->{'tumour_laterality'} },
                $tumour_laterality->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        '@class'            => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
        'name'              => {
            'value'  => 'Cancer diagnosis',
            '@class' => 'DV_TEXT'
        },
        'items' => [
            {   'value' => {
                    '@class'        => 'DV_CODED_TEXT',
                    'defining_code' => {
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => 'local'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => 'at0016'
                    },
                    'value' => 'NN'
                },
                'name' => {
                    'value'  => 'Recurrence indicator',
                    '@class' => 'DV_TEXT'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0013'
            },
            {   'value' => {
                    'value'  => 'Morphology 46',
                    '@class' => 'DV_TEXT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Morphology'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0001'
            },
            {   'archetype_node_id' => 'at0002',
                '@class'            => 'ELEMENT',
                'name'              => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Topography'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Topography 75'
                }
            },
            {   'value' => {
                    '@class'        => 'DV_CODED_TEXT',
                    'value'         => '08 Skin',
                    'defining_code' => {
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => 'local'
                        },
                        'code_string' => 'at0023',
                        '@class'      => 'CODE_PHRASE'
                    }
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Metastatic site'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0017'
            },
        ],
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            'rm_version' => '1.0.1'
        }
    };
    if ( $self->tumour_laterality ) {
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            push @{ $composition->{items} },
                $tumour_laterality->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {

        # Cancer Diagnosis
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/recurrence_indicator|value'
            => 'NN',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/recurrence_indicator|code'
            => 'at0016',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/recurrence_indicator|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site|code'
            => 'at0023',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site|value'
            => '08 Skin',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/morphology:0'
            => 'Morphology 46',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/topography'
            => 'Topography 75',
    };
    if ( $self->tumour_laterality ) {
        my $tumour_laterality_index = '0';
        my $tumour_laterality_comp;
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            my $composition_fragment = $tumour_laterality->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$tumour_laterality_index/;
                $tumour_laterality_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $tumour_laterality_index++;
            $composition = { ( %$composition, %{$tumour_laterality_comp} ) };
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis - composition element


=head1 VERSION

This document describes OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis;
    my $template = OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis->new(
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

OpenEHR::Composition::ProblemDiagnosis::CancerDiagnosis requires no configuration files or 
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
