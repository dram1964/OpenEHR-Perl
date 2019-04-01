package OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'TaceCode' => [
    qw( Y N 9 ),
];

has code => (
    is  => 'rw',
    isa => 'Str',
    lazy    => 1,
    builder => '_get_tace_code',
);
has value => (
    is  => 'rw',
    isa => 'Str',
    lazy    => 1,
    builder => '_get_tace_value',
);
has local_code => (
    is => 'rw',
    isa => 'TaceCode',
);
has terminology => (
    is  => 'rw',
    isa => 'Str',
    default => 'local',
);

=head2 _get_tace_code

Private method to derive the TACE Code from the local code parameter provided

=cut

sub _get_tace_code {
    my $self       = shift;
    my $tace_scores = {
        Y => 'at0015',
        N => 'at0016',
        9 => 'at0017',
    };
    $self->code( $tace_scores->{ $self->local_code } );
}

=head2 _get_tace_value

Private method to derive the Pugh Score Value from the local value parameter provided

=cut

sub _get_tace_value {
    my $self       = shift;
    my $tace_scores = {
        Y => 'Transarterial chemoembolisation is deemed to be present.',
        N => 'Transarterial chemoembolisation is not deemed to be present.',
        9 => 'It is not known whether transarterial chemoembolistion is present.',
    };
    $self->value( $tace_scores->{ $self->local_code } );
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
        '|code' => $self->code,
        '|value' => $self->local_code,
        '|terminology' => $self->terminology,
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
               'value' => {
                    'value'         => $self->local_code, #'Y Yes',
                    'defining_code' => {
                        'terminology_id' => {
                            'value'  => $self->terminology, #'local',
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => $self->code, #'at0015'
                    },
                    '@class' => 'DV_CODED_TEXT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Transarterial chemoembolisation'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0014'
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation:__DIAG2__|terminology'
            => $self->terminology, #'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation:__DIAG2__|value'
            => $self->local_code, #'Y Yes',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/transarterial_chemoembolisation:__DIAG2__|code'
            => $self->code, #'at0015',
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Transarterial Chemoembolisation (TACE) element for adding to a Upper GI Problem Diagnosis item. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 code($code)

Used to get or set the TACE code

=head2 value($value)

Used to get or set the TACE value

=head2 terminology($terminology)

Used to get or set the TACE terminology

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

OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE requires no configuration files or 
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
