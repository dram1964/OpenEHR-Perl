package OpenEHR::Composition::ProblemDiagnosis::UpperGI;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

=head2 bclc_stage($bclc_stage_obj)

Used to get or set the BCLC Stage item in an Upper GI Staging item

=cut 

has bclc_stage => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::BCLC_Stage]',
);

=head2 portal_invasion($portal_invasion_obj)

Used to get or set the Portal Invasion item in an Upper GI Staging item

=cut 

has portal_invasion => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::PortalInvasion]',
);

=head2 pancreatic_clinical_stage($pancreatic_clinical_stage_obj)

Used to get or set the Pancreatic Clinical Stage item in an Upper GI Staging item

=cut 

has pancreatic_clinical_stage => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::PancreaticClinicalStage]',
);

=head2 child_pugh_score($child_pugh_score_obj)

Used to get or set the Child-Pugh Score item in an Upper GI Staging item

=cut 

has child_pugh_score => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::ChildPughScore]',
);

=head2 tace($tace_obj)

Used to get or set the Transarterial Chemoembolisation (TACE) item in an Upper GI Staging item

=cut 

has tace => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI::TACE]',
);

=head2 lesions($lesions)

Used to get or set the number of lesions item in an Upper GI Staging item

=cut 

has lesions => (
    is  => 'rw',
    isa => 'Str',
);

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'number_of_lesions' => [$self->lesions],
    };
    if ( $self->tace ) {
        for my $tace ( @{ $self->tace } ) {
            push @{ $composition->{'transarterial_chemoembolisation'} },
                $tace->compose;
        }
    }
    if ( $self->child_pugh_score ) {
        for my $child_pugh_score ( @{ $self->child_pugh_score } ) {
            push @{ $composition->{'child-pugh_score'} },
                $child_pugh_score->compose;
        }
    }
    if ( $self->pancreatic_clinical_stage ) {
        for my $pancreatic_clinical_stage ( @{ $self->pancreatic_clinical_stage } ) {
            push @{ $composition->{pancreatic_clinical_stage} },
                $pancreatic_clinical_stage->compose;
        }
    }
    if ( $self->portal_invasion ) {
        for my $portal_invasion ( @{ $self->portal_invasion } ) {
            push @{ $composition->{portal_invasion} },
                $portal_invasion->compose;
        }
    }
    if ( $self->bclc_stage ) {
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            push @{ $composition->{bclc_stage} },
                $bclc_stage->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
        '@class'            => 'CLUSTER',
        'name'              => {
            '@class' => 'DV_TEXT',
            'value'  => 'Upper GI staging'
        },
        'items' => [
            {   '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0007',
                'value'             => {
                    'magnitude' => $self->lesions,
                    '@class'    => 'DV_COUNT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Number of lesions'
                }
            },
        ],
        'archetype_details' => {
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
            },
            'rm_version' => '1.0.1',
            '@class'     => 'ARCHETYPED'
        }
    };
    if ( $self->tace ) {
        for my $tace ( @{ $self->tace } ) {
            push @{ $composition->{items} },
                $tace->compose;
        }
    }
    if ( $self->child_pugh_score ) {
        for my $child_pugh_score ( @{ $self->child_pugh_score } ) {
            push @{ $composition->{items} },
                $child_pugh_score->compose;
        }
    }
    if ( $self->pancreatic_clinical_stage ) {
        for my $pancreatic_clinical_stage ( @{ $self->pancreatic_clinical_stage } ) {
            push @{ $composition->{items} },
                $pancreatic_clinical_stage->compose;
        }
    }
    if ( $self->portal_invasion ) {
        for my $portal_invasion ( @{ $self->portal_invasion } ) {
            push @{ $composition->{items} },
                $portal_invasion->compose;
        }
    }
    if ( $self->bclc_stage ) {
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            push @{ $composition->{items} },
                $bclc_stage->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging:__DIAG__/number_of_lesions'
            => $self->lesions,
    };
    if ( $self->tace ) {
        my $tace_index = '0';
        my $tace_comp;
        for my $tace ( @{ $self->tace } ) {
            my $composition_fragment = $tace->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$tace_index/;
                $tace_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $tace_index++;
            $composition = { ( %$composition, %{$tace_comp} ) };
        }
    }
    if ( $self->child_pugh_score ) {
        my $child_pugh_score_index = '0';
        my $child_pugh_score_comp;
        for my $child_pugh_score ( @{ $self->child_pugh_score } ) {
            my $composition_fragment = $child_pugh_score->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$child_pugh_score_index/;
                $child_pugh_score_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $child_pugh_score_index++;
            $composition = { ( %$composition, %{$child_pugh_score_comp} ) };
        }
    }
    if ( $self->pancreatic_clinical_stage ) {
        my $pancreatic_clinical_stage_index = '0';
        my $pancreatic_clinical_stage_comp;
        for my $pancreatic_clinical_stage ( @{ $self->pancreatic_clinical_stage } ) {
            my $composition_fragment = $pancreatic_clinical_stage->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$pancreatic_clinical_stage_index/;
                $pancreatic_clinical_stage_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $pancreatic_clinical_stage_index++;
            $composition = { ( %$composition, %{$pancreatic_clinical_stage_comp} ) };
        }
    }
    if ( $self->portal_invasion ) {
        my $portal_invasion_index = '0';
        my $portal_invasion_comp;
        for my $portal_invasion ( @{ $self->portal_invasion } ) {
            my $composition_fragment = $portal_invasion->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$portal_invasion_index/;
                $portal_invasion_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $portal_invasion_index++;
            $composition = { ( %$composition, %{$portal_invasion_comp} ) };
        }
    }
    if ( $self->bclc_stage ) {
        my $bclc_stage_index = '0';
        my $bclc_stage_comp;
        for my $bclc_stage ( @{ $self->bclc_stage } ) {
            my $composition_fragment = $bclc_stage->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG2__/$bclc_stage_index/;
                $bclc_stage_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $bclc_stage_index++;
            $composition = { ( %$composition, %{$bclc_stage_comp} ) };
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::ProblemDiagnosis::UpperGI - composition element


=head1 VERSION

This document describes OpenEHR::Composition::ProblemDiagnosis::UpperGI version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::ProblemDiagnosis::UpperGI;
    my $template = OpenEHR::Composition::ProblemDiagnosis::UpperGI->new(
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

OpenEHR::Composition::ProblemDiagnosis::UpperGI requires no configuration files or 
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
