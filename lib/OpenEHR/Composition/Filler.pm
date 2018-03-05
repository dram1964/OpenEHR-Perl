package OpenEHR::Composition::Filler;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has order_number => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);
has issuer => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => 'UCLH Pathology',

);
has assigner => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => 'Winpath',
);
has type => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => 'local',
);

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
        '|assigner' => $self->assigner,
        '|issuer'   => $self->issuer,
        '|id'       => $self->order_number,
        '|type'     => $self->type,
    };
    return $composition;
}

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
        $path . 'filler_order_number'          => $self->order_number,
        $path . 'filler_order_number|issuer'   => $self->issuer,
        $path . 'filler_order_number|assigner' => $self->assigner,
        $path . 'filler_order_number|type'     => $self->type,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Filler - Filler composition element


=head1 VERSION

This document describes OpenEHR::Composition::Filler version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Filler;
    my $filler = OpenEHR::Composition::Filler->new({
        order_number    => '17V111333',
        assigner        => 'Winpath',
        issuer          => 'UCLH',
        type            => 'local',
        composition_format => 'FLAT',
    });

    my $filler_hashref = $filler->compose;

  
=head1 DESCRIPTION

Used to create a hashref element of a filler for insertion into a
composition object. The filler element contains details from the 
pathology system used to record the order


=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 order_number

Identifier issued by the Laboratory system to track the test results
associated with a request

=head2 issuer

Organisation responsible for issuing the order number on the 
performing laboratory system. Defaults to 'UCLH Pathology'

=head2 assigner 

System used to generate the laboratory order number. Defaults
to 'Winpath'

=head2 type

Type of order identifier issued. Defaults to 'local'

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

OpenEHR::Composition::Filler requires no configuration files or 
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
