package OpenEHR::Composition::Placer;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.1');

has order_number => (
    is          =>  'rw', 
    isa         =>  'Str',
    required    =>  1,
);
has issuer => (
    is          =>  'rw', 
    isa         =>  'Str',
    required    =>  1,
    default     =>  'UCLH',

);
has assigner => (
    is          =>  'rw', 
    isa         =>  'Str',
    required    =>  1,
    default     =>  'TQuest',
);
has type => (
    is          =>  'rw', 
    isa         =>  'Str',
    required    =>  1,
    default     =>  'local',
);


sub compose {
    my $self = shift;
    $self->composition_format('RAW') if ($self->composition_format eq 'TDD');

    my $formatter = 'compose_' . lc($self->composition_format);
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
    my $composition = {
                '|assigner' => $self->assigner,
                '|issuer'   => $self->issuer,
                '|id'       => $self->order_number,
                '|type'     => $self->type,
    };
    return $composition;
}

sub compose_raw {
    my $self = shift;
    my $composition = {
        'value' => {
            'type' => $self->type,
            '@class' => 'DV_IDENTIFIER',
            'id' => $self->order_number,
            'issuer' => $self->issuer,
            'assigner' => $self->assigner,
        },
        '@class' => 'ELEMENT',
        'archetype_node_id' => 'at0062',
        'name' => {
            'value' => 'Placer order number',
            '@class' => 'DV_TEXT'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path = 'laboratory_result_report/laboratory_test:__TEST__/test_request_details/';
    my $composition = {
        $path . 'placer_order_number' => $self->order_number,
        $path . 'placer_order_number|issuer' => $self->issuer,
        $path . 'placer_order_number|assigner' => $self->assigner,
        $path . 'placer_order_number|type' => $self->type,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Placer - Placer composition element

=head1 VERSION

This document describes OpenEHR::Composition::Placer version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Placer;
    my $placer = OpenEHR::Composition::Placer->new({
        order_number    => 'TQ003339999',
        assigner        => 'TQuest',
        issuer          => 'UCLH',
        type            => 'local',
        composition_format => 'FLAT',
    });

    my $placer_hashref = $placer->compose;

  
=head1 DESCRIPTION

Used to create a placer element for insertion into a composition
object. When used as part of a Pathology Report composition, the 
placer element contains identifier data from the ordering system
used to place the order.

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 order_number

Identifier assigned to the Laboratory Test order by the ordering
system

=head2 issuer

Organisation from whence the order is issued. Defaults to 'UCLH'

=head2 assigner

System used to generate the order. Defaults to 'TQuest'=> (

=head2 type

Type of identifier issued. Defaults to 'local'

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
  
OpenEHR::Composition::Placer requires no configuration files or environment variables.


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
C<bug-openehr-composition-placer@rt.cpan.org>, or through the web interface at
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
