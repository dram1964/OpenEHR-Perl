package OpenEHR::Composition::Elements::LabTest::LabResult;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use Moose::Util::TypeConstraints;
use Data::Dumper;

use version; our $VERSION = qv('0.0.1');

has name => (
    is      => 'rw',
    default => 'LabResult'
);

enum 'StatusName' =>
  [ 'Registered', 'Interim', 'Final', 'Amended', 'Cancelled', 'Not Requested' ];

has result_value => (
    is      => 'rw',
    isa     => 'Str',
    trigger => \&_format_result,
);

has result_text => (
    is       => 'rw',
    isa      => 'Str',
    init_arg => undef,
);

has magnitude => (
    is       => 'rw',
    isa      => 'Str',
    init_arg => undef,
);

has magnitude_status => (
    is       => 'rw',
    init_arg => undef,
);

has unit => (
    is      => 'rw',
    trigger => \&_format_unit,
);

has normal_flag => (
    is  => 'rw',
    isa => 'Str',
);

has comment => (
    is  => 'rw',
    isa => 'Str',
);

has result_status => (
    is  => 'rw',
    isa => 'StatusName',
);

has status => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    builder => 'result_status_lookup',
);

has range_high => (
    is  => 'rw',
);

has range_low => (
    is  => 'rw',
);

has ref_range => (
    is       => 'rw',
    isa      => 'Str',
    lazy     => 1,
    init_arg => undef,
    builder  => '_format_ref_range',
);

has testname => (
    is  => 'rw',
    isa => 'Str',
);

has testcode => (
    is  => 'rw',
    isa => 'Str',
);

has testcode_terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => 'Local',
);

has result_mapping => (
    is => 'rw',
    isa => 'ArrayRef[HashRef]',
);

sub _format_ref_range {
    my $self = shift;
    if ( $self->range_high ) {
        if ( $self->range_low ) {
            $self->ref_range( $self->range_low . ' - ' . $self->range_high );
        }
        else {
            $self->ref_range( '0 - ' . $self->range_high );
        }
    }
    elsif ( defined( $self->range_low ) ) {
        if ( $self->range_low eq '0' ) {
            $self->ref_range('0');
        }
        else {
            $self->ref_range( $self->range_low );
        }
    }
    else {
        $self->ref_range('');
    }
}

sub _format_unit {
    my $self = shift;
    if ( $self->unit ) { 
        if ( $self->unit eq '          ') { 
            $self->unit('');
        }
        elsif ( $self->unit eq '.' ) {
            $self->unit('');
        }
    }
}

sub result_status_lookup {
    my $self                 = shift;
    my $result_status_lookup = {
        Registered => {
            value       => 'Registered',
            code        => 'at0007',
            terminology => 'local',
        },
        Interim => {
            value       => 'Interim',
            code        => 'at0008',
            terminology => 'local',
        },
        Final => {
            value       => 'Final',
            code        => 'at0009',
            terminology => 'local',
        },
        Amended => {
            value       => 'Amended',
            code        => 'at0010',
            terminology => 'local',
        },
        Cancelled => {
            value       => 'Cancelled/Aborted',
            code        => 'at0011',
            terminology => 'local',
        },
        'Not Requested' => {
            value       => 'Not requested',
            code        => 'at0012',
            terminology => 'local',
        },
    };
    $self->status( $result_status_lookup->{ $self->result_status } );
}

sub _format_result {
    my $self = shift;
    my ( $result, $magnitude, $magnitude_status, $unit, $result_text, $comment );
    $result = $self->result_value;

    # Treat first line as result
    # and additional lines as a comment
    my $regex = qr/^(.*)\n([\W|\w|\n]*)/;
    if ( $result =~ $regex ) {
        ( $result, $comment ) = ( $1, $2 );
        $result =~ s/\r//;
    }
    if ($comment) {
        if ( $comment =~ m[Units: (.*)\n([\W|\w|\n]*)] ) {
            my ($unit) = ( $1 );
            $unit =~ s/\r//;
            $comment =~ s/\r//g;
            $self->unit($unit);
        }
        if ( $comment =~ m[Units: (.*sqm)] ) {
            my ($unit) = ( $1 );
            $unit =~ s/\r//;
            $comment =~ s/\r//g;
            $self->unit($unit);
        }
    }

    # Check if result is numeric
    if ( $result =~ /^([\<|\>]){1,1}(\d*\.{0,1}\d*)$/ ) {
        ( $magnitude_status, $magnitude ) = ( $1, $2 );
    }
    elsif ( $result =~ /^(\d*\.{0,1}\d*)$/ ) {
        $magnitude = $1;
    }
    elsif ( $result =~ /(\d{1,}\.{0,}\d{0,}\%\s{1,}(\d{1,}\.{0,}\d{1,}))$/ ) {
        ($result_text, $magnitude) = ($1, $2);
    }

    # Set Magnitude for numeric results
    # if units provided
    # Or result_text for non-numeric results
    if ( $magnitude && $result_text ) {
        $self->magnitude($magnitude) if $self->unit;
        $self->result_text($result_text);
    }
    elsif ( $magnitude && $self->unit ) {
        $self->magnitude($magnitude);
    }
    elsif ( $magnitude && $magnitude_status ) {
        $self->result_text( $magnitude_status . $magnitude );
        $magnitude_status = '';
    }
    elsif ($magnitude) {
        $self->result_text($magnitude);
    }
    else {
        $self->result_text($result);
    }

    # Appended units to result_text
    # if result text is numeric
    if ( $self->result_text ) {
        if ( $self->unit ) {
            if ( !( $self->unit eq '.' ) ) {
                if ( !( $self->unit eq '' ) ) {
                    if ( $self->result_text !~ /[a-zA-Z]{1,}/ ) {
                        $self->result_text( $result . ' ' . $self->unit );
                    }
                    elsif ( $self->result_text =~ /Neg$/ ) {
                        $self->result_text( $result . ' ' . $self->unit );
                    }

                }
            }
        }
    }

    # Join the comment to the result text
    # Unless it is wholly numeric
    # or a double numeric
    # or matches positive/negative
    # or matches 'Units: '
    if ( $self->result_text ) {
        if ( !( $self->result_text =~ /^\d*\.\d*$/ ) ) {
            if ( !( $self->result_text =~ /\d{1,}\%\s{1,}\d{1,}/ ) ) {
                if ( !( $self->result_text =~
/^(Positive|Negative|Not Detected|REACTIVE|Weak Reactive|POSITIVE)/ ) ) {
                    if ($comment) {
                        if ( $comment !~ m[Units: (.*)\n([\W|\w|\n]*)] ) {
                            $self->result_text(
                                $self->result_text . "\n" . $comment );
                            $comment = '';
                        }
                    }
                }
            }
        }
    }

    $self->magnitude_status($magnitude_status) if $magnitude_status;
    
    $self->comment($comment)                   if $comment;
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
        'reference_range_guidance' => [ $self->ref_range ],
        'comment'                  => [ $self->comment ],
        'result_value'             => [
            {
                '_name' => [
                    {
                        '|code'        => $self->testcode,
                        '|value'       => $self->testname,
                        '|terminology' => $self->testcode_terminology,
                    },
                ],
            },
        ],
        'result_status' => [
            {
                '|value'       => $self->status->{value},
                '|terminology' => $self->status->{terminology},
                '|code'        => $self->status->{code},
            },
        ],
    };
    if ( $self->result_mapping ) {
        for my $mapping ( @{ $self->result_mapping } ) {
            push @{ $composition->{result_value}->[0]->{_name}->[0]->{'_mapping'} }, 
                {
                    target => [
                        {
                            '|code' => $mapping->{code},
                            '|terminology' => $mapping->{terminology},
                        }
                    ],
                    '|match'    => '=',
                };
        }
    }
    if ( $self->magnitude ) {
        $composition->{result_value}->[0]->{quantity_value} = [
            {
                magnitude        => $self->magnitude,
                magnitude_status => $self->magnitude_status,
                unit             => $self->unit,
                normal_status    => $self->normal_flag,
                _normal_range    => [
                    {
                        upper => [
                            {
                                '|unit'      => $self->unit,
                                '|magnitude' => $self->range_high,
                            },
                        ],
                        lower => [
                            {
                                '|unit'      => $self->unit,
                                '|magnitude' => $self->range_low,
                            },
                        ],
                    },
                ],
            }
        ];
    }
    elsif ( $self->result_text ) {
        $composition->{result_value}->[0]->{text_value} =
          [ $self->result_text ];
    }
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path = 'laboratory_result_report/laboratory_test:__TEST__/'
      . 'laboratory_test_panel:__PANEL__/laboratory_result:__RESULT__/';
    my $composition = {
        $path . 'result_value/_name|value'       => $self->testname,
        $path . 'result_value/_name|code'        => $self->testcode,
        $path . 'result_value/_name|terminology' => $self->testcode_terminology,
        $path . 'reference_range_guidance'       => $self->ref_range,
        $path . 'comment'                        => $self->comment,
        $path . 'result_status|code'             => $self->status->{code},
    };
    if ( $self->result_mapping ) {
        my $index = '0';
        for my $mapping ( @{ $self->result_mapping } ) {
            $composition->{ $path . "result_value/_name/_mapping:$index/target|code" } =
              $mapping->{code};
            $composition->{ $path
                  . "result_value/_name/_mapping:$index/target|terminology" } =
              $mapping->{terminology};
            $composition->{ $path . "result_value/_name/_mapping:$index|match" } = '=';
            $index++;
        }
    }
    if ( $self->magnitude ) {
        $composition->{ $path . 'result_value/quantity_value|magnitude' } =
          $self->magnitude;
        $composition->{ $path . 'result_value/quantity_value|unit' } =
          $self->unit;
        $composition->{ $path . 'result_value/quantity_value|normal_status' } =
          $self->normal_flag;
        $composition->{ $path . 'result_value/quantity_value|magnitude_status' }
          = $self->magnitude_status;
        $composition->{ $path
              . 'result_value/quantity_value/_normal_range/lower|magnitude' } =
          $self->range_low;
        $composition->{ $path
              . 'result_value/quantity_value/_normal_range/lower|unit' } =
          $self->unit;
        $composition->{ $path
              . 'result_value/quantity_value/_normal_range/upper|magnitude' } =
          $self->range_high;
        $composition->{ $path
              . 'result_value/quantity_value/_normal_range/upper|unit' } =
          $self->unit;
    }
    elsif ( $self->result_text ) {
        $composition->{ $path . 'result_value/value' } = $self->result_text;
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        '@class' => 'CLUSTER',
        'name'   => {
            'value'  => 'Laboratory result',
            '@class' => 'DV_TEXT'
        },
        'items' => [
            {
                'archetype_node_id' => 'at0001',
                '@class'            => 'ELEMENT',
                'name'              => {
                    'value'         => $self->testname,
                    'defining_code' => {
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => 'local'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => $self->testcode,
                    },
                    '@class' => 'DV_CODED_TEXT',
                }
            },
            {
                '@class' => 'ELEMENT',
                'value'  => {
                    '@class'        => 'DV_CODED_TEXT',
                    'value'         => $self->status->{value},
                    'defining_code' => {
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => 'local'
                        },
                        '@class'      => 'CODE_PHRASE',
                        'code_string' => $self->status->{code},
                    }
                },
                'name' => {
                    'value'  => 'Result status',
                    '@class' => 'DV_TEXT'
                },
                'archetype_node_id' => 'at0005'
            },
        ],
        'archetype_node_id' => 'at0002'
    };
    if ($self->result_mapping) {
        for my $mapping (@{ $self->result_mapping } ) {
            push @{ $composition->{items}->[0]->{name}->{'mappings'} },  
                {
                    'target' => {
                        'terminology_id' => {
                            'value'  => $mapping->{terminology},
                            '@class' => 'TERMINOLOGY_ID'
                        },
                        'code_string' => $mapping->{code},
                        '@class'      => 'CODE_PHRASE'
                    },
                    'match'  => "=",
                    '@class' => 'TERM_MAPPING'
                };
            }
    }
    if ( $self->magnitude ) {
        $composition->{items}->[0]->{value} = {
            'magnitude'        => $self->magnitude,
            'magnitude_status' => $self->magnitude_status,
            'units'            => $self->unit,
            '@class'           => 'DV_QUANTITY',
            'normal_range' => {
                'upper'           => {
                    'magnitude' => $self->range_high,
                    'units'     => $self->unit,
                    '@class'    => 'DV_QUANTITY'
                },
                'lower' => {
                    'magnitude' => $self->range_low,
                    'units'     => $self->unit,
                    '@class'    => 'DV_QUANTITY'
                },
                '@class'          => 'DV_INTERVAL',
            },
        };
    }
    elsif ( $self->result_text ) {
        $composition->{items}->[0]->{value} = {
            value    => $self->result_text,
            '@class' => 'DV_TEXT',
        };
    }

    if ( $self->comment ) {
        push @{ $composition->{items} },
          {
            'name' => {
                'value'  => 'Comment',
                '@class' => 'DV_TEXT'
            },
            'value' => {
                '@class' => 'DV_TEXT',
                'value'  => $self->comment,
            },
            '@class'            => 'ELEMENT',
            'archetype_node_id' => 'at0003'
          };
    }
    if ( $self->ref_range ) {
        push @{ $composition->{items} },
          {
            'archetype_node_id' => 'at0004',
            'name'              => {
                'value'  => 'Reference range guidance',
                '@class' => 'DV_TEXT'
            },
            '@class' => 'ELEMENT',
            'value'  => {
                '@class' => 'DV_TEXT',
                'value'  => $self->ref_range,
            }
          };
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::LabTest::LabResult - Laboratory Test composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::LabTest::LabResult version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::LabTest::LabResult;

    my $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new(
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

Numerical value recorded for the specified test analyte derived from result_value

=head2 magnitude_status

Modifier associated with the numerical value recorded 
for the specified test analyte

=head2 result_text

Result value derived from result_value if this does not appear to be a numerical result

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

=head2 range_high

Upper limit for reference range

=head2 range_low

Lower limit for reference range

=head2 ref_range

Reference range of normal values for the specified test analyte. 
Derived from range_low and range_high values. 

=head2 testname

Name for the analyte being tested

=head2 testcode

Code for the analyte being tested

=head2 testcode_terminology

Terminology that defines the code being used for the analyte

=head2 result_mapping

Array of hash references defining mappings of the test_code to 
other terminologies (e.g. LOINC, GEL). Each mapping hashref should
contain values for two keys: code and terminology

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

=head1 PRIVATE METHODS

=head2 _format_result

determines whether a result should be handled as a plain text value
with units appended
or split into magnitude, magnitude_status, and units. 

=head2 _format_ref_range

Combines the range_low and range_high values of the object into 
a formatted 'reference range' string

=head2 _format_unit

Sets unit to an empty string if unit is defined as '.'


=head1 DIAGNOSTICS

None


=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::Elements::LabTest::LabResult requires no configuration files or environment variables.


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
