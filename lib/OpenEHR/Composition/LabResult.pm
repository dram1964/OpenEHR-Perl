package OpenEHR::Composition::LabResult;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use Moose::Util::TypeConstraints;

use version; our $VERSION = qv('0.0.2');

enum    'ResultTestName'   => [
    'Registered', 
    'Interim', 
    'Final', 
    'Amended', 
    'Cancelled',  
    'Not Requested'
];

has result_value => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has magnitude => (
    is          => 'rw',
    isa         => 'Str',
);

has magnitude_status => (
    is      => 'rw',
    isa     => 'Str',
);

has unit        => (
    is          => 'rw',
    isa         => 'Str',
);

has normal_flag => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has comment => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has result_status => (
    is          =>  'rw', 
    isa         =>  'ResultTestName',
);

has status => (
    is          => 'rw',
    isa         => 'HashRef',
    lazy        => 1,
    builder     => 'result_status_lookup',
);

has ref_range => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has testname => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has testcode => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has testcode_terminology => (
    is          =>  'rw', 
    isa         =>  'Str',
    default     =>  'Local',
);

has mapping_code => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has mapping_terminology => (
    is          =>  'rw', 
    isa         =>  'Str',
);

has mapping_match_operator => (
    is          =>  'rw', 
    isa         =>  'Str',
);

sub result_status_lookup {
    my $self = shift;
    my $result_status_lookup = {
        Registered => {
            value => 'Registered',
            code => 'at0007',
            terminology => 'local',
        },
        Interim => {
            value => 'Interim',
            code => 'at0008',
            terminology => 'local',
        },
        Final => {
            value => 'Final',
            code  => 'at0009',
            terminology => 'local',
        },
        Amended => {
            value => 'Amended',
            code  => 'at0010',
            terminology => 'local',
        },
        Cancelled => {
            value => 'Cancelled/Aborted',
            code  => 'at0011',
            terminology => 'local',
        },
        'Not Requested' => {
            value => 'Not requested',
            code => 'at0012',
            terminology => 'local',
        },
    };
    $self->status($result_status_lookup->{$self->result_status});
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW') 
        if ($self->composition_format eq 'TDD');

    my $formatter = 'compose_' . lc($self->composition_format);
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
    my $composition = {
        'reference_range_guidance' => [ $self->ref_range ],
        'comment' => [ $self->comment ],
        'result_value' => [
            {
                '_name' => [
                    {
                    '|code' => $self->testcode,
                    '|value' => $self->testname,
                    '|terminology' => $self->testcode_terminology,
                    },
                ],
            },
        ],
        'result_status' => [
            {
            '|value' => $self->status->{value},
            '|terminology' => $self->status->{terminology},
            '|code' => $self->status->{code},
            },
        ],
    };
    if ($self->result_value) {
        $composition->{result_value}->[0]->{text_value} = [
            $self->result_value
        ];
    }
    elsif ($self->magnitude) {
        $composition->{result_value}->[0]->{value2} = [ {
            magnitude => $self->magnitude,
            magnitude_status => $self->magnitude_status,
            unit    => $self->unit,
            normal_status => $self->normal_flag,
        } ];
    }
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path = 'laboratory_result_report/laboratory_test:__TEST__/' . 
        'laboratory_test_panel:__PANEL__/laboratory_result:__RESULT__/';
    my $composition = {
        $path . 'result_value/_name|value' => $self->testname,
        $path . 'result_value/_name|code'  => $self->testcode,
        $path . 'result_value/_name|terminology' => 
            $self->testcode_terminology,
        $path . 'result_value/_name/_mapping:0/target|code' => 
            $self->mapping_code,
        $path . 'result_value/_name/_mapping:0/target|terminology' => 
            $self->mapping_terminology,
        $path . 'result_value/_name/_mapping:0|match' => 
            $self->mapping_match_operator,
        $path . 'reference_range_guidance' => $self->ref_range,
        $path . 'comment'   => $self->comment,
        $path . 'result_status|code' => $self->status->{code},
    };
    if ($self->result_value) {
        $composition->{$path . 'result_value/value'} = 
            $self->result_value;
    }
    elsif ($self->magnitude) {
        $composition->{$path . 'result_value/value2|magnitude'} = 
            $self->magnitude;
        $composition->{$path . 
            'result_value/value2|magnitude_status'
        } = $self->magnitude_status;
        $composition->{$path . 'result_value/value2|unit'} = 
            $self->unit;
        $composition->{$path . 'result_value/value2|normal_status'} = 
            $self->normal_flag;
    }
    return $composition;
}

sub compose_raw {
    my $self = shift;
    my $composition = {
        '@class' => 'CLUSTER',
        'name' => {
                  'value' => 'Laboratory result',
                  '@class' => 'DV_TEXT'
        },
        'items' => [
           {
             'archetype_node_id' => 'at0001',
             '@class' => 'ELEMENT',
             'value' => {
                 'value' => $self->result_value,
                 '@class' => 'DV_TEXT'
             },
             'name' => {
                 'value' => $self->testname,
                 'defining_code' => {
                     'terminology_id' => {
                         '@class' => 'TERMINOLOGY_ID',
                         'value' => 'local'
                     },
                     '@class' => 'CODE_PHRASE',
                     'code_string' => $self->testcode,
                 },
                 '@class' => 'DV_CODED_TEXT',
               }
           },
           {
             'name' => {
                 'value' => 'Comment',
                 '@class' => 'DV_TEXT'
             },
             'value' => {
                 '@class' => 'DV_TEXT',
                 'value' => $self->comment,
             },
             '@class' => 'ELEMENT',
             'archetype_node_id' => 'at0003'
           },
           {
             'archetype_node_id' => 'at0004',
             'name' => {
                 'value' => 'Reference range guidance',
                 '@class' => 'DV_TEXT'
             },
             '@class' => 'ELEMENT',
             'value' => {
                 '@class' => 'DV_TEXT',
                 'value' => $self->ref_range,
             }
           },
           {
             '@class' => 'ELEMENT',
             'value' => {
                  '@class' => 'DV_CODED_TEXT',
                  'value' => $self->status->{value},
                  'defining_code' => {
                      'terminology_id' => {
                          '@class' => 'TERMINOLOGY_ID',
                          'value' => 'local'
                      },
                      '@class' => 'CODE_PHRASE',
                      'code_string' => $self->status->{code},
                  }
             },
             'name' => {
                 'value' => 'Result status',
                 '@class' => 'DV_TEXT'
             },
             'archetype_node_id' => 'at0005'
           }
        ],
      'archetype_node_id' => 'at0002'
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::LabResult - Laboratory Test composition element


=head1 VERSION

This document describes OpenEHR::Composition::LabResult version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::LabResult;

    my $labtest = OpenEHR::Composition::LabResult->new(
        result_value => 59,
        comment => 'See http://biochem.org for interpretation guidelines',
        ref_range => '50-60',
        testcode => 'NA',
        testname => 'Sodium',
        result_status  => 'Complete',
    );

    $labtest->composition_format('FLAT'), 'Request Structured format');
    my $labtest_hashref = $labtest->compose();

  
=head1 DESCRIPTION

Used to create a hashref element of a laboratory result for insertion
into a composition object. When used as part of a Pathology Report
composition, the laboratory result element contains result data for
a specific test analyte.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 result_value

Actual value of the result recorded for the specified test analyte

=head2 magnitude

Numerical value recorded for the specified test analyte

=head2 magnitude_status

Modifier associated with the numerical value recorded 
for the specified test analyte

=head2 unit

Unit of measurement associated with magnitude attribute

=head2 normal_flag

Flag indicating result interpretation relative to reference range. 
Normally 'H' for 'high' or 'L' for 'low'

=head2 comment

Comment about the result recorded for the specified test analyte

=head2 result_status

Plain text code for the status of the result value. Allowed values are:
Registered, Interim, Final, Amended, Cancelled, Not Requested.

=head2 status

A HashRef represeting the status of the result value derived from the 
text value of result_status

=head2 ref_range

Reference range of normal values for the specified test analyte. According to 
the documentation this should contain additional guidance on the applicability
of the reference range supplied

=head2 testname

Name for the analyte being tested

=head2 testcode

Code for the analyte being tested

=head2 testcode_terminology

Terminology that defines the code being used for the analyte

=head2 mapping_code

Mapping code for testcode

=head2 mapping_terminology

Terminology used for mapping code

=head2 mapping_match_operator

Operator defining match type for mapping code

=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format

=head2 result_status_lookup

Used to set result_status attribute based on the plain text value 
of status attribute


=head1 DIAGNOSTICS

None


=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::LabResult requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-composition-labtest@rt.cpan.org>, or through the web interface at
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
