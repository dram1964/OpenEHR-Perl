package OpenEHR::REST::Demographics;

use warnings;
use strict;
use Carp;
use Data::Dumper;
use JSON;
use Moose;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.2');

has resource => ( is => 'rw', isa => 'Str', default => 'demographics' );
has href     => ( is => 'rw', isa => 'Str' );
has action   => ( is => 'rw', isa => 'Str' );
has err_msg  => ( is => 'rw', isa => 'Str' );
has party    => ( is => 'rw', isa => 'HashRef' );
has parties => ( is => 'rw', isa => 'ArrayRef' );

=head2 get_by_ehrid( $ehrid )

Retrieves demographics information for specified ehrid

=cut 

sub get_by_ehrid {
    my ( $self, $ehrid ) = @_;
    $self->resource("demographics/ehr/$ehrid/party");
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->party( $response->{party} );
        $self->action( $response->{action} );
        $self->href( $response->{meta}->{href} );
        $self->err_msg('');
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}

=head2 add_party

Adds demographics information for specified ehrid

=cut 

sub add_party {
    my ( $self, $party ) = @_;
    $self->resource('demographics/party');
    $self->method('POST');
    $self->headers( [ [ 'Content-Type', 'application/json' ] ] );
    $self->submit_rest_call($party);
    if ( $self->response_code eq '201' ) {
        my $response = from_json( $self->response );
        $self->action( $response->{action} );
        $self->href( $response->{meta}->{href} );
        $self->err_msg('');
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}

=head2 update_party($party)

Updates demographics information 

=cut

sub update_party() {
    my ( $self, $party ) = @_;
    $self->resource('demographics/party');
    $self->method('PUT');
    $self->headers( [ [ 'Content-Type', 'application/json' ] ] );
    $self->submit_rest_call($party);
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->action( $response->{action} );
        $self->href( $response->{meta}->{href} );
        $self->err_msg('');
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}

=head2 get_query($params) 

Uses GET to search for matching parties

=cut 

sub get_query() {
    my ($self) = @_;
    $self->resource('demographics/party/query');
    $self->method('GET');
    $self->query( $self->query ); 
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->action( $response->{action} );
        $self->href( $response->{meta}->{href} );
        $self->err_msg('');
        $self->parties( $response->{parties} );
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}

=head2 post_query([{key => $key, value => $value}])

Uses POST to search for matching parties

=cut 

sub post_query() {
    my ( $self, $params ) = @_;
    $params = to_json($params);
    $self->resource('demographics/party/query');
    $self->method('POST');
    $self->headers( [ [ 'Content-Type', 'application/json' ] ] );
    $self->submit_rest_call($params);
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->action( $response->{action} );
        $self->href( $response->{meta}->{href} );
        $self->err_msg('');
        $self->parties( $response->{parties} );
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}


=head2 delete_party($party_id)

Deletes a party by party_id

=cut 

sub delete_party() {
    my ($self, $party_id) = @_; 
    $self->resource("demographics/party/$party_id");
    $self->method('DELETE');
    $self->submit_rest_call;
    if ( $self->response_code eq '200') {
        my $response = from_json( $self->response );
        $self->action( $response->{action} );
        $self->err_msg('');
        return 1;
    }
    else {
        carp $self->response_code;
        $self->err_msg( $self->response );
        return 0;
    }
}


no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST::Demographics - [One line description of module's purpose here]


=head1 VERSION

This document describes OpenEHR::REST::Demographics version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::Demographics;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


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
  
OpenEHR::REST::Demographics requires no configuration files or environment variables.


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
C<bug-openehr-rest-demographics@rt.cpan.org>, or through the web interface at
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
