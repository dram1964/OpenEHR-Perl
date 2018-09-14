package OpenEHR::Composition::RadiologyReport;

use warnings;
use strict;
use Carp;
use Moose;
use Data::Dumper;
extends 'OpenEHR::Composition';
use OpenEHR::Composition::Elements::CTX;

use version; our $VERSION = qv('0.0.2');

has ctx       => ( is => 'rw', isa => 'OpenEHR::Composition::Elements::CTX', default => \&_set_ctx );
has report_id => ( is => 'rw', isa => 'Str' );
has requester_order => ( is => 'rw', isa => 'ArrayRef[OpenEHR::Composition::Elements::Radiology::RequesterOrder]');
has report_reference => ( is => 'rw', isa => 'ArrayRef[OpenEHR::Composition::Elements::Radiology::ReportReference]');
has patient_comment => ( is => 'rw', isa => 'Str' );

=head1 _set_ctx

Adds the context and ctx elements to the Information Order

=cut 

sub _set_ctx {
    my $self = shift;
    my $ctx = OpenEHR::Composition::Elements::CTX->new();
    $self->ctx($ctx);
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );

    $self->ctx->composition_format( $self->composition_format ) if $self->ctx;
    if ($self->requester_order) {
        for my $requester_order ( @{ $self->requester_order } ) {
            $requester_order->composition_format( $self->composition_format );
        }
    }
    if ($self->report_reference) {
        for my $report_reference ( @{ $self->report_reference } ) {
            $report_reference->composition_format( $self->composition_format );
        }
    }


    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self            = shift;
    my $patient_comment = [
        {   'encoding' => [
                {   '|code'        => $self->encoding_code,
                    '|terminology' => $self->encoding_terminology
                }
            ],
            'comment'  => [ $self->patient_comment ],
            'language' => [
                {   '|terminology' => $self->language_terminology,
                    '|code'        => $self->language_code
                }
            ]
        }
    ];
    my $laboratory_test;
    for my $labtest ( @{ $self->labtests } ) {
        push @{$laboratory_test}, $labtest->compose();
    }

    my $ctx = $self->ctx->compose;

    my $composition = {
        'laboratory_result_report' => {
            'laboratory_test' => $laboratory_test,
            'patient_comment' => $patient_comment,
            context => {
                report_id => $self->report_id,
            },
        },
        ctx => $ctx,
    };

    return $composition;
}

sub compose_raw {
    my $self = shift;
    my ($composer, $content,           $territory,
        $category, $class,             $laboratory_test,
        $language, $uid,               $archetype_node_id,
        $name,     $archetype_details, $context,
    );
    $content = [];
    for my $labtest ( @{ $self->labtests } ) {
        push @{$content}, $labtest->compose();
    }
    my $evaluation = {
        'encoding' => {
            'code_string'    => $self->encoding_code,
            '@class'         => 'CODE_PHRASE',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => $self->encoding_terminology,
            },
        },
        'language' => {
            '@class'         => 'CODE_PHRASE',
            'code_string'    => $self->language_code,
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => $self->language_terminology,
            }
        },
        'data' => {
            '@class' => 'ITEM_TREE',
            'name'   => {
                '@class' => 'DV_TEXT',
                'value'  => 'List',
            },
            'items' => [
                {   '@class' => 'ELEMENT',
                    'value'  => {
                        'value'  => $self->patient_comment,
                        '@class' => 'DV_TEXT'
                    },
                    'name' => {
                        'value'  => 'Comment',
                        '@class' => 'DV_TEXT'
                    },
                    'archetype_node_id' => 'at0002'
                }
            ],
            'archetype_node_id' => 'at0001'
        },
        'archetype_details' => {
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1'
            },
            'rm_version' => '1.0.1',
            '@class'     => 'ARCHETYPED'
        },
        'name' => {
            'value'  => 'Patient comment',
            '@class' => 'DV_TEXT'
        },
        '@class'            => 'EVALUATION',
        'subject'           => { '@class' => 'PARTY_SELF' },
        'archetype_node_id' => 'openEHR-EHR-EVALUATION.clinical_synopsis.v1'
    };
    push @$content, $evaluation if $evaluation;

    $class = 'COMPOSITION';

    my $ctx = $self->ctx->compose;

    $ctx->{context}->{other_context} = {
            'name' => {
                '@class' => 'DV_TEXT',
                'value'  => 'Tree'
            },
            '@class' => 'ITEM_TREE',
            'items'  => [
                {   'value' => {
                        'value'  => $self->report_id,    #'17V444999',
                        '@class' => 'DV_TEXT'
                    },
                    'archetype_node_id' => 'at0002',
                    '@class'            => 'ELEMENT',
                    'name'              => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Report ID'
                    }
                }
            ],
            'archetype_node_id' => 'at0001'
    };

    $archetype_node_id = 'openEHR-EHR-COMPOSITION.report-result.v1';

    $name = {
        '@class' => 'DV_TEXT',
        'value'  => 'Laboratory Result Report'
    };

    $archetype_details = {
        '@class'       => 'ARCHETYPED',
        'archetype_id' => {
            '@class' => 'ARCHETYPE_ID',
            'value'  => 'openEHR-EHR-COMPOSITION.report-result.v1'
        },
        'rm_version'  => '1.0.1',
        'template_id' => {
            '@class' => 'TEMPLATE_ID',
            'value'  => 'GEL - Generic Lab Report import.v0'
        }
    };

    my $composition = {
        content           => $content,
        '@class'          => $class,
        archetype_node_id => $archetype_node_id,
        name              => $name,
        archetype_details => $archetype_details,
    };
    $composition = { %{$composition}, %{$ctx} };

    return $composition;
}

sub compose_flat {
    my $self          = shift;
    my $ctx = $self->ctx->compose;

    my $composition = {
        %{ $ctx },
    'radiology_result_report/context/report_id' => $self->report_id,
# Request Details
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/dicom_study_identifier'
      => 'http://example.com/path/resource',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/examination_requested_name:0'
      => 'Examination requested name 16',
# Order ID
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/receiver_order_identifier|type'
      => 'Prescription',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/receiver_order_identifier|assigner'
      => 'Assigner',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/receiver_order_identifier'
      => 'ee61cc8e-a19b-4d6c-84aa-a7d1fad60829',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/receiver_order_identifier|issuer'
      => 'Issuer',
# Event Data
'radiology_result_report/imaging_examination_result:0/any_event:0/clinical_information_provided'
      => 'Clinical information provided 50',
    'radiology_result_report/imaging_examination_result:0/any_event:0/comment:0'
      => 'Comment 44',
'radiology_result_report/imaging_examination_result:0/any_event:0/imaging_report_text'
      => 'Imaging report text 62',
'radiology_result_report/imaging_examination_result:0/any_event:0/imaging_diagnosis:0'
      => 'Imaging diagnosis 29',
    'radiology_result_report/imaging_examination_result:0/any_event:0/findings'
      => 'Findings 69',
    'radiology_result_report/imaging_examination_result:0/any_event:0/modality'
      => 'Modality 39',
'radiology_result_report/imaging_examination_result:0/any_event:0/anatomical_side/anatomical_side|code'
      => 'at0007',
'radiology_result_report/imaging_examination_result:0/any_event:0/datetime_result_issued'
      => '2018-09-14T12:45:54.769+01:00',
'radiology_result_report/imaging_examination_result:0/any_event:0/anatomical_location:0/anatomical_site'
      => 'Anatomical site 3',
'radiology_result_report/imaging_examination_result:0/any_event:0/imaging_code'
      => 'Imaging code 87',
'radiology_result_report/imaging_examination_result:0/any_event:0/overall_result_status|code'
      => 'at0009',
'radiology_result_report/imaging_examination_result:0/any_event:0/multimedia_resource:0/image_file_reference'
      => 'Image file reference 97',
    };

    if ($self->requester_order) {
        my $requester_index = '0';
        my $requester_comp = {};
        for my $requester_order ( @{ $self->requester_order } ) {
            my $composition_fragment = $requester_order->compose;
            for my $key ( keys %{ $composition_fragment } ) {
                my $new_key = $key;
                $new_key =~ s/__REQ__/$requester_index/;
                $requester_comp->{$new_key} = $composition_fragment->{$key};
            }
        }
        $composition = { %{ $composition }, %{ $requester_comp } };
    }
    
    if ($self->report_reference) {
        my $report_index = '0';
        my $report_comp = {};
        for my $report_reference ( @{ $self->report_reference } ) {
            my $composition_fragment = $report_reference->compose;
            for my $key ( keys %{ $composition_fragment } ) {
                my $new_key = $key;
                $new_key =~ s/__REF__/$report_index/;
                $report_comp->{$new_key} = $composition_fragment->{$key};
            }
        }
        $composition = { %{ $composition }, %{ $report_comp } };
    }
    
=for removal # Report Reference
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/imaging_report_reference|type'
      => 'Prescription',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/imaging_report_reference|issuer'
      => 'Issuer',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/imaging_report_reference'
      => '8987968c-347e-452a-907b-3268d844881d',
'radiology_result_report/imaging_examination_result:0/examination_request_details:0/imaging_report_reference|assigner'
      => 'Assigner',
=cut 


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
