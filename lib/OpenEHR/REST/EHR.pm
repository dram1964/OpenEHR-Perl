package OpenEHR::REST::EHR;

use warnings;
use strict;
use Carp;
use Moose;
use JSON;
use Data::Dumper;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.2');

has subject_id => ( is => 'rw', isa => 'Str' );
has subject_namespace =>
  ( is => 'rw', isa => 'Str', trigger => \&_check_namespace );
has committer_name => ( is => 'rw', isa => 'Str' );
has committer_id   => ( is => 'rw', isa => 'Str' );

has resource => ( is => 'rw', isa => 'Str', default => 'ehr' );

has ehr_id  => ( is => 'ro', isa => 'Str', writer => '_set_ehr_id' );
has action  => ( is => 'ro', isa => 'Str', writer => '_set_action' );
has err_msg => ( is => 'ro', isa => 'Str', writer => '_set_err_msg' );
has href    => ( is => 'ro', isa => 'Str', writer => '_set_href' );
has ehr_status => (
    is     => 'ro',
    isa    => 'HashRef',
    writer => '_set_ehr_status',
);

sub _check_namespace {
    my ( $self, $namespace, $old_namespace ) = @_;
    if ( $namespace eq 'uk.nhs.nhs_number' ) {
        if ($self->subject_id !~ /^\d{10,10}$/) {
            croak 'Invalid NHS Number Specified: ' . $self->subject_id;
        }
    }
}

sub find_or_new {
    my $self = shift;
    $self->_check_query;
    if ( $self->find_by_subject_id() ) {
        return 1;
    }
    elsif ( $self->get_new_ehr() ) {
        return 1;
    }
    else {
        return 0;
    }
}

sub get_new_ehr {
    my $self = shift;
    $self->query(
        {
            subjectId        => $self->subject_id,
            subjectNamespace => $self->subject_namespace,
            committerName    => $self->committer_name,
            committerId      => $self->committer_id,
        }
    );
    $self->method('POST');
    $self->submit_rest_call;
    if ( $self->response_code eq '201' ) {
        my $response = from_json( $self->response );
        $self->_set_ehr_id( $response->{ehrId} );
        $self->_set_action( $response->{action} );
        $self->_set_href( $response->{meta}->{href} );
        return 1;
    }
    else {
        $self->_set_ehr_id(0);
        $self->_set_action('FAIL');
        $self->_set_err_msg( $self->response );
        return 0;
    }
}

sub find_by_subject_id {
    my $self = shift;
    $self->query(
        {
            subjectId        => $self->subject_id,
            subjectNamespace => $self->subject_namespace,
        }
    );
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->_set_ehr_id( $response->{ehrId} );
        $self->_set_action( $response->{action} );
        $self->_set_ehr_status( $response->{ehrStatus} );
        $self->_set_href( $response->{meta}->{href} );
        return 1;
    }
    else {
        $self->_set_ehr_id(0);
        $self->_set_action('FAIL');
        $self->_set_err_msg( $self->response );
        return 0;
    }
}

sub find_by_ehrid {
    my ( $self, $ehr_id ) = @_;
    $self->resource("ehr/$ehr_id");
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->_set_ehr_id( $response->{ehrId} );
        $self->_set_action( $response->{action} );
        $self->_set_ehr_status( $response->{ehrStatus} );
        $self->_set_href( $response->{meta}->{href} );
        return 1;
    }
    else {
        $self->_set_ehr_id(0);
        $self->_set_action('FAIL');
        $self->_set_err_msg( $self->response );
        return 0;
    }
}

sub update_ehr_status {
    my ( $self, $status ) = @_;
    $self->resource( 'ehr/' . $self->ehr_id . '/status' );
    $self->headers( [ [ 'Content-Type', 'application/json' ] ] );
    $self->method('PUT');
    $self->submit_rest_call( to_json($status) );
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->_set_action( $response->{action} );
        $self->_set_href( $response->{meta}->{href} );
        return 1;
    }
    elsif ( $self->response_code eq '500' ) {
        $self->_set_action('DUPLICATE');
        $self->_set_err_msg( 'Server Response: '
              . $self->response_code
              . "\nEHR status already in use for another EHR" );
        return 0;
    }
    else {
        $self->_set_action('FAIL');
        $self->_set_err_msg( 'Server Response: '
              . $self->response_code . "\n"
              . $self->response );
        return 0;
    }
}

sub _check_query {
    my $self = shift;
    croak 'No subjectId specified in query' unless $self->subject_id;
    croak 'No subjectNamespace specified in query'
      unless $self->subject_namespace;
    return 1;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST::EHR - Interface to /ehr REST endpoint

=head1 VERSION

This document describes OpenEHR::REST::EHR version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::REST::EHR;

    my $ehr = OpenEHR::Model::EHR->new(
        {   subjectId        => '10203040',
            subjectNamespace => 'MyProject',
            committerName    => 'Committer Name',
            commmitterId     => 'comnam1',
        }
    );
    $ehr->find_or_new()
        or die "Something went awry: " . $ehr->err_msg();
    if ( $ehr->action eq 'CREATE' ) {
        say "New ehr created. ID: ", $ehr->ehr_id;
    }
    elsif ( $ehr->action eq 'RETRIEVE' ) {
        say "Found ehr for subject. ID: ", $ehr->ehr_id;
    }
    else {
        say "Query action: ", $ehr->action;
    }

=head1 DESCRIPTION

Implements REST calls for creating, retrieving and updating Ehr records
from an OpenEHR system

=head1 INTERFACE 

=head1 METHODS

=head2 new ( [%subject] )

Constructs a new OpenEHR::REST::EHR object. Takes an optional hash or 
hash reference containing subject data. The hash keys can be used
as both get/set accessors. The keys are:

=over 4

=item subject_id 

The subject identifier used outside the OpenEHR system

=item subject_namespace

The namespace issuing the subjectId value

=item committer_name

The name of the person committing the ehr record

=item committer_id

The identifier of the person committing the ehr record

=back

=head2 find_or_new 

Searches the OpenEHR system for an EHR record matching the OpenEHR::REST::EHR
object's subject_id and subject_namespace properties or requests an new EHR 
record using these values and optionally the committer_name and committer_id
properties.

Sets the ehrId and ehrStatus properties with values returned from the search.
If an existing record is found, the action property is set to the value 
'RETRIEVE'. If a new record is created, then the action property is set to 
'CREATE'. 

This is a wrapper method that first calls find_by_subject_id() and, 
if that fails, calls get_new_ehr().

=head2 find_by_subject_id

Searches the database for an EHR record matching the subject_id and 
subject_namespace properties of the OpenEHR::REST::EHR object.
If a record is found, then the ehrId and ehrStatus properties are set 
to the values returned from the search and the action property is set to 
'RETRIEVE'. If no record is found, then ehrId is set to zero, action is set to 'FAIL' 
and err_msg is set to the error message returned from the server.
Implements a GET request to '/ehr' endpoint.

=head2 get_new_ehr

Requests a new ehr record from database using the subject_id and 
subject_namespace properties of the OpenEHR::REST::EHR object and, optionally, 
using the committer_name and committer_id properties of the object. 
Implements a POST request to '/ehr' endpoint.

=head2 find_by_ehrid($ehr_id)

Searches the OpenEHR database for an EHR matching the given ehr_id value. 
If a record is found, sets the ehr_id and ehr_status in the object, and
set the object's action property to 'RETRIEVE'. If the search fails to 
find a matching record the ehr_id is set to zero in the object, the action
property is set to 'FAIL' and the err_msg property is set to the error
message returned by the server.
Implements a GET request to '/ehr/{ehrid}'

=head2 update_ehr_status (%status)

Updates the ehrStatus of an ehr. Requires a hash or hashref specify the
ehrStatus values to update. The hash keys can be any combination of:

=over 4

=item subjectId

The subject identifier used outside the OpenEHR system

=item subjectNamespace

The namespace issuing the subjectId value

=item queryable

Boolean value to indicate if the EHR is queryable

=item modifiable

Boolean value to indicate if the EHR is modifiable

=back

If the call succeeds the action property is set to 'UPDATE' and the
href property will contain a link to the the updated EHR. Method 
will fail if you try to add an ehrStatus to an EHR when these values
are already in use for another EHR. If you encounter this error the 
action property is set to 'DUPLICATE'. For other errors the action 
property is set to 'FAIL' and err_msg is set to the server response.
Implements a PUT request to '/ehr/{ehrid}/status'


=head1 ATTRIBUTES

=head2 ehr_id

Read-only string used to hold the ehrid/uid/value returned by the server

=head2 action

Read-only string holding the action status returned by the server

=head2 ehr_status

Read-only hashref holding the ehrStatus returned by the server

=head2 err_msg

Read-only string that contains the latest error message, if any, 
returned by a failed REST call.

=head2 href

Read-only string that holds the href value returned by the server

=head2 resource

Used to get or set the relative path for the REST call. Default value
is '/ehr'.

=head2 subject_id 

Holds the subject identifier used outside the OpenEHR system. Corresponds to
the e/ehr_status/subject/external_ref/id/value field in OpenEHR

=head2 subject_namespace

Holds the namespace issuing the subject id. Corresponds to
the e/ehr_status/subject/external_ref/id/namespace field in OpenEHR

=head2 committer_name

The name of the person committing the ehr record

=head2 committer_id

The identifier of the person committing the ehr record

=head1 DIAGNOSTICS

Check the value of $ehr->action. If this equals 'FAIL', then something went wrong. Check
the value of $ehr->err_msg to see the error message from the server response

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::REST::EHR requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-rest-ehr@rt.cpan.org>, or through the web interface at
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
