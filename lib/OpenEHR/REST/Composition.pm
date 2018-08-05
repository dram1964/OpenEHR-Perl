package OpenEHR::REST::Composition;

use warnings;
use strict;
use Carp;
use Moose; 
use JSON;
use Data::Dumper;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.2');

has     resource        => (
    is      =>  'rw', 
    isa     =>  'Str', 
    default =>  'composition',
);
has 	composition     => (
    is      =>  'rw',
    isa     => 'OpenEHR::Composition',
);
has     composition_response => (
    is      => 'rw',
);
has     compositionUid  => (
    is      =>  'rw', 
    isa     =>  'Str',
);
has     action          => (
    is      =>  'rw', 
    isa     => 'Str',
);
has     href	        => (
    is      =>  'rw', 
    isa     => 'Str',
);
has     err_msg         => (
    is      =>  'rw', 
    isa     =>  'Str',
);
has     template_id	    => (is  =>  'rw');
has     deleted	        => (is  =>  'rw');
has     lastVersion     => (is  =>  'rw');

sub find_by_uid {
	my $self = shift; 
	my $compositionUid = shift;
    $self->query({format => $self->request_format});
	if ($self->request_format eq 'TDD') {
        $self->headers([['Accept', 'application/xml']]);
	}
    else {
        $self->headers([['Accept', 'application/json']]);
	}
    $self->resource('composition/' . $compositionUid);
    $self->submit_rest_call;
    if ($self->response_code eq '200') {
		my $query_response;
		if ($self->request_format eq 'TDD') {
			$self->err_msg('XML responses from TDD not handled yet');
			$self->template_id('XML responses from TDD not handled yet');
            $self->response_format('TDD');
			$self->composition_response($self->response);
			$self->deleted(0);
			$self->lastVersion(0);
		} else {
			$query_response = from_json($self->response);
			$self->response_format($query_response->{format});
			$self->template_id($query_response->{templateId});
			$self->composition_response($query_response->{composition});
			$self->deleted($query_response->{deleted});
			$self->lastVersion($query_response->{lastVersion});
		    $self->href($query_response->{meta}->{href});
		}
		return 1;
	} else {
			$self->err_msg($self->response);
		carp "*** Error Unhandled Response Code: " . $self->response_code . " ***";
	}
}

sub update_by_uid {
	my $self = shift;
	my $compositionUid = shift;
    if ($self->composition->composition_format eq 'RAW') {
        $self->query({
            format => $self->composition->composition_format,
            committer => $self->composition->composer_name,
        });
    }
    else {
        $self->query({
            templateId => $self->template_id, #'GEL - Generic Lab Report import.v0',
            format => $self->composition->composition_format,
            committer => $self->composition->composer_name,
        });
    }
    $self->resource('composition/' . $compositionUid);
    $self->headers([['Content-Type', 'application/json']]);
    $self->method('PUT');
    #$self->submit_rest_call($self->composition);
    $self->submit_rest_call( to_json( $self->composition->compose() ) );
    if ($self->response_code eq '200') {
		my $post_response = from_json( $self->response);
		$self->compositionUid($post_response->{compositionUid});
		$self->action($post_response->{action});
		$self->href($post_response->{meta}->{href});
		return 1;
	} else {
		carp "Response Code: " . $self->response_code;
		carp "Composition: " . $self->composition;
		$self->err_msg($self->response);
        carp $self->err_msg;
		return 0;
	}
}
	
sub submit_new {
	my $self = shift;
	my $ehrId = shift;
    if ($self->composition->composition_format eq 'RAW') {
        $self->query({
            ehrId => $ehrId,
            format => $self->composition->composition_format,
            committer => $self->composition->composer_name,
        });
    }
    else {
        $self->query({
            ehrId => $ehrId,
            format => $self->composition->composition_format,
            committer => $self->composition->composer_name,
            templateId => $self->template_id,
        });
    }

    $self->headers([['Content-Type', 'application/json']]);
    $self->method('POST');
    $self->submit_rest_call( to_json( $self->composition->compose() ) );
    if ($self->response_code eq '201') {
		my $post_response = from_json( $self->response);
		$self->compositionUid($post_response->{compositionUid});
		$self->action($post_response->{action});
		$self->href($post_response->{meta}->{href});
		return 1;
	} else {
		carp "Response Code: " . $self->response_code;
		carp "Composition: " . $self->composition->compose();
		$self->err_msg($self->response);
		return 0;
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;


__END__

=head1 NAME

OpenEHR::REST::Composition - Used for managing Compositions
in the 'GEL - Generic Lab Report import.v0' template format. 


=head1 VERSION

This document describes OpenEHR::REST::Composition version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::Composition;

    my $path_report1 = OpenEHR::REST::Composition->new();
    $path_report->composition($labreport); # add a composition object

    $path_report1->submit_new($ehr->ehrId);
    warn ("Error occurred in submission: " . $path_report1->err_msg)
        if $path_report1->err_msg;
    $path_report1->action; # 'CREATE' if successful;
    $path_report1->compositionUid # the returned CompositionUid;
    $path_report1->href # URL to view the submitted composition;


=head1 DESCRIPTION

Use this module to submit and modify Pathology compositions in the
'GEL - Generic Lab Report import.v0' template format.


=head1 METHODS

=head2 submit_new($ehrId)

Submits the composition as a new composition to the database 
for the specified ehrId in the format specified by the second parameter. 
Currently only FLAT and STRUCTURED formats are supported

=head2 find_by_uid($uid)

Search the OpenEHR database for a composition with uid value of $uid.
A successful query will save the composition returned in the object's
composition attribute in the format specified by the second parameter. 
Format can be one of: [RAW, STRUCTURED, FLAT, TDD]. If the query results 
is unsuccessful then err_msg is set to the response content. 
The TDD format is not currently implemented and requests for TDD 
format compositions will also set the err_msg value. 
 
Successful queries set the objects response_format to indicate
the template format; the template_id; the composition_response to
the actual composition; the href property to the path to display the 
composition; and the deleted and lastVersion attributes with the 
corresponding composition attributes

=head2 update_by_uid($uid)

Submits an update to an existing composition. The UID must be specified as the 
methods only parameter.


=head1 ATTRIBUTES

=head2 composition

The composition data for the object in the specified format

=head2 composition_response

composition item returned from the server converted to hashref

=head2 compositionUid

The UID value for the requested composition. 

=head2 action

The action value returned by the server in response to a REST call

=head2 href

The href values returned by the server in response to a REST call

=head2 err_msg

Failed calls to the REST server, will stored the response content
in the err_msg attribute. This value should be tested following each 
REST call

=head2 template_id

The template_id value returned by the server in response to a REST call

=head2 response_format

The format for a composition returned by the server in response
to a REST call

=head2 deleted

The deleted value returned by the server in response to a REST call

=head2 lastVersion

The lastVersion value returned by the server in response to a REST call
  

=head1 PRIVATE ATTRIBUTES

=head2 resource 

The path relative to base_path to be used in the REST call


=head1 DIAGNOSTICS

Use the err_msg attribute of the object to check for errors following a REST call


=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::REST::Composition requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-rest-pathologyreport@rt.cpan.org>, or through the web interface at
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
