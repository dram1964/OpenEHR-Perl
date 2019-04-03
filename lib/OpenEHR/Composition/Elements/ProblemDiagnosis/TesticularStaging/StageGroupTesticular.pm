package OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'Group_Code' => [ qw( 1 1S 1M 2A 2B 2C 3A 3B 3C 4A 4B 4C ) ];

has code => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_code',
);
has value => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_value',
);
has terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => 'local',
);
has local_code => (
    is  => 'rw',
    isa => 'Group_Code',
);

sub _build_code {
    my $self       = shift;
    my $lung_codes = {
        '1' => 'at0002', 
        '1S' => 'at0003',
        '1M' => 'at0004',
        '2A' => 'at0005',
        '2B' => 'at0006',
        '2C' => 'at0007',
        '3A' => 'at0008',
        '3B' => 'at0009',
        '3C' => 'at0010',
        '4A' => 'at0011',
        '4B' => 'at0012',
        '4C' => 'at0013', 
    };
    $self->code( $lung_codes->{ $self->local_code } );
}

sub _build_value {
    my $self       = shift;
    my $lung_codes = {
        '1' => 'Stage 1', 
        '1S' => 'Stage 1S',
        '1M' => 'Stage 1M',
        '2A' => 'Stage 2A',
        '2B' => 'Stage 2B',
        '2C' => 'Stage 2C',
        '3A' => 'Stage 3A',
        '3B' => 'Stage 3B',
        '3C' => 'Stage 3C',
        '4A' => 'Stage 4A',
        '4B' => 'Stage 4B',
        '4C' => 'Stage 4C', 
    };
    $self->value( $lung_codes->{ $self->local_code } );
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
        '|code'        => $self->code,
        '|value'       => $self->local_code,
        '|terminology' => $self->terminology,
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'value'         => $self->local_code,
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => $self->terminology,
                                    },
                                    'code_string' => $self->code,
                                    '@class'      => 'CODE_PHRASE'
                                }
                            },
                            'name' => {
                                'value'  => 'Stage grouping testicular',
                                '@class' => 'DV_TEXT'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $path = 'gel_cancer_diagnosis/problem_diagnosis:__TEST__/' . 
        'testicular_staging:__DIAG__/stage_grouping_testicular:__DIAG2__|';
    my $composition = {
        $path . 'terminology' => $self->terminology,
        $path . 'code' => $self->code,
        $path . 'value' => $self->local_code,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Stage Group Testicular element for adding to Testicular Staging Problem Diagnosis composition object. 
Used for Urology (Testicular) cancers.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 local_code($local_code)

Used to get or set the local_code attribute

=head2 code($code)

Used to get or set the Stage Group Testicular code. Normally, 
this is derived from the local_code attribute

=head2 value($value)

Used to get or set the Stage Group Testicular value. Normally, 
this is derived from the local_code attribute

=head2 terminology($terminology)

Used to get or set the Stage Group Testicular terminology.
Defaults to 'local'

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

Private method to derive the Lung Metastatic Substage Code from the local code provided

=head2 _build_value

Private method to derive the Extranodal Code from the local code provided

=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular requires no configuration files or 
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
