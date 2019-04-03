package OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'BaseOfDiag' => [ qw( 0 1 2 4 5 6 7 9  ) ];

has code => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_code',
);

has terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => 'local',
);

has local_code => (
    is  => 'rw',
    isa => 'BaseOfDiag',
);

sub _build_code {
    my $self       = shift;
    my $diag_codes = {
        '0' => '0 Death Certificate',
        '1' => '1 Diagnosis made before death but without evidence',
        '2' => '2 Clinical investigation including all diagnostic techniques',
        '4' => '4 Specific tumour markers',
        '5' => '5 Cytology',
        '6' => '6 Histology of metastasis',
        '7' => '7 Histology of primary tumour',
        '9' => '9 Unknown',
    };
    $self->code( $diag_codes->{ $self->local_code } );
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
    my $composition = { 'base_of_diagnosis' => [ $self->code ] };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.clinical_evidence.v1'
            }
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Clinical evidence'
        },
        'items' => [
            {
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->code,
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Base of diagnosis'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0003'
            }
        ],
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.clinical_evidence.v1',
        '@class'            => 'CLUSTER'
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = { 'gel_cancer_diagnosis/problem_diagnosis:__TEST__/'
          . 'clinical_evidence:__DIAG__/base_of_diagnosis' => $self->code, };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Clinical Evidence element for adding to a Problem Diagnosis composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 local_code

Used to get or set the local_code attribute

=head2 code

Used to get or set the code attribute. Normally, 
this is derived from the value of the local_code
attribute

=head2 terminology

Used to get or set the terminology attribute. 
Defaults to 'local'

=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format

=head1 PRIVATE METHODS

=head2 _build_code

Private method to derive the Basis of Diagnosis code from the local code provided

=cut

=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence requires no configuration files or 
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
