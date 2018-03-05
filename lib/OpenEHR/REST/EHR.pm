package OpenEHR::REST::EHR;

use warnings;
use strict;
use Carp;
use Moose;
use JSON;
use Data::Dumper;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.2');

has subjectId        => ( is => 'rw', isa => 'Str', required => 0 );
has subjectNamespace => ( is => 'rw', isa => 'Str', required => 0 );
has committerName    => ( is => 'rw', isa => 'Str', required => 0 );

has resource => ( is => 'rw', isa => 'Str', default => 'ehr' );
has ehrId    => ( is => 'rw', isa => 'Str' );
has action   => ( is => 'rw', isa => 'Str' );
has ehrStatus => ( is => 'rw', isa => 'HashRef' );
has err_msg   => ( is => 'rw', isa => 'Str' );

sub find_or_new {
    my $self = shift;
    croak unless $self->subjectId;
    croak unless $self->subjectNamespace;
    croak unless $self->committerName;
    if ( $self->_find_by_subject_id() ) {
        return 1;
    }
    elsif ( $self->_get_new_ehr() ) {
        return 2;
    }
    else {
        croak $self->err_msg;
        return 0;
    }
}

sub find_by_ehrid {
    my ( $self, $ehrid ) = @_;
    $self->resource("ehr/$ehrid");
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->ehrId( $response->{ehrId} );
        $self->action( $response->{action} );
        $self->ehrStatus( $response->{ehrStatus} );
        return 1;
    }
    else {
        $self->ehrId(0);
        $self->action('FAIL');
        $self->err_msg( $self->response );
        return 0;
    }
}

sub _get_new_ehr {
    my $self = shift;
    $self->query(
        {   subjectId        => $self->subjectId,
            subjectNamespace => $self->subjectNamespace,
            committerName    => $self->committerName,
        }
    );
    $self->method('POST');
    $self->submit_rest_call;
    if ( $self->response_code eq '201' ) {
        my $response = from_json( $self->response );
        $self->ehrId( $response->{ehrId} );
        $self->action( $response->{action} );
        return 1;
    }
    else {
        $self->ehrId(0);
        $self->action('FAIL');
        $self->err_msg( $self->response );
        return 0;
    }
}

sub _find_by_subject_id {
    my $self = shift;
    $self->query(
        {   subjectId        => $self->subjectId,
            subjectNamespace => $self->subjectNamespace,
        }
    );
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        my $response = from_json( $self->response );
        $self->ehrId( $response->{ehrId} );
        $self->action( $response->{action} );
        $self->ehrStatus( $response->{ehrStatus} );
        return 1;
    }
    else {
        $self->ehrId(0);
        $self->action('FAIL');
        $self->err_msg( $self->response );
        return 0;
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST::EHR - Interface to EHR endpoint

=head1 VERSION

This document describes OpenEHR::REST::EHR version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::EHR;

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

=head2 ehrId

The id value for an OpenEHR record

=head2 action

The action status returned from a REST call

=head2 ehrStatus

The ehrStatus values returned from a find request

=head2 err_msg

Contains the latest error message if any. Should be tested 
after a call to find methods

=head1 METHODS

=head2 find_or_new

my $ehr = OpenEHR::Model::EHR->new({
	subjectId => '10203040',
	subjectNamespace => 'MyProject'
	committerName => 'Committer Name'};
$ehr->find_or_new()

Searches the database for an EHR record matching specified subjectId and
subjectNamespace. If found, sets EHR object with values found. 
Otherwise will request a new EHR from database and set object with these values.

=head2 find_by_ehrid

Searches the OpenEHR database for the given ehrId. Stores the ehrId in the object or 0 on failure

=head2 _get_new_ehr

Private method used by find_or_new to create a new ehr

=head2 _find_by_subject_id

Private method used by find_or_new to retrieve an existing ehr


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
