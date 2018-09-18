package OpenEHR::Composition::Elements::ImagingExam::ImagingReport;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition::Elements';

use version; our $VERSION = qv('0.0.2');

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    my @properties = qw(
       
    );
    for my $property (@properties) {
        if ($self->$property) {
                $self->$property->composition_format($self->composition_format);
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
    if ( $self->requester ) {
        for my $requester ( @{ $self->requester } ) {
            push @{ $composition->{requester} },
                $requester->compose;
        }
    }
    if ( $self->receiver ) {
        for my $receiver ( @{ $self->receiver } ) {
            push @{ $composition->{receiver} },
                $receiver->compose;
        }
    }
    if ( $self->report_reference ) {
        for my $report_reference ( @{ $self->report_reference } ) {
            push @{ $composition->{report_reference} },
                $report_reference->compose;
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

    if ( $self->requester ) {
        for my $requester ( @{ $self->requester } ) {
            push @{ $composition->{data}->{items} },
                $requester->compose;
        }
    }
    if ( $self->receiver ) {
        for my $receiver ( @{ $self->receiver } ) {
            push @{ $composition->{data}->{items} },
                $receiver->compose;
        }
    }
    if ( $self->report_reference ) {
        for my $report_reference ( @{ $self->report_reference } ) {
            push @{ $composition->{data}->{items} },
                $report_reference->compose;
        }
    }
    return $composition;
}

=head2 clinical_info

Used to get or set clinical information for the Imaging Report element

=cut

has clinical_info => (
    is => 'rw',
    isa => 'Str',
);

=head2 comment

Used to get or set the comments for the Imaging Report element

=cut

has comment => (
    is => 'rw',
    isa => 'ArrayRef',
);

=head2 diagnosis

Used to get or set the diagnoses for the Imaging Report element

=cut

has diagnosis => (
    is => 'rw',
    isa => 'ArrayRef',
);

=head2 report_text

Used to get or set the report text for the Imaging Report element

=cut

has report_text => (
    is => 'rw',
    isa => 'Str',
);

=head2 findings

Used to get or set the report findings for the Imaging Report element

=cut

has findings => (
    is => 'rw',
    isa => 'Str',
);

=head2 modality

Used to get or set the report modality for the Imaging Report element

=cut

has modality => (
    is => 'rw',
    isa => 'Str',
);

=head2 anatomical_side

Used to get or set the anatomical_side for the Imaging Report element

=cut

has anatomical_side => (
    is => 'rw',
    isa => 'Str',
);

=head2 anatomical_site

Used to get or set the anatomical_site for the Imaging Report element

=cut

has anatomical_site => (
    is => 'rw',
    isa => 'ArrayRef',
);

=head2 result_date

Used to get or set the result_date for the Imaging Report element

=cut

has result_date => (
    is => 'rw',
    isa => 'Str',
);

=head2 result_status

Used to get or set the result_status for the Imaging Report element

=cut

has result_status => (
    is => 'rw',
    isa => 'Str',
);

=head2 imaging_code

Used to get or set the imaging_code for the Imaging Report element

=cut

has imaging_code => (
    is => 'rw',
    isa => 'Str',
);

=head2 image_file

Used to get or set the image file reference for the Imaging Report element

=cut

has image_file => (
    is => 'rw',
    isa => 'ArrayRef',
);


sub compose_flat {
    my $self        = shift;
    my $path = 'radiology_result_report/imaging_examination_result:__EXAM__/any_event:__REP__/';
    my $composition =  {
        $path . 'clinical_information_provided' => $self->clinical_info, #'Clinical information provided 50',
        $path . 'imaging_report_text' => $self->report_text, #'Imaging report text 62',
        $path . 'findings' => $self->findings, #'Findings 69',
        $path . 'modality' => $self->modality, #'Modality 39',
        $path . 'anatomical_side/anatomical_side|code' => $self->anatomical_side, #'at0007',
        $path . 'datetime_result_issued' => $self->result_date, #'2018-09-14T12:45:54.769+01:00',
        $path . 'imaging_code' => $self->imaging_code, #'Imaging code 87',
        $path . 'overall_result_status|code' => $self->result_status, #'at0009',
    };
    if ( $self->comment ) {
        my $index = '0';
        for my $comment ( @{ $self->comment } ) {
            my $comment_key = $path . 'comment:' . $index;
            $composition->{$comment_key} = $comment;
            $index++;
        }
    }
    if ( $self->diagnosis ) {
        my $index = '0';
        for my $diagnosis ( @{ $self->diagnosis } ) {
            my $diagnosis_key = $path. 'imaging_diagnosis:' . $index;
            $composition->{$diagnosis_key} = $diagnosis;
            $index++;
        }
    }
    if ( $self->anatomical_site ) {
        my $index = '0';
        for my $anatomical_site ( @{ $self->anatomical_site } ) {
            my $anatomical_site_key = $path . 'anatomical_location:' . $index . '/anatomical_site'; #'Anatomical site 3',
            $composition->{$anatomical_site_key} = $anatomical_site;
            $index++;
        }
    }
    if ( $self->image_file ) {
        my $index = '0';
        for my $image_file ( @{ $self->image_file } ) {
            my $image_file_key = $path . 'multimedia_resource:' . $index . '/image_file_reference'; #'Image file reference 97',
            $composition->{$image_file_key} = $image_file;
            $index++;
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ImagingExam::ImagingReport - Request Details composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ImagingExam::ImagingReport version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ImagingExam::ImagingReport;
    my $diagnosis = OpenEHR::Composition::Elements::ImagingExam::ImagingReport->new(
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

OpenEHR::Composition::Elements::ImagingExam::ImagingReport requires no configuration files or 
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
