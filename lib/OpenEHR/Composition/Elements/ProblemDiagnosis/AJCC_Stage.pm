package OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'AJCC_Code' => [
    '1',  '1a', '1b', '2',  '2a', '2b', '2c', '3',  '3a', '3b',
    '3c', '4',  '1A', '1B', '2A', '2B', '2C', '3A', '3B', '3C',
];

has local_code => (
    is  => 'rw',
    isa => 'AJCC_Code',
);

has ajcc_stage_grouping => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_get_ajcc_stage_group',
);
has version => (
    is      => 'rw',
    isa     => 'Str',
    default => 'indeterminate',    #'AJCC Stage version 55',
);

=head2 _get_ajcc_stage_group

Private method to return the correct ajcc_stage_grouping based on the provided local_code

=cut 

sub _get_ajcc_stage_group {
    my $self       = shift;
    my $ajcc_codes = {
        '1'  => 'Stage l',
        '2'  => 'Stage II',
        '3'  => 'Stage III',
        '4'  => 'Stage 4',
        '1a' => 'Stage IA',
        '1b' => 'Stage IB',
        '2a' => 'Stage IIA',
        '2b' => 'Stage IIB',
        '2c' => 'Stage IIC',
        '3a' => 'Stage IIIA',
        '3b' => 'Stage IIIB',
        '3c' => 'Stage IIIC',
        '1A' => 'Stage IA',
        '1B' => 'Stage IB',
        '2A' => 'Stage IIA',
        '2B' => 'Stage IIB',
        '2C' => 'Stage IIC',
        '3A' => 'Stage IIIA',
        '3B' => 'Stage IIIB',
        '3C' => 'Stage IIIC',
    };
    $self->ajcc_stage_grouping( $ajcc_codes->{ $self->local_code } );
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
        ajcc_stage_version  => [ $self->version ],
        ajcc_stage_grouping => [ $self->ajcc_stage_grouping ],
    };
    return $composition;
}

sub compose_raw {
    my $self = shift;
    print Dumper;
    my $composition = {
        '@class'            => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
        'items'             => [
            {
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0007',
                'value'             => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->ajcc_stage_grouping,
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'AJCC Stage grouping'
                }
            },
            {
                'archetype_node_id' => 'at0017',
                '@class'            => 'ELEMENT',
                'name'              => {
                    'value'  => 'AJCC Stage version',
                    '@class' => 'DV_TEXT'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->version,
                }
            }
        ],
        'name' => {
            'value'  => 'AJCC stage',
            '@class' => 'DV_TEXT'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
            },
            'rm_version' => '1.0.1'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path =
      'gel_cancer_diagnosis/problem_diagnosis:__TEST__/ajcc_stage:__AJCC__/';
    my $composition = {
        $path . 'ajcc_stage_version'  => $self->version,
        $path . 'ajcc_stage_grouping' => $self->ajcc_stage_grouping,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a AJCC (American Joint Committee on Cancer) Staging element 
for adding to a Problem Diagnosis composition object. 
The AJCC Staging system is used for classifying the extent of a cancer.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 ajcc_stage_grouping

The AJCC Stage grouping. Must be one of the following: 
    'Stage l', 'Stage IA', 'Stage IB', 'Stage ll', 'Stage IIA',
    'Stage IIB', 'Stage IIC', 'Stage III', 'Stage IIIA', 'Stage IIIB',
    'Stage IIIC', 'Stage 4' 

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

OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage requires no configuration files or 
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
