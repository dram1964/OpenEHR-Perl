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
    qw( I IA IA1 IA2 IB IB1 IB2 IC IC1 IC2 IC3 II IIA IIA1 IIA2 IIB IIC
      III IIIA IIIAi IIIAii IIIA1 IIIA1i IIIA1ii IIIA2 IIIB IIIC IIIC1
      IIIC2 IV IVA IVB
      )
];

has code => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_get_figo_code',
);
has local_code => (
    is  => 'rw',
    isa => 'FigoCode',
);
has terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => 'local',
);
has version => (
    is      => 'rw',
    isa     => 'Str',
    default => 'indeterminate'    #'Figo Version 89',
);

sub _get_figo_code {
    my $self       = shift;
    my $figo_codes = {
        I   => 'at0002',
        IA  => 'at0007',
        IA1 => 'at0007',          # infered as IA1 === IA
        IA2 => 'at0007',          # infered as IA2 === IA
        IB  => 'at0008',
        IB1 => 'at0008',          # infered as IB1 === IB
        IB2 => 'at0008',          # infered as IB2 === IB
        IC  => 'at0024',
        IC1 => 'at0009',
        IC2 => 'at0010',
        IC3 => 'at0011',

        II   => 'at0003',
        IIA  => 'at0012',
        IIA1 => 'at0012',         # inferred as IIA1 === IIA
        IIA2 => 'at0012',         # inferred as IIA2 === IIA
        IIB  => 'at0013',
        IIC  => 'at0013',         # inferred as IIC === IIB

        III     => 'at0004',
        IIIA    => 'at0021',
        IIIAi   => 'at0014',
        IIIAii  => 'at0015',
        IIIA1   => 'at0025',
        IIIA1i  => 'at0025',      # inferred as IIIA1i === IIIA1
        IIIA1ii => 'at0025',      # inferred as IIIA1ii === IIIA1
        IIIA2   => 'at0016',
        IIIB    => 'at0017',
        IIIC    => 'at0018',
        IIIC1   => 'at0022',
        IIIC2   => 'at0023',

        IV  => 'at0006',
        IVA => 'at0019',
        IVB => 'at0020',

    };
    $self->code( $figo_codes->{ $self->local_code } );
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
                '|value'       => lc( $self->local_code ),
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
                    'value'         => lc( $self->local_code ),
                    'defining_code' => {
                        'code_string'    => $self->code,
                        '@class'         => 'CODE_PHRASE',
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => $self->terminology,
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
                    'value'  => $self->version,
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
    my $self = shift;
    my $path = 'gel_cancer_diagnosis/problem_diagnosis:__TEST__/'
      . 'final_figo_stage:__DIAG__/';
    my $composition = {
        $path . 'figo_grade|code'        => $self->code,
        $path . 'figo_grade|value'       => lc( $self->local_code ),
        $path . 'figo_version'           => $self->version,
        $path . 'figo_grade|terminology' => $self->terminology,
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
The Final Figo Staging system is used for classifying cervical cancer.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 local_code($local_code)

Used to get or set the Final Figo Stage local_code

=head2 code($code)

Used to get or set the Final Figo Stage code. Normally, 
this value is derived from the local_code attribute.

=head2 terminology($terminology)

Used to get or set the Final Figo Stage terminology.
Defaults to 'local'

=head2 version($version)

Used to get or set the Final Figo Stage version.
Defaults to 'indeterminate'

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format

=head1 PRIVATE METHODS

=head2 _get_figo_code

Private method to derive the Figo Code from the local_code parameter provided

=cut

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
