package OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

=head1 tumour_laterality($tumour_laterality_object)

Used to get or set the Tumour Laterality item of the Cancer Diagnosis item

=cut

has tumour_laterality => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::TumourLaterality]',
);

=head1 metastatic_site($metastatic_site_object)

Used to get or set the Metastatic Site item of the Cancer Diagnosis item

=cut

has metastatic_site => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite]',
);

=head1 recurrence_indicator($recurrence_indicator_object)

Used to get or set the Metastatic Site item of the Cancer Diagnosis item

=cut

has recurrence_indicator => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::RecurrenceIndicator]',
);

=head1 morphology($morphology)

Used to get or set the Morphology item of the Cancer Diagnosis item

=cut

has morphology => (
    is  => 'rw',
    isa => 'Str',
);

=head1 topography($topography)

Used to get or set the Topography item of the Cancer Diagnosis item

=cut

has topography => (
    is  => 'rw',
    isa => 'Str',
);

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    my @properties = qw(metastatic_site recurrence_indicator tumour_laterality);

    for my $property (@properties) {
        if ($self->$property) {
            for my $compos ( @{ $self->$property } ) {
                $compos->composition_format($self->composition_format);
            }
        }
    }

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'morphology'           => [$self->morphology],
        'topography'           => [$self->topography],
    };
    if ( $self->recurrence_indicator ) {
        for my $recurrence_indicator ( @{ $self->recurrence_indicator } ) {
            push @{ $composition->{'recurrence_indicator'} },
                $recurrence_indicator->compose;
        }
    }
    if ( $self->metastatic_site ) {
        for my $metastatic_site ( @{ $self->metastatic_site } ) {
            push @{ $composition->{'metastatic_site'} },
                $metastatic_site->compose;
        }
    }
    if ( $self->tumour_laterality ) {
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            push @{ $composition->{'tumour_laterality'} },
                $tumour_laterality->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        '@class'            => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
        'name'              => {
            'value'  => 'Cancer diagnosis',
            '@class' => 'DV_TEXT'
        },
        'items' => [
            {   'value' => {
                    'value'  => $self->morphology, #'Morphology 46',
                    '@class' => 'DV_TEXT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Morphology'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0001'
            },
            {   'archetype_node_id' => 'at0002',
                '@class'            => 'ELEMENT',
                'name'              => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Topography'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->topography, #'Topography 75'
                }
            },
        ],
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            'rm_version' => '1.0.1'
        }
    };
    if ( $self->recurrence_indicator ) {
        for my $recurrence_indicator ( @{ $self->recurrence_indicator } ) {
            push @{ $composition->{items} },
                $recurrence_indicator->compose;
        }
    }
    if ( $self->metastatic_site ) {
        for my $metastatic_site ( @{ $self->metastatic_site } ) {
            push @{ $composition->{items} },
                $metastatic_site->compose;
        }
    }
    if ( $self->tumour_laterality ) {
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            push @{ $composition->{items} },
                $tumour_laterality->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {

        # Cancer Diagnosis
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/morphology:0'
            => $self->morphology, #'Morphology 46',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis:__DIAG__/topography'
            => $self->topography, #'Topography 75',
    };
    if ( $self->recurrence_indicator ) {
        my $recurrence_indicator_index = '0';
        my $recurrence_indicator_comp;
        for my $recurrence_indicator ( @{ $self->recurrence_indicator } ) {
            my $composition_fragment = $recurrence_indicator->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$recurrence_indicator_index/;
                $recurrence_indicator_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $recurrence_indicator_index++;
            $composition = { ( %$composition, %{$recurrence_indicator_comp} ) };
        }
    }
    if ( $self->metastatic_site ) {
        my $metastatic_site_index = '0';
        my $metastatic_site_comp;
        for my $metastatic_site ( @{ $self->metastatic_site } ) {
            my $composition_fragment = $metastatic_site->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$metastatic_site_index/;
                $metastatic_site_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $metastatic_site_index++;
            $composition = { ( %$composition, %{$metastatic_site_comp} ) };
        }
    }
    if ( $self->tumour_laterality ) {
        my $tumour_laterality_index = '0';
        my $tumour_laterality_comp;
        for my $tumour_laterality ( @{ $self->tumour_laterality } ) {
            my $composition_fragment = $tumour_laterality->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$tumour_laterality_index/;
                $tumour_laterality_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $tumour_laterality_index++;
            $composition = { ( %$composition, %{$tumour_laterality_comp} ) };
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a template element for adding to a Problem Diagnosis composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

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

OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis requires no configuration files or 
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
