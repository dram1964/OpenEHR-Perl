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
