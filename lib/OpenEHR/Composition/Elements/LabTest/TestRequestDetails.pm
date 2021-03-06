package OpenEHR::Composition::Elements::LabTest::TestRequestDetails;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use version; our $VERSION = qv('0.0.2');

has placer =>
  ( is => 'rw', isa => 'OpenEHR::Composition::Elements::LabTest::Placer' );
has filler =>
  ( is => 'rw', isa => 'OpenEHR::Composition::Elements::LabTest::Filler' );
has requester =>
  ( is => 'rw', isa => 'OpenEHR::Composition::Elements::LabTest::Requester' );

sub compose {
    my $self = shift;
    $self->composition_format('RAW') if ( $self->composition_format eq 'TDD' );
    $self->placer->composition_format( $self->composition_format ) if $self->placer;
    $self->filler->composition_format( $self->composition_format );
    $self->requester->composition_format( $self->composition_format );
    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = [
        {
            filler_order_number => [ $self->filler->compose ],
        }
    ];
    if ( $self->requester ) {
        $composition->[0]->{requester} = $self->requester->compose;
    }
    if ( $self->placer ) {
        $composition->[0]->{placer_order_number} = [ $self->placer->compose ];
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'at0094',
        'items'             => [ $self->filler->compose(), ],
        'name'              => {
            '@class' => 'DV_TEXT',
            'value'  => 'Test request details'
        },
        '@class' => 'CLUSTER'
    };
    if ( $self->requester ) {
        push @{ $composition->{items} }, $self->requester->compose();
    }
    if ( $self->placer ) {
        push @{ $composition->{items} }, $self->placer->compose();
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = { %{ $self->filler->compose() }, };
    if ( $self->requester ) {
        $composition = { %{$composition}, %{ $self->requester->compose } };
    }
    if ( $self->placer ) {
        $composition = { %{$composition}, %{ $self->placer->compose } };
    }

    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::LabTest::TestRequestDetails - [One line description of module's purpose here]


=head1 VERSION

This document describes OpenEHR::Composition::Elements::LabTest::TestRequestDetails version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::LabTest::TestRequestDetails;

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

=head2  placer

Information about the party requesting the pathology test represented
as an OpenEHR::Composition::Elements::LabTest::Placer object

=head2 filler

Information about the party performing the pathology test represented
as an OpenEHR::Composition::Elements::LabTest::Filler object

=head2 requester 
Information about the party ordering the pathology test represented
as an OpenEHR::Composition::Elements::LabTest::Requester object

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
  
OpenEHR::Composition::Elements::LabTest::TestRequestDetails requires no configuration files or environment variables.


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
C<bug-openehr-composition-testrequestdetails@rt.cpan.org>, or through the web interface at
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
