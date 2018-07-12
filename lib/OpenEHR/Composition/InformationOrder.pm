package OpenEHR::Composition::InformationOrder;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has current_state => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    trigger  => \&_set_state_code,
);
has current_state_code => (
    is  => 'rw',
    isa => 'Str',
);
has service_type => (
    is      => 'rw',
    isa     => 'Str',
    default => 'pathology',
);

sub _set_state_code {
    my $self   = shift;
    my $states = {
        planned   => 526,
        scheduled => 529,
        aborted   => 531,
        completed => 532,
    };
    $self->current_state_code( $states->{ $self->current_state } );
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
        'ctx/language'                => $self->language_code,
        'ctx/territory'               => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name,
        'ctx/id_namespace'            => 'UCLH-NS',
        'ctx/id_scheme'                 => 'UCLH-NS',
        'ctx/health_care_facility|name' => 'UCLH',
        'ctx/health_care_facility|id' => 'RRV',
        'gel_data_request_summary'      => {
            'service_request' => [
                {
                    'narrative' => [ 'GEL Information data request - ' . $self->service_type ],
                    'request'   => [
                        {
                            'gel_information_request_details' => [
                                {
                                    'patient_information_request_end_date' =>
                                      [ '2018-07-12T12:23:08.531+01:00' ],
                                    'patient_information_request_start_date' =>
                                      [ DateTime->now->datetime ]
                                }
                            ],
                            'service_type' => [ 'GEL Information data request' ],
                            'timing'       => [
                                {
                                    '|value' =>
                                      DateTime->now->datetime
                                }
                            ],
                            'service_name' => [ 'GEL Information data request' ]
                        }
                    ],
                    'requestor_identifier' => [ 'Ident. 43' ],
                    'expiry_time' => [ '2018-08-12T12:23:08.531+01:00' ],
                    '_uid'        => [ 'c3408c7c-8075-46d0-b18b-428e91e64f9f' ]
                }
            ],
            'service' => [
                {
                    'service_type' => [ $self->service_type ],
                    'service_name' => [ 'GEL Information data request' ],
                    'comment'      => [ 'Comment 25' ],
                    'time'         => [ DateTime->now->datetime ],
                    'requestor_identifier' => [
                        {
                            '|id' => '9b9a4864-3062-4ef6-bf92-71ee72351f3a',
                            '|assigner' => 'OpenEHR-Perl',
                            '|issuer'   => 'UCLH',
                            '|type'     => 'Test'
                        }
                    ],
                    'ism_transition' => [
                        {
                            'current_state' => [
                                {
                                    '|code'  => $self->current_state_code,
                                    '|value' => $self->current_state
                                }
                            ]
                        }
                    ]
                }
            ]
        },
    };
    return $composition;
}
#    'ctx/participation_mode'      => 'face-to-face communication',
#    'ctx/participation_id'        => '199',
#    'ctx/participation_function:1'  => 'performer',
#    'ctx/participation_name:1'      => 'Lara Markham',
#    'ctx/participation_id:1'        => '198',
#    'ctx/participation_name'        => 'Dr. Marcus Johnson',
#    'ctx/participation_function'    => 'requester',
#        'context' => [
#            {
#                'individual_professional_demographics_uk' => [
#                    {
#                        'grade'                   => [ 'Grade 46' ],
#                        'professional_identifier' => [
#                            {
#                                '|id' =>
#                                  '51c464b4-234f-447c-8c62-266af833fc06',
#                                '|assigner' => 'Assigner',
#                                '|issuer'   => 'Issuer',
#                                '|type'     => 'Prescription'
#                            }
#                        ],
#                        'team'               => [ 'Team 17' ],
#                        'professional_group' => [ 'Professional group 88' ]
#                    }
#                ]
#            }
#        ],
sub compose_raw {
    my $self        = shift;
    my $composition = {
        'value' => {
            'type'     => $self->type,
            '@class'   => 'DV_IDENTIFIER',
            'id'       => $self->order_number,
            'issuer'   => $self->issuer,
            'assigner' => $self->assigner,
        },
        '@class'            => 'ELEMENT',
        'archetype_node_id' => 'at0063',
        'name'              => {
            'value'  => 'Filler order number',
            '@class' => 'DV_TEXT'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path =
      'laboratory_result_report/laboratory_test:__TEST__/test_request_details/';
    my $composition = {
        'ctx/language'                  => $self->language_code,
        'ctx/territory'                 => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name,
        'ctx/time'                      => DateTime->now->datetime,
        'ctx/id_namespace'              => 'UCLH-NS',
        'ctx/id_scheme'                 => 'UCLH-NS',
        'ctx/health_care_facility|name' => 'UCLH',
        'ctx/health_care_facility|id'   => 'RRV',
        'gel_data_request_summary/service_request:0/request:0/service_name' =>
          'GEL Information data request',
        'gel_data_request_summary/service_request:0/request:0/service_type' =>
          $self->service_type,
        'gel_data_request_summary/service_request:0/request:0/timing' =>
          DateTime->now->datetime,
        'gel_data_request_summary/service_request:0/narrative' =>
          'GEL Information data request - ' . $self->service_type,
        'gel_data_request_summary/service_request:0/requestor_identifier' =>
          'Ident. 6',
        'gel_data_request_summary/service_request:0/expiry_time' =>
          '2018-07-14T11:16:32.485+01:00',
        'gel_data_request_summary/service:0/ism_transition/current_state|code'
          => $self->current_state_code,
        'gel_data_request_summary/service:0/ism_transition/current_state|value'
          => $self->current_state,
        'gel_data_request_summary/service:0/service_name' =>
          'GEL Information data request',
        'gel_data_request_summary/service:0/service_type' => 'pathology',
        'gel_data_request_summary/service:0/time' => DateTime->now->datetime,
    };

    return $composition;
}

#        'ctx/participation_id'          => '199',
#        'ctx/participation_function'    => 'requester',
#        'ctx/participation_name'        => 'Dr. Marcus Johnson',
#        'ctx/participation_mode'        => 'face-to-face communication',
#        'ctx/participation_id:1'        => '198',
#        'ctx/participation_function:1'  => 'performer',
#        'ctx/participation_name:1'      => 'Lara Markham',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0'
#          => '3cee91a5-eba2-42b0-9bfa-21fe3a7c5b38',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|issuer'
#          => 'Issuer',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/grade'
#          => 'Grade 11',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|assigner'
#          => 'Assigner',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_group'
#          => 'Professional group 18',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/team'
#          => 'Team 36',
#'gel_data_request_summary/context/individual_professional_demographics_uk:0/professional_identifier:0|type'
#          => 'Prescription',
#        'gel_data_request_summary/service:0/requestor_identifier|issuer' =>
#          'Issuer',
#        'gel_data_request_summary/service_request:0/_uid' =>
#          'e0d413ed-5c42-4257-8eed-9de8806d7782',
#        'gel_data_request_summary/service:0/requestor_identifier|type' =>
#          'Prescription',
#        'gel_data_request_summary/service:0/comment' => 'Comment 45',
#'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_end_date'
#          => '2018-07-12T11:16:32.485+01:00',
#        'gel_data_request_summary/service:0/requestor_identifier' =>
#          '0cce9c45-861f-4d4e-8102-0a9c96cf59dc',
#'gel_data_request_summary/service_request:0/request:0/gel_information_request_details:0/patient_information_request_start_date'
#          => '2018-07-12T11:16:32.485+01:00',
#        'gel_data_request_summary/service:0/requestor_identifier|assigner' =>
#          'Assigner',

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::InformationOrder - Information Order composition element


=head1 VERSION

This document describes OpenEHR::Composition::InformationOrder version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::InformationOrder;
    my $filler = OpenEHR::Composition::InformationOrder->new({
        order_number    => '17V111333',
        assigner        => 'Winpath',
        issuer          => 'UCLH',
        type            => 'local',
        composition_format => 'FLAT',
    });

    my $filler_hashref = $filler->compose;

  
=head1 DESCRIPTION

Used to create a hashref element of an information order 
composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 current_state

Text value for the current completeness state of the 
information order. Can be one of 
['planned'|'scheduled'|'aborted'|'completed']

=head2 current_state_code

Numeric code value for the current completeness state
of the information order. Set automatically based on 
the current_state attribute

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

OpenEHR::Composition::InformationOrder requires no configuration files or 
environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

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
