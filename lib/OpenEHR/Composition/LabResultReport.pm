package OpenEHR::Composition::LabResultReport;

use warnings;
use strict;
use Carp;
use Moose;
use Data::Dumper;
extends 'OpenEHR::Composition';
use OpenEHR::Composition::Elements::LabTest;
use OpenEHR::Composition::Elements::CTX;

use version; our $VERSION = qv('0.0.2');

has ctx       => ( is => 'rw', isa => 'OpenEHR::Composition::Elements::CTX', default => \&_set_ctx );
has report_id => ( is => 'rw', isa => 'Str' );
has labtests  => (
    is      => 'rw',
    isa     => 'ArrayRef[OpenEHR::Composition::Elements::LabTest]',
    default => sub { [] }
);
has patient_comment => ( is => 'rw', isa => 'Str' );

=head1 _set_ctx

Adds the context and ctx elements to the Information Order

=cut 

sub _set_ctx {
    my $self = shift;
    my $ctx = OpenEHR::Composition::Elements::CTX->new();
    $self->ctx($ctx);
}

sub add_labtests {
    my ( $self, $order ) = @_;

    my $labtest = OpenEHR::Composition::Elements::LabTest->new();

    my $request = $labtest->element('RequestedTest')->new(
        requested_test => $order->{ordername} || $order->{ordercode},
        name           => $order->{ordername} || $order->{ordercode},
        code           => $order->{ordercode},
        terminology    => 'local',
    );
    if ( $order->{order_mapping} ) {
        $request->order_mapping($order->{order_mapping});
    }
    my $specimen = $labtest->element('Specimen')->new(
        datetime_collected => $order->{collected},
        collection_method  => $order->{collect_method},
        datetime_received  => $order->{received},
        spec_id            => $order->{labnumber}->{id},
    );

    if ( $order->{spec_type} ) {
        $specimen->{specimen_type} = $order->{spec_type};
    }

    my $labresults = [];
    for my $res ( @{ $order->{labresults} } ) {
        my $labresult = $labtest->element('LabResult')->new(
            $res
        );
        push @{$labresults}, $labresult;
    }

    my $labpanel =
        $labtest->element('LabTestPanel')->new(
        lab_results => $labresults );

    my $placer = $labtest->element('Placer')->new(
        order_number => $order->{order_number}->{id},
        assigner     => $order->{order_number}->{assigner},
        issuer       => $order->{order_number}->{issuer},
        type         => 'local',
    );

    my $filler = $labtest->element('Filler')->new(
        order_number => $order->{labnumber}->{id},
        assigner     => $order->{labnumber}->{assigner},
        issuer       => $order->{labnumber}->{issuer},
        type         => 'local',
    );

    my $ordering_provider =
        $labtest->element('OrderingProvider')->new(
        given_name  => $order->{location}->{id},
        family_name => $order->{location}->{parent},
        );

    my $professional = $labtest->element('Professional')->new(
        id       => $order->{clinician}->{id},
        assigner => $order->{clinician}->{assigner},
        issuer   => $order->{clinician}->{issuer},
        type     => 'local',
    );

    my $requester = $labtest->element('Requester')->new(
        ordering_provider => $ordering_provider,
        professional      => $professional,
    );

    my $request_details =
        $labtest->element('TestRequestDetails')->new(
        placer            => $placer,
        filler            => $filler,
        ordering_provider => $ordering_provider,
        professional      => $professional,
        requester         => $requester,
        );

    my $labtests = $labtest->element('LabTest')->new(
        requested_test   => $request,
        specimens        => [$specimen],
        history_origin   => DateTime->now(),
        test_status      => $order->{test_status},
        test_status_time => $order->{report_date},
        clinical_info    => $order->{clinical_info},
        test_panels      => [$labpanel],
        conclusion       => '',
        responsible_lab  => $order->{labnumber}->{issuer},
        request_details  => $request_details,
    );

    push @{ $self->labtests }, $labtests;
    return 1;

}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );

    for my $labtest ( @{ $self->labtests } ) {
        $labtest->composition_format( $self->composition_format );
    }
    $self->ctx->composition_format( $self->composition_format ) if $self->ctx;

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
    my $path          = 'laboratory_result_report/';
    my $labtest_index = '0';
    my $labtest_comp  = {};
    for my $labtest ( @{ $self->labtests } ) {
        my $composition_fragment = $labtest->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__TEST__/$labtest_index/;
            $labtest_comp->{$new_key} = $composition_fragment->{$key};
        }
        $labtest_index++;
    }

    my $ctx = $self->ctx->compose;

    my $composition = {
        %{ $ctx },
        $path . 'context/report_id'     => $self->report_id,
        %{$labtest_comp},
        $path . 'patient_comment/comment' => $self->patient_comment,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::LabResultReport - Used to construct Laboratory Result Compositions

=head1 VERSION

This document describes OpenEHR::Composition::LabResultReport version 0.0.2

=head1 SYNOPSIS

    # get OpenEHR::Composition::Elements::LabTest data from somewhere
    my $labtest_object = &get_labtest_data_from_somewhere;

    use OpenEHR::Composition::LabResultReport;
    my $labreport = OpenEHR::Composition::LabResultReport->new(
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
LabResultReports are constructed by supplying a report_id, patient_comment
and an array of OpenEHR::Composition::Elements::LabTest objects. 
Once the LabResultReport is constructed, it can be submitted to the OpenEHR
server using OpenEHR::REST::Composition module.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 report_id

Unique identifier for the LabResultReport object

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
