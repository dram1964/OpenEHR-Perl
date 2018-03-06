package OpenEHR::REST::Template;

use Carp;
use Moose;
use JSON;
use URI::Encode;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.2');

has resource => ( is => 'rw', isa => 'Str', default => 'template' );

has data    => ( is => 'rw', isa => 'HashRef' );
has xml     => ( is => 'rw', isa => 'Str' );
has err_msg => ( is => 'rw', isa => 'Str' );

sub get_all_template_ids {
    my $self = shift;
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        $self->data( from_json( $self->response ) );
    }
    else {
        $self->err_msg( $self->response );
        carp "*** Error Response Code: " . $self->response_code . " ***";
    }
}

sub get_web_template {
    my $self       = shift;
    my $templateId = shift;
    my $uri        = URI::Encode->new();
    $templateId = $uri->encode($templateId);
    $self->resource( $self->resource . "/" . $templateId );
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        $self->data( from_json( $self->response ) );
    }
    else {
        $self->err_msg( $self->response );
        carp "*** Error Response Code: " . $self->response_code . " ***";
    }
}

sub get_template_example {
    my $self          = shift;
    my $templateId    = shift;
    my $format        = shift || 'STRUCTURED';
    my $exampleFilter = shift || 'INPUT';
    my $uri           = URI::Encode->new();
    $templateId = $uri->encode($templateId);
    $self->query(
        {   format        => $format,
            exampleFilter => $exampleFilter
        }
    );
    $self->resource("template/$templateId/example");
    $self->submit_rest_call;

    if ( $self->response_code eq '200' ) {
        $self->data( from_json( $self->response ) );
    }
    else {
        $self->err_msg( $self->response );
        carp "*** Error Response Code: " . $self->response_code . " ***";
    }
}

sub get_template_xml {
    my $self       = shift;
    my $templateId = shift;
    my $uri        = URI::Encode->new();
    $templateId = $uri->encode($templateId);
    $self->resource("template/$templateId/opt");
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        $self->xml( $self->response );
    }
    else {
        $self->err_msg( $self->response );
        carp "*** Error Response Code: " . $self->response_code . " ***";
    }
}

sub get_template_xsd {
    my $self       = shift;
    my $templateId = shift;
    my $uri        = URI::Encode->new();
    $templateId = $uri->encode($templateId);
    $self->resource("template/$templateId/xsd");
    $self->submit_rest_call;
    if ( $self->response_code eq '200' ) {
        $self->xml( $self->response );
    }
    else {
        $self->err_msg( $self->response );
        carp "*** Error Response Code: " . $self->response_code . " ***";
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::REST::Template - Submit Think!EHR REST API /template calls


=head1 VERSION

This document describes OpenEHR::REST::Template version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::Template;
    my $query = OpenEHR::REST::Template->new();
    my $templateId = 'GEL - Data request Summary.v1';
    $query->get_web_template($templateId);
    if ($query->err_msg) {
        warn "REST Query failed: $query->err_msg";
    else {
        print $query->data;
    }

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

=head1 METHODS

=head2 get_all_template_ids

Returns array of hashes for all templates on the server. Each hash
will contain the following keys
Implements GET call to '/template' REST endpoint.

=over 4

=item templateId

The name of the template

=item createdOn

The date the template was created

=back

=cut 

=head2 get_web_template ( $template_id )

Retrieves a RAW JSON representation of a template and stores this as a 
hashref in the object's data property. The RAW JSON representation
for the template can be used as a source of documentation for the
template.
Implements GET request to the '/template/{templateId}' REST endpoint.


=head2 get_template_example ($template_id, [ $format, $example_filter])

Retrieves an example for the requested template_id with dummy data filled-in
and stores this in the 'data' property of the object. The format can be 
specified in the optional second parameter as one of 'RAW', 'STRUCTURED',
'FLAT' or 'TDD'. Only 'FLAT' and 'STRUCTURED' values work at the moment. 
Requesting either 'RAW' or 'TDD' will result in a response in 
'STRUCTURED' format. The example returned can be filtered to represent either 
an 'INPUT' or 'OUTPUT' template using the third parameter.
Implements a GET request to the /template/{templateId}/example' REST endpoint.

=head2 get_template_xml ($template_id)

Retrieves an OpenEHR operational template for the specified template_id
and stores this in the object's 'xml' property. The xml attribute
can be used as a source of documentation for the specified template.
Implements a GET request to '/template/{template_id}/opt' REST endpoint

=head2 get_template_xsd

Retrieves an XSD for the specified template and stores this in the object's
'xml' property. 
Implements a GET request to '/template/{template_id}/xsd' REST endpoint

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
  
OpenEHR::REST::Template requires no configuration files or environment variables.


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
C<bug-openehr-rest-template@rt.cpan.org>, or through the web interface at
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
