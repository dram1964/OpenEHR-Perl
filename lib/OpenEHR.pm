package OpenEHR;

use Carp;
use Moose;
use Config::Simple;

use version; our $VERSION = qv('0.0.2');

my $config_file = 'OpenEHR.conf';
my $cfg = new Config::Simple($config_file) 
    or carp "Error reading $config_file: $!";

has test_ehrid  => (
    is          => 'rw',
    isa         => 'Str',
    default     => $cfg->param('test_ehrid'),
);

has test_uid  => (
    is          => 'rw',
    isa         => 'Str',
    default     => $cfg->param('test_uid'),
);

has test_subjectid  => (
    is          => 'rw',
    isa         => 'Str',
    default     => $cfg->param('test_subjectid'),
);

has user        => (
    is          =>  'rw', 
    isa         =>  'Str', 
    required    =>  1, 
    default     =>  $cfg->param('user') || 'admin',
);

has password    => (
    is          =>  'rw', 
    isa         =>  'Str', 
    required    =>  1, 
    default     =>  $cfg->param('password') || 'admin',
);

has url         => (
    is          =>  'rw', 
    isa         =>  'Str', 
    default     =>  $cfg->param('url') || 'http://localhost:8081/', 
    trigger     =>  \&_check_url,
);

has base_path   => (
    is          =>  'rw', required => 1, isa => 'Str', 
    default     =>  $cfg->param('base_path') 
                        || 'http://localhost:8081/rest/v1/',
    trigger     =>  \&_check_url,
);

has language_code   => (
    is              =>  'rw', 
    isa             =>  'Str', 
    default         =>  $cfg->param('language_code') || 'en',
);

has language_terminology   => (
    is          =>  'rw', 
    isa         =>  'Str', 
    default     =>  $cfg->param('language_terminology') || 'ISO_639-1',
);

has territory_code   => (
    is          =>  'rw', 
    isa         =>  'Str', 
    default     =>  $cfg->param('territory_code') || 'GB',
);

has territory_terminology   => (
    is          =>  'rw', 
    isa         =>  'Str', 
    default     =>  $cfg->param('territory_terminology') || 'ISO_3166-1',
);

has encoding_code 	=> (
    is          =>  'rw', 
    isa         =>  'Str', 
    default =>      $cfg->param('encoding_code') || 'UTF-8',
);

has encoding_terminology    => (
    is          =>  'rw', 
    isa         =>  'Str', 
    default     =>  $cfg->param('encoding_terminology') 
                        || 'IANA_character-sets',
);

sub _check_url {
    my $self = shift;
    my $url = shift;
    if ($url !~ m[/$]) {
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

OpenEHR - Parent module for functions to interface with OpenEHR 

=head1 VERSION

This document describes OpenEHR version 0.0.2


=head1 SYNOPSIS

    use OpenEHR;
    
    # OpenEHR object with default attributes from configuration file
    # or module defaults
    my $openehr = OpenEHR->new();  

    $openehr->user		        # module default value 'admin'
    $openehr->user('albert')    # sets user to 'albert'
    $openehr->password		    # module default value 'admin'
    $openehr->url		        # module default value 'http://localhost:8081/'
    
    # Set OpenEHR attributes at construction
    my $openehr = OpenEHR->new(
	    user => 'albert',
	    password => 'secretSomething',
	    url => 'http://www.example.com/'
    );  			   

  
=head1 DESCRIPTION

OpenEHR L<http://www.openehr.org> is an open platform for developing 
Electronic Health Records. This module provides some global 
attributes inherited by other child modules.

=head1 ATTRIBUTES

=head2 user

User account used to authenticate to the OpenEHR server. Default value
can be set in configuration file, otherwise defaults to 'admin'

=head2 password

Password used to authenticate to the OpenEHR server. Default value
can be set in configuration file, otherwise defaults to 'admin'

=head2 url

Used to specify address and port of the OpenEHR server. Default value
can be set in configuration file, otherwise defaults to 
http://localhost:8081/'

=head2 base_path

Used to specify the base path for REST calls. Default value
can be set in configuration file, otherwise defaults to 
'http://localhost:8081/rest/v1/'. Should be specified with
a trailing forward slash

=head2 language_code

Used to set the language_code value used in REST queries. Default value
can be set in configuration file, otherwise defaults to 'en'

=head2 language_terminology

Used to set the terminology used for the language code attribute. Default 
value can be set in configuration file, otherwise defaults to 'ISO_639-1'

=head2 territory_code

Used to set the territory_code value used in REST queries. Default value
can be set in configuration file, otherwise defaults to 'GB'

=head2 territory_terminology

Used to set the terminology used for the territory_code attribute. Default 
value can be set in configuration file, otherwise defaults to 'ISO_3166-1'

=head2 encoding_code

Used to set the encoding_code value used in REST queries. Default value
can be set in configuration file, otherwise defaults to 'UTF-8'

=head2 encoding_terminology

Used to set the terminology used for the encoding_code attribute. Default 
value can be set in configuration file, otherwise defaults to 
'IANA_character-sets'

=head2 test_ehrid

Used in test scripts where an EHR ID is required

=head2 test_uid

Used in test scripts where an Composition UID is required

=head2 test_subjectid

Used in test scripts where an Subject ID is required

=head1 PRIVATE METHODS

=head2 _check_url

Private method that terminates processing if the url attribute is set
without a trailing forward slash

=head1 DIAGNOSTICS

None. 

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR reads configuration from a config file stored in 
'OpenEHR.conf'. Attributes should be specified as space separated 
key-value pairs. An example configuration file can be found in the 
etc directory of this distribution

=head1 DEPENDENCIES

Moose
Carp
Config::Simple

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
