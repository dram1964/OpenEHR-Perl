package OpenEHR::Composition::Elements::ImagingExam;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition::Elements';

__PACKAGE__->load_namespaces;

use version; our $VERSION = qv('0.0.2');

has reports => (
    is => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ImagingExam::ImagingReport]',
);

has request_details => (
    is => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ImagingExam::RequestDetail]',
);

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    my @properties = qw( reports request_details );
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
        'event_date'         => [ DateTime->now->datetime ],
    };
    if ( $self->testicular_staging ) {
        for my $testicular_staging ( @{ $self->testicular_staging } ) {
            push @{ $composition->{testicular_staging} },
                $testicular_staging->compose;
        }
    }
    if ( $self->final_figo_stage ) {
        for my $final_figo_stage ( @{ $self->final_figo_stage } ) {
            push @{ $composition->{final_figo_stage} },
                $final_figo_stage->compose;
        }
    }
    if ( $self->cancer_diagnosis ) {
        for my $cancer_diagnosis ( @{ $self->cancer_diagnosis } ) {
            push @{ $composition->{cancer_diagnosis} },
                $cancer_diagnosis->compose;
        }
    }
    if ( $self->inrg_staging ) {
        for my $inrg_staging ( @{ $self->inrg_staging } ) {
            push @{ $composition->{inrg_staging} },
                $inrg_staging->compose;
        }
    }
    if ( $self->upper_gi_staging ) {
        for my $upper_gi_staging ( @{ $self->upper_gi_staging } ) {
            push @{ $composition->{upper_gi_staging} },
                $upper_gi_staging->compose;
        }
    }
    if ( $self->clinical_evidence ) {
        for my $clinical_evidence ( @{ $self->clinical_evidence } ) {
            push @{ $composition->{clinical_evidence} },
                $clinical_evidence->compose;
        }
    }
    if ( $self->tumour_id ) {
        for my $tumour_id ( @{ $self->tumour_id } ) {
            push @{ $composition->{tumour_id} }, $tumour_id->compose;
        }
    }
    if ( $self->modified_dukes ) {
        for my $modified_dukes ( @{ $self->modified_dukes } ) {
            push @{ $composition->{modified_dukes_stage} },
                $modified_dukes->compose;
        }
    }
    if ( $self->colorectal_diagnosis ) {
        for my $colorectal_diagnosis ( @{ $self->colorectal_diagnosis } ) {
            push @{ $composition->{colorectal_diagnosis} },
                $colorectal_diagnosis->compose;
        }
    }
    if ( $self->diagnosis ) {
        for my $diagnosis ( @{ $self->diagnosis } ) {
            push @{ $composition->{diagnosis} }, $diagnosis->compose;
        }
    }
    if ( $self->ajcc_stage ) {
        for my $ajcc_stage ( @{ $self->ajcc_stage } ) {
            push @{ $composition->{ajcc_stage} }, $ajcc_stage->compose;
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
        'data'              => {
            'name' => {
                'value'  => 'structure',
                '@class' => 'DV_TEXT'
            },
            'items' => [

            ],
            '@class'            => 'ITEM_TREE',
            'archetype_node_id' => 'at0001'
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Problem/Diagnosis'
        },
        'archetype_details' => {
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
                '@class' => 'ARCHETYPE_ID'
            },
            '@class' => 'ARCHETYPED'
        },
        'protocol' => {
            'archetype_node_id' => 'at0032',
            '@class'            => 'ITEM_TREE',
            'items'             => [
                {   '@class'            => 'ELEMENT',
                    'archetype_node_id' => 'at0070',
                    'value'             => {
                        '@class' => 'DV_DATE_TIME',
                        'value'  => DateTime->now->datetime, #'2018-07-24T14:05:01.806+01:00'
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Event date'
                    }
                }
            ],
            'name' => {
                'value'  => 'Tree',
                '@class' => 'DV_TEXT'
            }
        },
        'language' => {
            'code_string'    => 'en',
            '@class'         => 'CODE_PHRASE',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => 'ISO_639-1'
            }
        },
        'encoding' => {
            'terminology_id' => {
                'value'  => 'IANA_character-sets',
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => 'UTF-8',
            '@class'      => 'CODE_PHRASE'
        },
        '@class'  => 'EVALUATION',
        'subject' => { '@class' => 'PARTY_SELF' }
    };

    if ( $self->testicular_staging ) {
        for my $testicular_staging ( @{ $self->testicular_staging } ) {
            push @{ $composition->{data}->{items} },
                $testicular_staging->compose;
        }
    }
    if ( $self->final_figo_stage ) {
        for my $final_figo_stage ( @{ $self->final_figo_stage } ) {
            push @{ $composition->{data}->{items} },
                $final_figo_stage->compose;
        }
    }
    if ( $self->cancer_diagnosis ) {
        for my $cancer_diagnosis ( @{ $self->cancer_diagnosis } ) {
            push @{ $composition->{data}->{items} },
                $cancer_diagnosis->compose;
        }
    }
    if ( $self->inrg_staging ) {
        for my $inrg_staging ( @{ $self->inrg_staging } ) {
            push @{ $composition->{data}->{items} },
                $inrg_staging->compose;
        }
    }
    if ( $self->integrated_tnm ) {
        for my $integrated_tnm ( @{ $self->integrated_tnm } ) {
            push @{ $composition->{data}->{items} },
                $integrated_tnm->compose;
        }
    }
    if ( $self->upper_gi_staging ) {
        for my $upper_gi_staging ( @{ $self->upper_gi_staging } ) {
            push @{ $composition->{data}->{items} },
                $upper_gi_staging->compose;
        }
    }
    if ( $self->clinical_evidence ) {
        for my $clinical_evidence ( @{ $self->clinical_evidence } ) {
            push @{ $composition->{data}->{items} },
                $clinical_evidence->compose;
        }
    }
    if ( $self->tumour_id ) {
        for my $tumour_id ( @{ $self->tumour_id } ) {
            push @{ $composition->{data}->{items} }, $tumour_id->compose;
        }
    }
    if ( $self->modified_dukes ) {
        for my $modified_dukes ( @{ $self->modified_dukes } ) {
            push @{ $composition->{data}->{items} }, $modified_dukes->compose;
        }
    }
    if ( $self->colorectal_diagnosis ) {
        for my $colorectal_diagnosis ( @{ $self->colorectal_diagnosis } ) {
            push @{ $composition->{data}->{items} },
                $colorectal_diagnosis->compose;
        }
    }
    if ( $self->diagnosis ) {
        for my $diagnosis ( @{ $self->diagnosis } ) {
            push @{ $composition->{data}->{items} }, $diagnosis->compose;
        }
    }
    if ( $self->ajcc_stage ) {
        for my $ajcc ( @{ $self->ajcc_stage } ) {
            push @{ $composition->{data}->{items} }, $ajcc->compose;
        }
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {};

    if ( $self->request_details ) {
        my $request_details_index = '0';
        my $request_details_comp;
        for my $request_details ( @{ $self->request_details } ) {
            my $composition_fragment = $request_details->compose();
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__REQ__/$request_details_index/;
                $request_details_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $request_details_index++;
            $composition = { ( %$composition, %{$request_details_comp} ) };
        }
    }
    if ( $self->reports ) {
        my $reports_index = '0';
        my $reports_comp;
        for my $reports ( @{ $self->reports } ) {
            my $composition_fragment = $reports->compose();
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__REP__/$reports_index/;
                $reports_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $reports_index++;
            $composition = { ( %$composition, %{$reports_comp} ) };
        }
    }


    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ImagingExam - Imaging Exam composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ImagingExam version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ImagingExam;
    my $diagnosis = OpenEHR::Composition::Elements::ImagingExam->new(
    );
    my $diagnosis_hash = $diagnosis->compose();


  
=head1 DESCRIPTION

Used to create a hashref element of an problem diagnosis 
composition object. 

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

OpenEHR::Composition::Elements::ImagingExam requires no configuration files or 
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
