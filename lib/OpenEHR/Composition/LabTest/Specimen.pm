package OpenEHR::Composition::LabTest::Specimen;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use DateTime;

use version; our $VERSION = qv('0.0.2');

has specimen_type      => ( is => 'rw', isa => 'Str' );
has datetime_collected => ( is => 'rw', isa => 'DateTime' );
has collection_method  => ( is => 'rw', isa => 'Str' );
has datetime_received  => ( is => 'rw', isa => 'DateTime' );
has spec_id            => ( is => 'rw', isa => 'Str' );
has spec_issuer => ( is => 'rw', isa => 'Str', default => 'UCLH Pathology' );
has spec_assigner => ( is => 'rw', isa => 'Str', default => 'Winpath' );
has spec_type     => ( is => 'rw', isa => 'Str', default => 'local' );

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
        collection_method  => [ $self->collection_method ],
        datetime_collected => [ $self->datetime_collected->datetime ],
        specimen_type      => [ $self->specimen_type ],
        processing         => [
            {   laboratory_specimen_identifier => [
                    {   '|issuer'   => $self->spec_issuer,
                        '|assigner' => $self->spec_assigner,
                        '|type'     => $self->spec_type,
                        '|id'       => $self->spec_id,
                    },
                ],
                datetime_received => [ $self->datetime_received->datetime ],
            },
        ],
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'items' => [
            {   'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->specimen_type,
                },
                '@class' => 'ELEMENT',
                'name'   => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Specimen type',
                },
                'archetype_node_id' => 'at0029',
            },
            {   'value' => {
                    'value'  => $self->datetime_collected->datetime,
                    '@class' => 'DV_DATE_TIME',
                },
                '@class' => 'ELEMENT',
                'name'   => {
                    'value'  => 'Datetime collected',
                    '@class' => 'DV_TEXT',
                },
                'archetype_node_id' => 'at0015',
            },
            {   'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Collection method'
                },
                'value' => {
                    '@class' => 'DV_TEXT',
                    'value'  => $self->collection_method,
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0007',
            },
            {   'archetype_node_id' => 'at0046',
                'items'             => [
                    {   'archetype_node_id' => 'at0034',
                        'value'             => {
                            'value'  => $self->datetime_received->datetime,
                            '@class' => 'DV_DATE_TIME',
                        },
                        '@class' => 'ELEMENT',
                        'name'   => {
                            '@class' => 'DV_TEXT',
                            'value'  => 'Datetime received',
                        },
                    },
                    {   'archetype_node_id' => 'at0001',
                        'value'             => {
                            '@class'   => 'DV_IDENTIFIER',
                            'assigner' => $self->spec_assigner,
                            'type'     => $self->spec_type,
                            'issuer'   => $self->spec_issuer,
                            'id'       => $self->spec_id
                        },
                        '@class' => 'ELEMENT',
                        'name'   => {
                            'value'  => 'Laboratory specimen identifier',
                            '@class' => 'DV_TEXT',
                        }
                    }
                ],
                'name' => {
                    'value'  => 'Processing',
                    '@class' => 'DV_TEXT'
                },
                '@class' => 'CLUSTER'
            }
        ],
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.specimen.v0',
        'archetype_details' => {
            'rm_version'   => '1.0.1',
            '@class'       => 'ARCHETYPED',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-CLUSTER.specimen.v0',
                '@class' => 'ARCHETYPE_ID'
            }
        },
        '@class' => 'CLUSTER',
        'name'   => {
            '@class' => 'DV_TEXT',
            'value'  => 'Specimen'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path =
        'laboratory_result_report/laboratory_test:__TEST__/specimen:__SPEC__/';
    my $composition = {
        $path . 'specimen_type'      => $self->specimen_type,
        $path . 'datetime_collected' => $self->datetime_collected->datetime,
        $path . 'collection_method'  => $self->collection_method,
        $path
            . 'processing/datetime_received' =>
            $self->datetime_received->datetime,
        $path . 'processing/laboratory_specimen_identifier' => $self->spec_id,
        $path
            . 'processing/laboratory_specimen_identifier|issuer' =>
            $self->spec_issuer,
        $path
            . 'processing/laboratory_specimen_identifier|assigner' =>
            $self->spec_assigner,
        $path
            . 'processing/laboratory_specimen_identifier|type' =>
            $self->spec_type,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::LabTest::Specimen - [One line description of module's purpose here]


=head1 VERSION

This document describes OpenEHR::Composition::LabTest::Specimen version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::LabTest::Specimen;

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

=head2 specimen_type

The type of specimen collected

=head2 datetime_collected

The date and time that the specimen was collected as a DateTime object

=head2 collection_method

The method used to collect the specimen

=head2 datetime_received

The date and time that the specimen was received in the laboratory

=head2 spec_id

The identifier issued by the laboratory to identify the specimen

=head2 spec_issuer

Organisation name of the laboratory issuing the specimen identifier.
Defaults to 'UCLH Pathology'

=head2 spec_assigner

Laboratory System used to assign the specimen identifier. 
Defaults to 'Winpath'

=head2 spec_type

Type of identifier used to identify the specimen. 
Defaults to 'local'


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
  
OpenEHR::Composition::LabTest::Specimen requires no configuration files or environment variables.


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
C<bug-openehr-composition-specimen@rt.cpan.org>, or through the web interface at
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
