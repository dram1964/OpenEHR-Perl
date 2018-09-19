package OpenEHR::Composition::RadiologyReport;

use warnings;
use strict;
use Carp;
use Moose;
use Data::Dumper;
extends 'OpenEHR::Composition';
use OpenEHR::Composition::Elements::ImagingExam;
use OpenEHR::Composition::Elements::CTX;

use version; our $VERSION = qv('0.0.2');

has ctx => (
    is      => 'rw',
    isa     => 'OpenEHR::Composition::Elements::CTX',
    default => \&_set_ctx
);
has report_id => ( is => 'rw', isa => 'Str' );
has imaging_exam => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::ImagingExam]'
);
has patient_comment => ( is => 'rw', isa => 'Str' );

=head1 _set_ctx

Adds the context and ctx elements to the Information Order

=cut 

sub _set_ctx {
    my $self = shift;
    my $ctx  = OpenEHR::Composition::Elements::CTX->new();
    $self->ctx($ctx);
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    $self->ctx->composition_format( $self->composition_format );

    if ( $self->imaging_exam ) {
        for my $imaging_exam ( @{ $self->imaging_exam } ) {
            $imaging_exam->composition_format( $self->composition_format );
        }
    }

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_flat {
    my $self = shift;

    my $imaging_exam_index = '0';
    my $imaging_exam_comp  = {};
    for my $imaging_exam ( @{ $self->imaging_exam } ) {
        my $composition_fragment = $imaging_exam->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__EXAM__/$imaging_exam_index/;
            $imaging_exam_comp->{$new_key} = $composition_fragment->{$key};
        }
        $imaging_exam_index++;
    }

    my $composition = {
        'radiology_result_report/context/report_id' => $self->report_id,
        %{ $self->ctx->compose },
        %{$imaging_exam_comp},
    };

    return $composition;
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'radiology_result_report' => {
            'territory' => [
                {
                    '|code'        => 'GB',
                    '|terminology' => 'ISO_3166-1'
                }
            ],
            'language' => [
                {
                    '|code'        => 'en',
                    '|terminology' => 'ISO_639-1'
                }
            ],
            'context' => [
                {
                    '_health_care_facility' => [
                        {
                            '|id'           => 'RRV',
                            '|name'         => 'UCLH NHS Foundation Trust',
                            '|id_namespace' => 'UCLH-NS',
                            '|id_scheme'    => 'UCLH-NS'
                        }
                    ],
                    'start_time' => ['2018-09-19T12:47:05.725+01:00'],
                    'setting'    => [
                        {
                            '|code'        => '238',
                            '|terminology' => 'openehr',
                            '|value'       => 'other care'
                        }
                    ],
                    'report_id' => [$self->report_id]
                }
            ],
            'category' => [
                {
                    '|code'        => '433',
                    '|terminology' => 'openehr',
                    '|value'       => 'event'
                }
            ],
            'composer' => [
                {
                    '|name' => $self->composer_name . '-' . $self->composition_format,
                }
            ],
            'imaging_examination_result' => [
                {
                    'language' => [
                        {
                            '|code'        => 'en',
                            '|terminology' => 'ISO_639-1'
                        }
                    ],
                    'examination_request_details' => [
                        {
                            'requester_order_identifier' => [
                                {
                                    '|id'       => '1232341234234',
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => 'rec-1235',
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => '99887766',
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier' =>
                              ['http://uclh.dicom.store/image_1'],
                            'examination_requested_name' =>
                              [ 'Request1', 'Request2' ]
                        }
                    ],
                    'any_event' => [
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0009',
                                    '|terminology' => 'local',
                                    '|value'       => 'Registered'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:45:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 50'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 62'],
                            'modality'            => ['Modality 39'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 97']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 98']
                                }
                            ],
                            'imaging_code' => ['Imaging code 87'],
                            'comment'      => [ 'Comment 44', 'Comment 45' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 3']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 4']
                                }
                            ],
                            'findings'        => ['Findings 69'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0010',
                                    '|terminology' => 'local',
                                    '|value'       => 'Interim'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:55:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 51'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 63'],
                            'modality'            => ['Modality 40'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 99']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 96']
                                }
                            ],
                            'imaging_code' => ['Imaging code 88'],
                            'comment'      => [ 'Comment 47', 'Comment 46' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 5']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 6']
                                }
                            ],
                            'findings'        => ['Findings 70'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    'encoding' => [
                        {
                            '|code'        => 'UTF-8',
                            '|terminology' => 'IANA_character-sets'
                        }
                    ]
                },
                {
                    'language' => [
                        {
                            '|code'        => 'en',
                            '|terminology' => 'ISO_639-1'
                        }
                    ],
                    'examination_request_details' => [
                        {
                            'requester_order_identifier' => [
                                {
                                    '|id'       => '1232341234234',
                                    '|assigner' => 'UCLH OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'receiver_order_identifier' => [
                                {
                                    '|id'       => 'rec-1235',
                                    '|assigner' => 'PACS OCS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'imaging_report_reference' => [
                                {
                                    '|id'       => '99887766',
                                    '|assigner' => 'UCLH RIS',
                                    '|issuer'   => 'UCLH',
                                    '|type'     => 'local'
                                }
                            ],
                            'dicom_study_identifier' =>
                              ['http://uclh.dicom.store/image_1'],
                            'examination_requested_name' =>
                              [ 'Request1', 'Request2' ]
                        }
                    ],
                    'any_event' => [
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0009',
                                    '|terminology' => 'local',
                                    '|value'       => 'Registered'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:45:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 50'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 62'],
                            'modality'            => ['Modality 39'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 97']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 98']
                                }
                            ],
                            'imaging_code' => ['Imaging code 87'],
                            'comment'      => [ 'Comment 44', 'Comment 45' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 3']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 4']
                                }
                            ],
                            'findings'        => ['Findings 69'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            'overall_result_status' => [
                                {
                                    '|code'        => 'at0010',
                                    '|terminology' => 'local',
                                    '|value'       => 'Interim'
                                }
                            ],
                            'datetime_result_issued' =>
                              ['2018-09-14T12:55:54.769+01:00'],
                            'clinical_information_provided' =>
                              ['Clinical information provided 51'],
                            'time' => ['2018-09-19T12:47:05.725+01:00'],
                            'imaging_report_text' => ['Imaging report text 63'],
                            'modality'            => ['Modality 40'],
                            'multimedia_resource' => [
                                {
                                    'image_file_reference' =>
                                      ['Image file reference 99']
                                },
                                {
                                    'image_file_reference' =>
                                      ['Image File Reference 96']
                                }
                            ],
                            'imaging_code' => ['Imaging code 88'],
                            'comment'      => [ 'Comment 47', 'Comment 46' ],
                            'anatomical_location' => [
                                {
                                    'anatomical_site' => ['Anatomical site 5']
                                },
                                {
                                    'anatomical_site' => ['Anatomical Site 6']
                                }
                            ],
                            'findings'        => ['Findings 70'],
                            'anatomical_side' => [
                                {
                                    'anatomical_side' => [
                                        {
                                            '|code'        => 'at0007',
                                            '|terminology' => 'local',
                                            '|value'       => 'Not known'
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    'encoding' => [
                        {
                            '|code'        => 'UTF-8',
                            '|terminology' => 'IANA_character-sets'
                        }
                    ]
                }
            ]
        }
    };

    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {};
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::RadiologyReport - Used to construct Laboratory Result Compositions

=head1 VERSION

This document describes OpenEHR::Composition::RadiologyReport version 0.0.2

=head1 SYNOPSIS

    # get OpenEHR::Composition::Elements::LabTest data from somewhere
    my $labtest_object = &get_labtest_data_from_somewhere;

    use OpenEHR::Composition::RadiologyReport;
    my $labreport = OpenEHR::Composition::RadiologyReport->new(
            report_id       => '17V999333',
            labtests        => [$labtest_object],
            patient_comment => 'Patient feeling poorly',
    );
    $labreport->composition_format('RAW');

    my $rest_composition = OpenEHR::REST::Composition->new();
    $rest_composition->composition($labreport);
    $rest_composition->submit_new($ehrId);

  
=head1 DESCRIPTION

Use this module to transform pathology result data into a composition
suitable for submission to an OpenEHR server. 
RadiologyReports are constructed by supplying a report_id, patient_comment
and an array of OpenEHR::Composition::Elements::LabTest objects. 
Once the RadiologyReport is constructed, it can be submitted to the OpenEHR
server using OpenEHR::REST::Composition module.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 report_id

Unique identifier for the RadiologyReport object

=head2 labtests 

An array of OpenEHR::Composition::Elements::LabTest objects associated with the report

=head2 patient_comment

Records the evaluation of the clinical findings

=head1 METHODS

=head2 composition_format($format)

Inherited from L<OpenEHR::Composition>. 
Used to get or set the composition format. Valid values are one of 
(RAW | STRUCTURED | FLAT | TDD), although TDD is not currently implemented. 

=head2 compose

Returns a hashref of the object's composition in the requested format. 
Format is defined via the composition_format method. 
Normally you do not need to call the compose method: 
this will be done by the submit_new method of the OpenEHR::REST object.
However you can call this method if you wish to inspect the composition:
    my $composition = $lab_result_report->compose;

=head2 print_json

Inherited from L<OpenEHR::Composition>.
Returns the object's composition as JSON in the format specified by 
the objects composition_format property
    my $json = $lab_result_report->print_json;

=head2 add_labtests

Utility method that adds labtest objects 
to Report object using an array of hashes. Each hash should
represent a single order code. Each hash should be structured like this: 

    {
        ordercode   => 'Str', 
        ordername   => 'Str, 
        spec_type   => 'Str',
        collected   => 'DateTime',
        collect_method  => 'Str',
        received    => 'DateTime',
        labnumber   => {
            id          => 'Str',
            assigner    => 'Str',
            issuer      => 'Str',
        },
        labresults  => [
            {
                result          => 'Str',
                comment         => 'Str',
                ref_range       => 'Str',
                testcode        => 'Str',
                testname        => 'Str',
                result_status   => 'Str',
            },
        ],
        ordernumber => {
            id          => 'Str',
            assigner    => 'Str',
            issuer      => 'Str',
        },
        report_date => 'DateTime',
        clinician   => {
            id          => 'Str',
            assigner    => 'Str',
            issuer      => 'Str',
        },
        location => {
            id          => 'Str',
            parent      => 'Str',
        },
        test_status     => 'Str',
        clinical_info   => 'Str',
    };

=head1 PRIVATE METHODS

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format


=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

None

=head1 DEPENDENCIES

=over 4

=item * OpenEHR::Composition

=item * OpenEHR::Composition::Elements::LabTest

=item * Carp

=item * Moose

=item * Data::Dumper

=back

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-composition-labresultreport@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Ramlakhan  C<< <dram1964@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2018, David Ramlakhan C<< <dram1964@gmail.com> >>. All rights reserved.

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
