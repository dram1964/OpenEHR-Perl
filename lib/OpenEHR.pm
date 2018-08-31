package OpenEHR;

use Carp;
use Moose;
use Config::Simple;

use version; our $VERSION = qv('0.0.2');

my $config_file =
    ( -f 'OpenEHR.conf' ) ? 'OpenEHR.conf' : '/etc/OpenEHR.conf';
my $cfg = new Config::Simple($config_file)
    or carp "Error reading $config_file: $!";

has test_ehrid => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('test_ehrid'),
);

has test_uid => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('test_uid'),
);

has test_subject_id => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('test_subject_id'),
);

has user => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => $cfg->param('user'),
);

has password => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => $cfg->param('password'),
);

has url => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('url'),
    trigger => \&_check_url,
);

has base_path => (
    is       => 'rw',
    required => 1,
    isa      => 'Str',
    default  => $cfg->param('base_path'),
    trigger  => \&_check_url,
);

sub _check_url {
    my $self = shift;
    my $url  = shift;
    if ( $url !~ m[/$] ) {
        croak "Error: url set without trailing slash";
        return 0;
    }
    else {
        return $url;
    }
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR - Hold global configuration for interacting with an OpenEHR System

=head1 VERSION

This document describes OpenEHR version 0.0.2

=head1 SYNOPSIS

    use OpenEHR;
    
    # OpenEHR object with default attributes from configuration file
    my $openehr = OpenEHR->new();  

    $openehr->user              # access the value of the 'user' attribute
    $openehr->user('albert')    # sets the user attribute value to 'albert'
    
    # Set OpenEHR attributes at construction
    my $openehr = OpenEHR->new(
	    user => 'albert',
	    password => 'secretSomething',
	    url => 'http://www.example.com/'
    );  			   

=head1 DESCRIPTION

OpenEHR L<http://www.openehr.org> is an open platform for developing 
Electronic Health Records. This module and its child modules 
exist to provide an environment to move data from an existing data source
into an OpenEHR system. It is therefore intended for use as part of an ETL 
(Extract-Transform-Load) process. 

The OpenEHR modules do not provide any tools to perform the Extraction
process. How you access the source data will vary depending on your 
particular environment. 

Once you have identified an extract process, you can then use the OpenEHR 
modules to Transform and Load your data into an OpenEHR system. 

The major child modules are:

=over 4

=item * OpenEHR::Composition

These modules provide the Transformation part of the ETL task. Before 
any data is submitted to OpenEHR, it must be transformed into a 
representation that conforms to the OpenEHR Information Model. Such 
representations are referred to as 'Compositions' in the OpenEHR world. 
Compositions are used to represent various items of information that
may be stored in a clinical information system, such as a patient's 
demographic information, a laboratory test result, a clinical report or
a request for information. Composition formats are defined in 
the OpenEHR::Composition::* namespace. Current modules for constructing 
compositions are:

=over 8

=item OpenEHR::Composition::LabReport

=item OpenEHR::Composition::CancerReport

=item OpenEHR::Composition::InformationOrder

=back

=item * OpenEHR::REST

The OpenEHR::REST modules provide access to the REST API that comes
with an OpenEHR system. OpenEHR::REST::Composition module can be used to submit 
compositions to an OpenEHR system and therefore provide the 'Load' part 
of the ETL process. 
The REST API of an OpenEHR system provides a number of additional 
endpoints for interacting with the OpenEHR system. Current modules for 
interacting with the REST API are: 

=over 8

=item OpenEHR::REST::AQL

=item OpenEHR::REST::Composition

=item OpenEHR::REST::Demographics

=item OpenEHR::REST::EHR

=item OpenEHR::REST::Template

=item OpenEHR::REST::View

=back

=back

=head1 METHODS

=head2 user($user)

Used to get or set the User account used to authenticate to the OpenEHR server.

=head2 password($password)

Used to get or set the password used to authenticate to the OpenEHR server.

=head2 url($url)

Used to get or set the address and port of the OpenEHR server. Should be set
with a trailing forward slash. For example: 'http://localhost:8081/'

=head2 base_path($base_path)

Used to get or set the base path for REST interface. Should be specified with
a trailing forward slash. For example: 'http://localhost:8081/rest/v1/'.

=head2 test_ehrid($ehr_id)

Used to get or set a valid ehrid value for the current EHR system. 
Used in test scripts where an EHR ID is required

=head2 test_uid($composition_uid)

Used to get or set the UID of an existing composition on the current EHR system. 
Used in test scripts where a Composition UID is required

=head2 test_subject_id($external_identifier)

Used to get or set the external_ref value of an existing subject on the 
current EHR System. This is typially the identifier used in the external 
system for a subject. Used in test scripts where an Subject ID is required

=head1 PRIVATE METHODS

=head2 _check_url

Private method that terminates processing if the url attribute is set
without a trailing forward slash

=head1 DIAGNOSTICS

None. 

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR reads configuration from a config file stored in 
'OpenEHR.conf'. The configuration file should be stored in 
the current working directory or in '/etc/'. 
Attributes should be specified as space separated 
key-value pairs. Here's an example:

    ### BEGIN OpenEHR.conf ###

    # Parameters used to authenticate to server
    user            admin
    password        admin

    # Servers URL - must end in a trailing slash
    url     http://localhost:8081/

    # URL for the REST API of your server
    base_path       http://localhost:8081/rest/v1/

    # Indentification of test data used in the test suite
    test_ehrid          7287df6c-0958-4ec7-ba8a-952354528e23
    test_uid            cccc7673-8c74-4cd0-9fec-583ddc0d9134::default::1
    test_subject_id     7713848332

    ### END OpenEHR.conf ###

=head1 DEPENDENCIES

=over 4

=item *
Moose

=item *
Carp

=item *
Config::Simple

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr@rt.cpan.org>, or through the web interface at
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
