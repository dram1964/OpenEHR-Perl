package OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'PancCode' => [
    qw( 10 20 30 31 32 ),
];

has code => (
    is  => 'rw',
    isa => 'Str',
    lazy    => 1,
    builder => '_get_panc_code',
);
has value => (
    is  => 'rw',
    isa => 'Str',
    lazy    => 1,
    builder => '_get_panc_value',
);
has local_code => (
    is => 'rw',
    isa => 'PancCode',
);
has terminology => (
    is  => 'rw',
    isa => 'Str',
    default => 'local',
);

=head2 _get_panc_code

Private method to derive the Pancreatic Cancer Code from the local code parameter provided

=cut

sub _get_panc_code {
    my $self       = shift;
    my $panc_scores = {
        10 => 'at0009',
        20 => 'at0010',
        30 => 'at0011', 
        31 => 'at0012',
        32 => 'at0013',
    };
    $self->code( $panc_scores->{ $self->local_code } );
}

=head2 _get_panc_value

Private method to derive the Pancreatic Cancer Value from the local value parameter provided

=cut

sub _get_panc_value {
    my $self       = shift;
    my $panc_scores = {
        10 => 'Stage is deemed to be localised and resectable.',
        20 => 'Stage is deemed to be borderline resectable.',
        30 => 'Stage is deemed to be unresectable (locally advanced or metastatic).', 
        31 => 'Stage is deemed to be unresectable (locally advanced).',
        32 => 'Stage is deemed to be unrectable (metastatic).',
    };
    $self->value( $panc_scores->{ $self->local_code } );
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
    my $composition = [
        {   '|code'        => $self->code,          #'at0009'
            '|value'       => $self->value,
            '|terminology' => $self->terminology,
        }
    ];
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        '@class'            => 'ELEMENT',
        'archetype_node_id' => 'at0008',
        'value'             => {
            '@class'        => 'DV_CODED_TEXT',
            'defining_code' => {
                'code_string'    => $self->code,     #'at0012',
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => $self->terminology,    #'local'
                }
            },
            'value' => $self->value,    #'31 Unresectable locally advanced'
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Pancreatic clinical stage'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage:__DIAG2__|value'
            => $self->value,    #'31 Unresectable locally advanced',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage:__DIAG2__|terminology'
            => $self->terminology,    #'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/pancreatic_clinical_stage:__DIAG2__|code'
            => $self->code,           #'at0012',
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Pancreatic Clinical Stage element for adding to a Upper GI Problem Diagnosis item. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 code($code)

Used to get or set the Pancreatic Clinical Stage code

=head2 value($value)

Used to get or set the Pancreatic Clinical Stage value

=head2 terminology($terminology)

Used to get or set the Pancreatic Clinical Stage terminology

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

OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage requires no configuration files or 
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
