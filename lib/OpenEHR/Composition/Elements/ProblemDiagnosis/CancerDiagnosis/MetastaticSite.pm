package OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

enum 'MetastaticCode' => [ '02', '03', '04', '06', '07', '08', '09', '10', '11', '99' ];

has code => (
    is  => 'rw',
    isa => 'Str',
    lazy => 1,
    builder => '_build_code',
);
has value => (
    is  => 'rw',
    isa => 'Str',
    lazy => 1,
    builder => '_build_value',
);
has terminology => (
    is  => 'rw',
    isa => 'Str',
    default => 'local',
);
has local_code => (
    is => 'rw',
    isa => 'MetastaticCode',
);

=head2 _build_code

Sets the Metastatic Site code based on the provided local code

=cut

sub _build_code {
    my $self = shift;
    my $metastatic_site = {
        '02' => 'at0018', 
        '03' => 'at0019', 
        '04' => 'at0020', 
        '06' => 'at0021', 
        '07' => 'at0022', 
        '08' => 'at0023', 
        '09' => 'at0024', 
        '10' => 'at0025', 
        '11' => 'at0026', 
        '99' => 'at0027',
    };
    $self->code( $metastatic_site->{ $self->local_code} );
}

=head2 _build_value

Sets the Metastatic Site value based on the provided local code

=cut

sub _build_value {
    my $self = shift;
    my $metastatic_site = {
        '02' => 'Metastatic disease is located in the brain.', 
        '03' => 'Metastatic disease is located in the liver.', 
        '04' => 'Metastatic disease is located in the lung.', 
        '06' => 'Metastatic disease is located in multiple sites.', 
        '07' => 'The site of metastatic disease is unknown.', 
        '08' => 'Metastatic disease is located in the skin', 
        '09' => 'Metastatic disease is located in distant lymph nodes', 
        '10' => 'Metastatic disease is located in the bone excluding bone marrow', 
        '11' => 'Metastatic disease is located in the bone marrow', 
        '99' => 'Metastatic disease is located in another site',
    };
    $self->value( $metastatic_site->{ $self->local_code } );
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
                    'value'         => $self->local_code, #'08 Skin',
                    'defining_code' => {
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => $self->terminology, #'local'
                        },
                        'code_string' => $self->code, #'at0023',
                        '@class'      => 'CODE_PHRASE'
                    }
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Metastatic site'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0017'
            };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site:__DIAG2__|terminology'
            => $self->terminology, #'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site:__DIAG2__|code'
            => $self->code, #'at0023',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/metastatic_site:__DIAG2__|value'
            => $self->local_code, #'08 Skin',
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a Metastatic Site element for adding to a Cancer Diagnosis Problem Diagnosis item. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head2 code($code)

Used to get or set the Metastatic Site code

=head2 value($value)

Used to get or set the Metastatic Site value

=head2 terminology($terminology)

Used to get or set the Metastatic Site terminology

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

OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite requires no configuration files or 
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
