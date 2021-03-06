package OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has extranodal_metastases => (
    is => 'rw',
    isa =>
'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::ExtranodalMetastases]',
);

has lung_metastases => (
    is => 'rw',
    isa =>
'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::LungMetastases]',
);

has stage_group_testicular => (
    is => 'rw',
    isa =>
'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular]',
);

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );
    my @properties =
      qw(extranodal_metastases lung_metastases stage_group_testicular);

    for my $property (@properties) {
        if ( $self->$property ) {
            for my $compos ( @{ $self->$property } ) {
                $compos->composition_format( $self->composition_format );
            }
        }
    }

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {};
    if ( $self->extranodal_metastases ) {
        for my $extranodal_metastases ( @{ $self->extranodal_metastases } ) {
            push @{ $composition->{'extranodal_metastases'} },
              $extranodal_metastases->compose;
        }
    }
    if ( $self->stage_group_testicular ) {
        for my $stage_group_testicular ( @{ $self->stage_group_testicular } ) {
            push @{ $composition->{'stage_grouping_testicular'} },
              $stage_group_testicular->compose;
        }
    }
    if ( $self->lung_metastases ) {
        for my $lung_metastases ( @{ $self->lung_metastases } ) {
            push @{ $composition->{'lung_metastases_sub-stage_grouping'} },
              $lung_metastases->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'items' => [],
        'name'  => {
            '@class' => 'DV_TEXT',
            'value'  => 'Testicular staging'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            'rm_version' => '1.0.1'
        },
        '@class'            => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.testicular_staging_gel.v0'
    };
    if ( $self->extranodal_metastases ) {
        for my $extranodal_metastases ( @{ $self->extranodal_metastases } ) {
            push @{ $composition->{items} }, $extranodal_metastases->compose;
        }
    }
    if ( $self->stage_group_testicular ) {
        for my $stage_group_testicular ( @{ $self->stage_group_testicular } ) {
            push @{ $composition->{items} }, $stage_group_testicular->compose;
        }
    }
    if ( $self->lung_metastases ) {
        for my $lung_metastases ( @{ $self->lung_metastases } ) {
            push @{ $composition->{items} }, $lung_metastases->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {};
    if ( $self->extranodal_metastases ) {
        my $extranodal_metastases_index = '0';
        my $extranodal_metastases_comp;
        for my $extranodal_metastases ( @{ $self->extranodal_metastases } ) {
            my $composition_fragment = $extranodal_metastases->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$extranodal_metastases_index/;
                $extranodal_metastases_comp->{$new_key} =
                  $composition_fragment->{$key};
            }
            $extranodal_metastases_index++;
            $composition =
              { ( %$composition, %{$extranodal_metastases_comp} ) };
        }
    }
    if ( $self->stage_group_testicular ) {
        my $stage_group_testicular_index = '0';
        my $stage_group_testicular_comp;
        for my $stage_group_testicular ( @{ $self->stage_group_testicular } ) {
            my $composition_fragment = $stage_group_testicular->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$stage_group_testicular_index/;
                $stage_group_testicular_comp->{$new_key} =
                  $composition_fragment->{$key};
            }
            $stage_group_testicular_index++;
            $composition =
              { ( %$composition, %{$stage_group_testicular_comp} ) };
        }
    }
    if ( $self->lung_metastases ) {
        my $lung_metastases_index = '0';
        my $lung_metastases_comp;
        for my $lung_metastases ( @{ $self->lung_metastases } ) {
            my $composition_fragment = $lung_metastases->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$lung_metastases_index/;
                $lung_metastases_comp->{$new_key} =
                  $composition_fragment->{$key};
            }
            $lung_metastases_index++;
            $composition = { ( %$composition, %{$lung_metastases_comp} ) };
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a TesticularStaging element for adding to a Problem Diagnosis composition object. 

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

=head1 PRIVATE METHODS

=head1 extranodal_metastases($extranodal_metastases_object)

Used to get or set the Extranodal Metastases item of the Testicular Staging item

=cut

=head1 lung_metastases($lung_metastases_object)

Used to get or set the Lung Metastases item of the Testicular Staging item

=cut

=head1 stage_group_testicular($stage_grouping_testicular_object)

Used to get or set the Testicular Stage Grouping item of the Testicular Staging item

=cut

=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging requires no configuration files or 
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
