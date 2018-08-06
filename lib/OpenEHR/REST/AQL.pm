package OpenEHR::REST::AQL;

use Carp;
use Moose;
use JSON;
use Data::Dumper;
use version; our $VERSION = qv('0.0.2');

extends 'OpenEHR::REST';

has resource    => (is => 'rw', isa => 'Str', default => 'query');

has href        => (is => 'rw', isa => 'Str');
has resultset   => (is => 'rw', isa => 'ArrayRef');
has aql         => (is => 'rw', isa => 'Str');
has executedAQL => (is => 'rw', isa => 'Str');
has err_msg     => (is => 'rw', isa => 'Str');
has statement       => (is => 'rw', isa => 'Str', trigger => \&format_statement);

sub format_statement {
    my $self = shift;
    my $statement = shift;
    $statement =~ s/\R//g;
    $self->{statement} = $statement;
    $self->query({aql => $self->statement});
}

sub run_query {
    my $self = shift;
    $self->submit_rest_call();

    if ($self->response_code eq '200') {
        my $response = from_json($self->response);
        $self->href($response->{meta}->{href});
        $self->resultset($response->{resultSet});
        $self->aql($response->{aql});
        $self->executedAQL($response->{executedAql});
        $self->err_msg('');
        return 1;
    } elsif ($self->response_code eq '204') {
	    $self->err_msg('204 Error: Query returned no content');
	    return 0;
    } else {
        print Dumper($self->response_code);
	    $self->err_msg($self->response);
	    return 0;
    }
}

=head2 find_ehr_by_uid

Retrives EHR data for a given composition and adds the result to the 
objects resultset. Resultset will have the following keys: ehrid and
ptnumber

=cut 

sub find_ehr_by_uid {
    my ( $self, $uid ) = @_;
    croak "No UID specified" unless $uid;
    my $statement = << "END_STMT";
    select e/ehr_id/value as ehrid, e/ehr_status/subject/external_ref/id/value as ptnumber from EHR e
    contains Composition c
    where c/uid/value = '$uid'
END_STMT
    $self->statement($statement);
    $self->run_query;
}
    


=head2 find_orders_by_state($state) 

Retrieves all information orders whose state value matches $state
and adds the results to the objects resultset.
Resultset items will have the following keys: 
subject_ehr_id, subject_id, subject_id_type, composition_uid, narrative, order_type,
order_id, unique_message_id, start_date, end_date, data_start_date, data_end_date, 
service_type, current_state, current_state_code, 

=cut

sub find_orders_by_state {
    my ( $self, $state ) = @_;
    croak "No state value specified" unless $state;
    my @states = qw/ planned scheduled completed aborted /;
    my $valid_state = grep( /$state/, @states);
    croak "Invalid state specified: $state" unless $valid_state;
    my $statement = << "END_STMT";
    select 
 e/ehr_id/value as subject_ehr_id,
 e/ehr_status/subject/external_ref/namespace as subject_id_type,
 e/ehr_status/subject/external_ref/id/value as subject_id,
 c/uid/value as composition_uid,
 i/narrative/value as narrative,
 c/name/value as order_type,
 c/composer/name as ordered_by,
 i/uid/value as order_id,
 i/protocol[at0008]/items[at0010]/value/value as unique_message_id,
 i/activities[at0001]/timing/value as start_date,
 i/expiry_time/value as end_date,
 i/activities[at0001]/description[at0009]/items[at0148]/value/value as service_type,
 f/items[at0001]/value/value as data_start_date,
 f/items[at0002]/value/value as data_end_date,
 a/ism_transition/current_state/value as current_state,
 a/ism_transition/current_state/defining_code/code_string as current_state_code
    from EHR e
    contains COMPOSITION c[openEHR-EHR-COMPOSITION.report.v1]
    contains (INSTRUCTION i[openEHR-EHR-INSTRUCTION.request.v0] 
    contains CLUSTER f[openEHR-EHR-CLUSTER.information_request_details_gel.v0]
    and ACTION a[openEHR-EHR-ACTION.service.v0])
    where i/activities[at0001]/description[at0009]/items[at0121]/value = 'GEL Information data request'
    and i/activities[at0001]/description[at0009]/items[at0148]/value/value = 'pathology'
    and a/ism_transition/current_state/value = '$state'
END_STMT
    $self->statement($statement);
    $self->run_query;
}
=head1 REMOVAL
 c/context/start_time/value as data_start_date,
 c/context/end_time/value as data_end_date,
=cut


no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST::AQL - Submit AQL queries via OpenEHR REST API


=head1 VERSION

This document describes OpenEHR::REST::AQL version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::AQL;
    my $query = OpenEHR::REST::AQL->new(
	    statement => "select c/uid/value as uid from Composition c");
    $query->run_query;                  # Submit query
    die ("Error Message: " . $query2->err_msg) if $query2->err_msg;
    $query->resultset->[0]->{uid};      # Access first UID from resultset

    my $aql = "select e/ehr_id/value as ehrId from Ehr e";
    $query->statement($aql);            # Add new statement to aql object
    $query->run_query;                  # Submitted new query


Use this module to set an AQL query statement and then submit
the query via the OpenEHR REST API. Results are stored as 
an ArrayRef of HashRefs in the objects resultset attribute
  
  
=head1 DESCRIPTION

=head1 INTERFACE 

=head1 METHODS

=head2 statement($aql)

Use this method when adding an AQL statement to the object. Method removes
unwanted new lines from multi-line AQL statements, and sets the REST query
string for submitting the statement

=head2 run_query

Runs the query statement stored in the object. 

=head2 format_statement

Internal method triggered when setting the statement attribute either at
construction or afterwards.

=head1 ATTRIBUTES

=head2 href

The href value returned from a successful query response

=head2 aql

The AQL value returned from a successful query response

=head2 executedAQL

The executedAql value returned from a successful query response

=head2 err_msg

Holds the response content in the event that a query was not 
successful. A successful query sets this to the empty string.

=head2 resultset

Holds an arrayref of result values

=head1 DIAGNOSTICS

Check if err_msg is set on the object

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::REST::AQL requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-rest-aql@rt.cpan.org>, or through the web interface at
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
