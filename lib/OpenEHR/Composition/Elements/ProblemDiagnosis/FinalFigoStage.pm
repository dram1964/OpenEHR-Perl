package OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'FigoCode' => [
    qw( i ii iii iv ia ib ic1 ic2 ic3 iia
      iib iiia1_i iiia1_ii iiia2 iiib iiic iva ivb iiia iiic1 iiic2 ic iiia1
      I II III IV IA IB IC1 IC2 IC3 IIA
      IIB IIIA1_I IIIA1_II IIIA2 IIIB IIIC IVA IVB IIIA IIIC1 IIIC2 IC IIIA1 )
];
has code => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_get_figo_code',
);
has value => (
    is  => 'rw',
    isa => 'FigoCode',
);
has terminology => (
    is  => 'rw',
    isa => 'Str',
    default => 'local',
);
has version => (
    is  => 'rw',
    isa => 'Str',
    default => 'Figo Version 89',
);

=head2 _get_figo_code

Private method to derive the Figo Code from the value parameter provided

=cut

sub _get_figo_code {
    my $self       = shift;
    my $figo_codes = {
        i        => 'at0002',
        ii       => 'at0003',
        iii      => 'at0004',
        iv       => 'at0006',
        ia       => 'at0007',
        ib       => 'at0008',
        ic1      => 'at0009',
        ic2      => 'at0010',
        ic3      => 'at0011',
        iia      => 'at0012',
        iib      => 'at0013',
        iiia1_i  => 'at0014',
        iiia1_ii => 'at0015',
        iiia2    => 'at0016',
        iiib     => 'at0017',
        iiic     => 'at0018',
        iva      => 'at0019',
        ivb      => 'at0020',
        iiia     => 'at0021',
        iiic1    => 'at0022',
        iiic2    => 'at0023',
        ic       => 'at0024',
        iiia1    => 'at0025',
        I        => 'at0002',
        II       => 'at0003',
        III      => 'at0004',
        IV       => 'at0006',
        IA       => 'at0007',
        IB       => 'at0008',
        IC1      => 'at0009',
        IC2      => 'at0010',
        IC3      => 'at0011',
        IIA      => 'at0012',
        IIB      => 'at0013',
        IIIA1_I  => 'at0014',
        IIIA1_II => 'at0015',
        IIIA2    => 'at0016',
        IIIB     => 'at0017',
        IIIC     => 'at0018',
        IVA      => 'at0019',
        IVB      => 'at0020',
        IIIA     => 'at0021',
        IIIC1    => 'at0022',
        IIIC2    => 'at0023',
        IC       => 'at0024',
        IIIA1    => 'at0025',
    };
    $self->code( $figo_codes->{ $self->value } );
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
        'figo_version' => [ $self->version ],
        'figo_grade'   => [
            {
                '|code'        => $self->code,
                '|value'       => $self->value,
                '|terminology' => $self->terminology,
            }
        ]
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        '@class'            => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.figo_grade.v0',
        'items'             => [
            {
                'archetype_node_id' => 'at0001',
                '@class'            => 'ELEMENT',
                'name'              => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'FIGO grade'
                },
                'value' => {
                    'value'         => $self->value,    #'ib',
                    'defining_code' => {
                        'code_string'    => $self->code,     #'at0008',
                        '@class'         => 'CODE_PHRASE',
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => $self->terminology,    #'local'
                        }
                    },
                    '@class' => 'DV_CODED_TEXT'
                }
            },
            {
                'archetype_node_id' => 'at0005',
                '@class'            => 'ELEMENT',
                'name'              => {
                    'value'  => 'FIGO version',
                    '@class' => 'DV_TEXT'
                },
                'value' => {
                    'value'  => $self->version,    #'FIGO version 99',
                    '@class' => 'DV_TEXT'
                }
            }
        ],
        'name' => {
            'value'  => 'Final FIGO stage',
            '@class' => 'DV_TEXT'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.figo_grade.v0',
                '@class' => 'ARCHETYPE_ID'
            }
        }
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage:__DIAG__/figo_grade|code'
          => $self->code,    #'at0008',
'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage:__DIAG__/figo_grade|value'
          => $self->value,    #'ib',
'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage:__DIAG__/figo_version'
          => $self->version,    #'FIGO version 99',
'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage:__DIAG__/figo_grade|terminology'
          => $self->terminology,    #'local',
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a template element for adding to a Problem Diagnosis composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 code($code)

Used to get or set the Final Figo Stage code

=head2 value($value)

Used to get or set the Final Figo Stage value

=head2 terminology($terminology)

Used to get or set the Final Figo Stage terminology

=head2 version($version)

Used to get or set the Final Figo Stage version

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

OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage requires no configuration files or 
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
