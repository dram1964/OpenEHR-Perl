package OpenEHR::Composition::Elements::LabTest;

use warnings;
use strict;
use Carp;
use DateTime;
use Moose;
extends 'OpenEHR::Composition';
use Moose::Util::TypeConstraints;
use Module::Find;

our $modules;

__PACKAGE__->load_namespaces;

=head2 load_namespaces

Uses module find to load modules

=cut 

sub load_namespaces {
    $modules = [ useall OpenEHR::Composition::Elements::LabTest ];
}

=head2 compos 

Accessor method to call composition elements by name

=cut

sub compos {
    my ($self, $name)  = @_;
    my $module_name;
    if ($name eq 'LabTest') {
        return __PACKAGE__;
    }
    elsif ($module_name = [grep /$name/, @{ $modules } ] ) {
        return $module_name->[0];
    }
    else {
        croak "$module_name not found";
    }
}

use version; our $VERSION = qv('0.0.2');

enum 'TestStatusName' =>
    [qw( Final Registered Partial Cancelled Corrected Amended Error)];

has requested_test =>
    ( is => 'rw', isa => 'OpenEHR::Composition::Elements::LabTest::RequestedTest' );
has specimens => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::LabTest::Specimen]'
);
has history_origin   => ( is => 'rw', isa => 'DateTime' );
has test_status      => ( is => 'rw', isa => 'TestStatusName' );
has test_status_time => ( is => 'rw', isa => 'DateTime' );
has clinical_info    => ( is => 'rw' );
has test_panels      => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::Elements::LabTest::LabTestPanel]'
);
has conclusion      => ( is => 'rw', isa => 'Str' );
has responsible_lab => ( is => 'rw', isa => 'Str' );
has request_details => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::Elements::LabTest::TestRequestDetails'
);

sub test_status_lookup {
    my $self               = shift;
    my $test_status_lookup = {
        Final => {
            code  => 'at0038',
            value => 'Final',
        },
        Registered => {
            code  => 'at0107',
            value => 'Registered',
        },
        Partial => {
            code  => 'at0037',
            value => 'Partial',
        },
        Cancelled => {
            code  => 'at0074',
            value => 'Cancelled',
        },
        Corrected => {
            code  => 'at0115',
            value => 'Corrected',
        },
        Amended => {
            code  => 'at0040',
            value => 'Amended',
        },
        Error => {
            code  => 'at0116',
            value => 'Entered in error',
        }
    };
    return $test_status_lookup->{ $self->test_status };
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    $self->requested_test->composition_format( $self->composition_format );
    for my $specimen ( @{ $self->specimens } ) {
        $specimen->composition_format( $self->composition_format );
    }
    for my $test_panel ( @{ $self->test_panels } ) {
        $test_panel->composition_format( $self->composition_format );
    }
    $self->request_details->composition_format( $self->composition_format );
    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
    my $composition->{responsible_laboratory} =
        [ { name_of_organisation => $self->responsible_lab } ];
    $composition->{encoding} = [
        {   '|code'        => 'UTF-8',
            '|terminology' => 'IANA_character-sets'
        }
    ];
    for my $panel ( @{ $self->test_panels } ) {
        push @{ $composition->{laboratory_test_panel} }, $panel->compose();
    }
    $composition->{requested_test} = $self->requested_test->compose();
    $composition->{clinical_information_provided} = [ $self->clinical_info ];
    $composition->{test_status}                   = [
        {   '|value'       => $self->test_status_lookup->{value},
            '|terminology' => 'local',
            '|code'        => $self->test_status_lookup->{code},
        }
    ];
    for my $specimen ( @{ $self->specimens } ) {
        push @{ $composition->{specimen} }, $specimen->compose();
    }
    $composition->{conclusion} = [ $self->conclusion ];
    $composition->{time}       = [ DateTime->now->datetime ];
    $composition->{language}   = [
        {   '|terminology' => 'ISO_639-1',
            '|code'        => 'en'
        }
    ];
    $composition->{test_request_details} = $self->request_details->compose();
    $composition->{test_status_timestamp} =
        [ $self->test_status_time->datetime ];
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Laboratory test'
        },
        '@class'            => 'OBSERVATION',
        'subject'           => { '@class' => 'PARTY_SELF' },
        'archetype_node_id' => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
        'encoding'          => {
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => $self->encoding_terminology,
            },
            'code_string' => $self->encoding_code,
            '@class'      => 'CODE_PHRASE'
        },
        'protocol' => {
            'items' => [
                {   'name' => {
                        'value'  => 'Responsible laboratory',
                        '@class' => 'DV_TEXT'
                    },
                    '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.organisation.v1',
                    'archetype_details' => {
                        'rm_version'   => '1.0.1',
                        '@class'       => 'ARCHETYPED',
                        'archetype_id' => {
                            'value'  => 'openEHR-EHR-CLUSTER.organisation.v1',
                            '@class' => 'ARCHETYPE_ID'
                        }
                    },
                    'items' => [
                        {   'name' => {
                                'value'  => 'Name of Organisation',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => $self->responsible_lab,
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        }
                    ]
                },
                $self->request_details->compose(),
            ],
            'archetype_node_id' => 'at0004',
            '@class'            => 'ITEM_TREE',
            'name'              => {
                'value'  => 'Tree',
                '@class' => 'DV_TEXT',
            },
        },
        'language' => {
            '@class'         => 'CODE_PHRASE',
            'code_string'    => $self->language_code,
            'terminology_id' => {
                'value'  => $self->language_terminology,
                '@class' => 'TERMINOLOGY_ID',
            },
        },
        'archetype_details' => {
            'archetype_id' => {
                'value'  => 'openEHR-EHR-OBSERVATION.laboratory_test.v0',
                '@class' => 'ARCHETYPE_ID'
            },
            '@class'     => 'ARCHETYPED',
            'rm_version' => '1.0.1',
        },
        'data' => {
            'name' => {
                '@class' => 'DV_TEXT',
                'value'  => 'Event Series'
            },
            '@class'            => 'HISTORY',
            'archetype_node_id' => 'at0001',
            'origin'            => {
                '@class' => 'DV_DATE_TIME',
                'value'  => '2017-08-21T19:26:52.84+02:00'
            },
            'events' => [
                {   'data' => {
                        '@class' => 'ITEM_TREE',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Tree'
                        },
                        'items' => [
                            $self->requested_test->compose(),
                            {   'name' => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Test status'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    'value' =>
                                        $self->test_status_lookup->{value},
                                    'defining_code' => {
                                        'terminology_id' => {
                                            '@class' => 'TERMINOLOGY_ID',
                                            'value'  => 'local'
                                        },
                                        'code_string' =>
                                            $self->test_status_lookup->{code},
                                        '@class' => 'CODE_PHRASE'
                                    },
                                    '@class' => 'DV_CODED_TEXT'
                                },
                                'archetype_node_id' => 'at0073'
                            },
                            {   'archetype_node_id' => 'at0075',
                                'value'             => {
                                    'value' =>
                                        $self->test_status_time->datetime,
                                    '@class' => 'DV_DATE_TIME'
                                },
                                '@class' => 'ELEMENT',
                                'name'   => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => 'Test status timestamp'
                                }
                            },
                            {   'archetype_node_id' => 'at0100',
                                'name'              => {
                                    '@class' => 'DV_TEXT',
                                    'value' => 'Clinical information provided'
                                },
                                '@class' => 'ELEMENT',
                                'value'  => {
                                    '@class' => 'DV_TEXT',
                                    'value'  => $self->clinical_info,
                                }
                            },
                        ],
                        'archetype_node_id' => 'at0003'
                    },
                    'archetype_node_id' => 'at0002',
                    'time'              => {
                        'value'  => DateTime->now->datetime,
                        '@class' => 'DV_DATE_TIME'
                    },
                    'name' => {
                        'value'  => 'Any event',
                        '@class' => 'DV_TEXT'
                    },
                    '@class' => 'POINT_EVENT'
                }
            ]
        }
    };
    for my $specimen ( @{ $self->specimens } ) {
        push @{ $composition->{data}->{events}->[0]->{data}->{items} },
            $specimen->compose();
    }
    for my $panel ( @{ $self->test_panels } ) {
        push @{ $composition->{data}->{events}->[0]->{data}->{items} },
            $panel->compose();
    }
    if ( $self->conclusion ) {
        my $conclusion = {
            '@class' => 'ELEMENT',
            'value'  => {
                '@class' => 'DV_TEXT',
                'value'  => $self->conclusion,
            },
            'name' => {
                'value'  => 'Conclusion',
                '@class' => 'DV_TEXT'
            },
            'archetype_node_id' => 'at0057'
        };
        push @{ $composition->{data}->{events}->[0]->{data}->{items} },
            $conclusion;
    }
    return $composition;
}

sub compose_flat {
    my $self           = shift;
    my $path           = 'laboratory_result_report/laboratory_test:__TEST__/';
    my $specimen_index = '0';
    my $specimen_comp  = {};
    for my $specimen ( @{ $self->specimens } ) {
        my $composition_fragment = $specimen->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__SPEC__/$specimen_index/;
            $specimen_comp->{$new_key} = $composition_fragment->{$key};
        }
        $specimen_index++;
    }
    my $panel_index = '0';
    my $panel_comp  = {};
    for my $panel ( @{ $self->test_panels } ) {
        my $composition_fragment = $panel->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__PANEL__/$panel_index/;
            $panel_comp->{$new_key} = $composition_fragment->{$key};
        }
        $panel_index++;
    }
    my $composition = {
        $path . 'history_origin'    => $self->history_origin->datetime,
        $path . 'test_status|value' => $self->test_status_lookup->{value},
        $path . 'test_status|code'  => $self->test_status_lookup->{code},
        $path . 'test_status|terminology' => 'local',
        $path . 'test_status_timestamp' => $self->test_status_time->datetime,
        $path . 'clinical_information_provided' => $self->clinical_info,
        $path . 'conclusion'                    => $self->conclusion,
        $path
            . 'responsible_laboratory/name_of_organisation' =>
            $self->responsible_lab,
        %{$panel_comp},
        %{$specimen_comp},
        %{ $self->requested_test->compose() },
        %{ $self->request_details->compose() },
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::LabTest - LabTest composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::LabTest version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::LabTest;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 requested_test

The actual test requested

=head2 specimens

An array of laboratory specimens used to produce the analysis

=head2 history_origin

Datetime value

=head2 test_status

Plain text code for the status of the requested test as a whole. 
Allowed values are: 'Final', 'Registered', 'Partial', 'Cancelled', 
'Corrected', 'Amended' or 'Error',

=head2 test_status_time

Datetime the test status was recorded

=head2 clinical_info

Clinical information available at the time of the result interpretation 
being issued

=head2 test_panels

An array of OpenEHR::Composition::LabTestPanel objects, representing the 
requested test as either an individual analyte or panel/battery of results

=head2 conclusion

Clnical interpretation of the laboratory test result

=head2 responsible_lab

Name of organisation producing the laboratory test result

=head2 request_details
Information of people and organisations involved in generating 
the laboratory test request. Represented as an 
OpenEHR::Composition::TestRequestDetails


=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format

=head2 test_status_lookup

Returns the test_status name based on the objects test_status code


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
OpenEHR::Composition::Elements::LabTest requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

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
