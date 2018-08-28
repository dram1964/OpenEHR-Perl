package OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has id => (
    is  => 'rw',
    isa => 'Str',
);

has assigner => (
    is  => 'rw',
    isa => 'Str',
);

has issuer => (
    is  => 'rw',
    isa => 'Str',
);

has type => (
    is  => 'rw',
    isa => 'Str',
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
        'tumour_identifier' => [
            {   '|type'     => $self->type,
                '|issuer'   => $self->issuer,
                '|id'       => $self->id,
                '|assigner' => $self->assigner,
            },
        ],
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'name' => {
            'value'  => 'Tumour ID',
            '@class' => 'DV_TEXT'
        },
        'items' => [
            {   'value' => {
                    'id'       => $self->id,
                    'issuer'   => $self->issuer,
                    '@class'   => 'DV_IDENTIFIER',
                    'assigner' => $self->assigner,
                    'type'     => $self->type,
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Tumour identifier'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0001'
            }
        ],
        'archetype_details' => {
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            'rm_version' => '1.0.1',
            '@class'     => 'ARCHETYPED'
        },
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
        '@class'            => 'CLUSTER'
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id:__DIAG__/tumour_identifier:0|issuer'
            => $self->issuer,
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id:__DIAG__/tumour_identifier:0'
            => $self->id,
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id:__DIAG__/tumour_identifier:0|assigner'
            => $self->assigner,
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id:__DIAG__/tumour_identifier:0|type'
            => $self->type,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a template element for adding to a Problem Diagnosis composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 id($id)

Used to get or set the tumour indicator id

=head2 assigner($assigner)

Used to get or set the tumour indicator assigner

=head2 issuer($issuer)

Used to get or set the tumour indicator issuer

=head2 type($type)

Used to get or set the tumour indicator type

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

OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID requires no configuration files or 
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
