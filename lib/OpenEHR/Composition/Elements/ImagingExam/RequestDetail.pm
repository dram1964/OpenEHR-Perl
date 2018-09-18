package OpenEHR::Composition::Elements::ImagingExam::RequestDetail;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition::Elements';

use version; our $VERSION = qv('0.0.2');

=head2 requester($requester_object)

Used to get or set the Requester item for the RequestDetail

=cut

has requester => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::Elements::ImagingExam::Requester',
);

=head2 receiver($receiver_object)

Used to get or set the Receiver item for the RequestDetail

=cut

has receiver => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::Elements::ImagingExam::Receiver',
);

=head2 report_reference($report_reference_object)

Used to get or set the Report Reference item for the RequestDetail

=cut

has report_reference => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::Elements::ImagingExam::ReportReference',
);

=head2 dicom_url($dicom_url)

Used to get or set the link to the Dicom Study

=cut 

has dicom_url => (
    is => 'rw',
    isa => 'Str',
);

=head2 exam_request

Used to get or set the names for the examinations on this request

=cut

has exam_request => (
    is => 'rw',
    isa => 'ArrayRef',
);


sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    my @properties = qw(
        requester receiver report_reference
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

sub compose_flat {
    my $self        = shift;
    my $composition;
    my $path = 'radiology_result_report/imaging_examination_result:__EXAM__/examination_request_details:__REQ__/';


    if ( $self->dicom_url ) {
        $composition->{ $path . 'dicom_study_identifier' } = $self->dicom_url; #'http://example.com/path/resource',
    }
    if ( $self->exam_request ) {
        my $index = '0';
        for my $exam ( @{ $self->exam_request } ) {
            my $exam_key = $path . 'examination_requested_name:' . $index;
            $composition->{$exam_key} = $exam;
            $index++;
        }
    }
    if ( $self->requester ) {
        my $comp = $self->requester->compose();
        $composition = { ( %$composition, %{$comp} ) };
    }
    if ( $self->receiver ) {
        my $comp = $self->receiver->compose();
        $composition = { ( %$composition, %{$comp} ) };
    }
    if ( $self->report_reference ) {
        my $comp = $self->report_reference->compose();
        $composition = { ( %$composition, %{$comp} ) };
    }

    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ImagingExam::RequestDetail - Request Details composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ImagingExam::RequestDetail version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ImagingExam::RequestDetail;
    my $diagnosis = OpenEHR::Composition::Elements::ImagingExam::RequestDetail->new(
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

OpenEHR::Composition::Elements::ImagingExam::RequestDetail requires no configuration files or 
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
