package OpenEHR::REST; 

use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use MIME::Base64;
use REST::Client;
use Data::Dumper;
extends 'OpenEHR';

use version; our $VERSION = qv('0.0.1');

enum 'CompositionFormat' => [qw( FLAT STRUCTURED RAW TDD ) ];


has     request_format  => (
    is      =>  'rw', 
    isa     =>  'CompositionFormat', 
    default =>  'STRUCTURED', 
    required => 1, 
);

has     response_format => (
    is      =>  'rw', 
    isa     =>  'CompositionFormat',
);

=head2 auth

base64 encoded string used in REST API authorization header. 
Derived from combination of user and password values in the 
OpenEHR object.

=head2 base_path

Set at object construction to define the base URL for REST API calls.
Should consist of the server URL (e.g. http://example.com:8081/) and
the path for REST calls (e.g. rest/v1/)

=head2 api_path

Holds the current value of the full path to be used for an REST
API call

=head2 user

Holds the username that will be used for authorisation. Defaults
to 'admin'

=head2 password

Holds the plaintext password that will be used for authorisation. 
Defaults to 'admin'

=cut

has auth        => (
    is      =>  'rw', 
    lazy    =>  1, 
    builder =>  'set_auth',
);

has resource    =>  (
    is      =>  'rw', 
    isa     =>  'Str', 
    default => '',
);

has api_path    => ( 
    is      =>  'rw', 
    isa     =>  'Str', 
);

has query       => (
    is      =>  'rw', 
    isa     => 'HashRef',
);

has method      => (
    is      =>  'rw', 
    isa     =>  'Str', 
    default => 'GET',
);

has headers     => (
    is      =>  'rw', 
    isa => 'ArrayRef',
);

has committer_name 	=> (
    is      =>  'rw', 
    isa     =>  'Str', 
    required => 1, 
    default => 'Aupen Ayre',
);

has response    => (
    is      =>  'rw',
);

has response_code => (
    is      =>  'rw', 
    isa     =>  'Str',
);


=head2 submit_rest_call

Submits a REST call and sets the response and response_code attributes.
Expects a hashref of query fields and values and an arrayref of headers.

=cut 

sub submit_rest_call {
    my $self = shift;
    my $data = shift;
    my $query_client = REST::Client->new();
    $query_client->addHeader($self->auth_header);
    if ($self->headers) {
        for my $header (@{$self->headers}) {
            $query_client->addHeader(@{$header});
        }
    }
    if ($self->query) {
        my $query_string = $query_client->buildQuery($self->query);
        $self->set_api_path($self->resource . $query_string);
    }
    else {
        $self->set_api_path($self->resource);
    }
    my $method = $self->method;
    if ($data) {
        $query_client->$method($self->api_path, $data);
    }
    else {
        $query_client->$method($self->api_path);
    }
    #carp $query_client->responseContent();
    $self->response($query_client->responseContent());
    $self->response_code($query_client->responseCode());
}


sub auth_header {
    my $self = shift;
    return @{$self->auth};
}

sub set_auth {
	my ($self, $user, $password) = @_;
	$user = $self->user unless $user;
	$password = $self->password unless $password;
	$self->user($user);
	$self->password($password);
	my $auth = ['Authorization', 
        'Basic ' . encode_base64("$user:$password")];
	$self->auth($auth);
}

sub set_api_path {
    my ($self, $path) = @_;
    my $api_path = $self->base_path;
    $api_path .= $path if $path;
    $self->api_path($api_path); 
} 

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST - Provides utility methods and attributes for OpenEHR REST::Client calls


=head1 VERSION

This document describes OpenEHR::REST version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST;
    my $oe = OpenEHR::REST->new(
	base_path => 'http://www.example.com:8082/rest/v1/'
    );
    $oe->set_auth('username', 'password');
    $oe->api_path('template');

  
  
=head1 DESCRIPTION

This module provides some base settings for constructing REST calls to the OpenEHR
REST API L<https://www.ehrscape.com/api-explorer.html>

=head1 METHODS

=head2 new(base_path => 'http://www.example.com:8081/rest/v1/'

returns a new OpenEHR::REST object. The base_path parameter can
be provided at construction containing the URI for the REST API
of the OpenEHR server. The URI should have a trailing slash. 
If not provided, defaults to the value set in the configuration file 
or L<http://localhost:8081/rest/v1/>

=head2 set_auth($user, $password)

used to change the user and password combination and generate
a new authorisaion token to be sent in the REST API authorizaion header

=head2 set_api_path

Used to set the full path for an API call. Appends the path provided,
if any, to the base_path attribute defined at object creation. 

=head2 auth_header

Returns an array combining user and password suitable for use as the 
parameter for REST::Client->addHeader(@auth_header)

=head1 ATTRIBUTES

=head2 response_format

The format for a composition returned by the server in response
to a REST call

=head2 request_format

The format to be used to construct the composition. Can be one of 
[ FLAT | STRUCTURED | RAW | TDD ]. Currently, only FLAT and
STRUCTURED formats are supported. If the request value is set to 
anything other than 'FLAT', the STRUCTURED format is used.

=head1 DEPENDENCIES

Moose
MIME::Base64
OpenEHR

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-rest@rt.cpan.org>, or through the web interface at
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
