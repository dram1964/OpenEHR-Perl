package OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'Dukes_Code' => [qw( A B C1 C2 D 99)];

has code => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_get_dukes_code',
);
has value => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_get_dukes_value',
);
has terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => 'local',
);
has local_code => (
    is  => 'rw',
    isa => 'Dukes_Code',
);

sub _get_dukes_code {
    my $self        = shift;
    my $dukes_codes = {
        A  => 'at0002',
        B  => 'at0003',
        C1 => 'at0004',
        C2 => 'at0005',
        D  => 'at0006',
        99 => 'at0007',
    };
    $self->code( $dukes_codes->{ $self->local_code } );
}

sub _get_dukes_value {
    my $self         = shift;
    my $dukes_values = {
        A => 'Dukes A Tumour confined to wall of bowel, nodes negative.',
        B => 'Dukes B Tumour penetrates through the muscularis propia '
          . 'to involve extramural tissues, nodes negative.',
        C1 => 'Dukes C1 Metastases confined to regional lymph nodes '
          . '(node/s positive but apical node negative.',
        C2 => 'Dukes C2 Metastases present in nodes at mesenteric '
          . 'artery ligature (apical node positive).',
        D  => 'Dukes D Metastatic spread outside the operative field.',
        99 => 'Dukes stage is not known',
    };
    $self->value( $dukes_values->{ $self->local_code } );
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
        'modified_dukes_stage' => [
            {
                '|code'        => $self->code,
                '|value'       => $self->local_code,
                '|terminology' => $self->terminology,
            }
        ]
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
        '@class'            => 'CLUSTER',
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            'rm_version' => '1.0.1'
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Modified Dukes stage'
        },
        'items' => [
            {
                'value' => {
                    '@class'        => 'DV_CODED_TEXT',
                    'defining_code' => {
                        'code_string'    => $self->code,
                        '@class'         => 'CODE_PHRASE',
                        'terminology_id' => {
                            'value'  => $self->terminology,
                            '@class' => 'TERMINOLOGY_ID'
                        }
                    },
                    'value' => $self->local_code,
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Modified Dukes stage'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0001'
            }
        ]
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path = 'gel_cancer_diagnosis/problem_diagnosis:__TEST__/'
      . 'modified_dukes_stage:__DIAG__/modified_dukes_stage|';
    my $composition = {
        $path . 'value'       => $self->local_code,
        $path . 'terminology' => $self->terminology,
        $path . 'code'        => $self->code,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Dukes Staging element for adding to a Problem Diagnosis composition object. 
The Dukes Staging system is used for classifying colorectal cancer.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 local_code($local_code)

Used to get or set the local code

=head2 code($code)

Used to get or set the modified dukes stage code. Normally, 
this is derived from the local_code attribute.

=head2 value($value)

Used to get or set the modified dukes stage value. Normally, 
this is derived from the local_code attribute.


=head2 terminology($terminology)

Used to get or set the modified dukes stage terminology.
Defaults to 'indeterminate'

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

OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes requires no configuration files or 
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
