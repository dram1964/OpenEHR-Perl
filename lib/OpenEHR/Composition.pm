package OpenEHR::Composition;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use JSON;
extends 'OpenEHR';
use Config::Simple;

use version; our $VERSION = qv('0.0.2');

my $config_file =
    ( -f 'OpenEHR_Composition.conf' ) ? 'OpenEHR_Composition.conf' : '/etc/OpenEHR_Composition.conf';
my $cfg = new Config::Simple($config_file)
    or carp "Error reading $config_file: $!";

enum 'CompositionFormat' => [qw( FLAT STRUCTURED RAW TDD )];

has composition_uid => ( is => 'rw' );

has composition_format => (
    is       => 'rw',
    isa      => 'CompositionFormat',
    default  => $cfg->param('composition_format'),
);

has composer_name => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => $cfg->param('composer_name'),
);

has language_code => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('language_code'),
);

has language_terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('language_terminology'),
);

has territory_code => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('territory_code'),
);

has territory_terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('territory_terminology'),
);

has encoding_code => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('encoding_code'),
);

has encoding_terminology => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('encoding_terminology'),
);

has id_namespace => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('id_namespace'),
);

has id_scheme => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('id_scheme'),
);

has facility_name => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('facility_name'),
);

has facility_id => (
    is      => 'rw',
    isa     => 'Str',
    default => $cfg->param('facility_id'),
);

sub print_json {
    my ($self) = @_;
    my $composition = $self->compose;
    my $json = to_json($composition, { pretty => 1} );
    return $json;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition - Holds Global Configuration for 
OpenEHR::Composition::* objects

=head1 VERSION

This document describes OpenEHR::Composition version 0.0.2

=head1 SYNOPSIS

    use OpenEHR::Composition;
    my $config = OpenEHR::Composition->new();
    say $config->composition_format;
    say $config->composer_name;

=head1 DESCRIPTION

This module provides global configuration for OpenEHR::Composition::*
objects. Default configuration is read from either OpenEHR-Composition.conf
file in the current working directory or '/etc/OpenEHR_Composition.conf'

=head1 INTERFACE 

=head1 METHODS 

=head2 print_json

Returns the composition as JSON in the format specified by 
the objects composition_format property
    my $json = $lab_result_report->print_json;

=head1 ATTRIBUTES

=head2 composition_format($format)

Used to get or set the composition format. Valid values are one of 
(RAW | STRUCTURED | FLAT | TDD), although TDD is not currently implemented. 

=head2 composer_name($composer_name)

Used to get or set the Composer Name value to be used in the composition. 

=head2 language_code($language_code)

Used to get or set the language_code value used in REST queries and 
composition objects.

=head2 language_terminology($language_terminology)

Used to get or set the terminology used for the language_code attribute. 

=head2 territory_code($territory_code)

Used to get or set the territory_code value used in REST queries. 

=head2 territory_terminology($territory_terminology)

Used to get or set the terminology used for the territory_code attribute. 

=head2 encoding_code($encoding_code)

Used to get or set the encoding_code value used in REST queries. Defaults to 'UTF-8'

=head2 encoding_terminology($encoding_terminology)

Used to get or set the terminology used for the encoding_code attribute. 

=head2 id_namespace($id_namespace)

Used to get or set the ID Namespace used in compositions

=head2 id_scheme($id_scheme)

Used to get or set the ID scheme used in compositions 

=head2 facility_name($facility_name)

Used to get or set the Facility Name used in compositions

=head2 facility_id($facility_id)

Used to get or set the Facility ID used in compositions

=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

Default values for attributes are configured in OpenEHR_Composition.conf 
file which is read from either the current working directory or 
/etc/. Configuration file values can be overridden by environment variables
of the same name. 


=head1 DEPENDENCIES

=over 4

=item * OpenEHR

=item * Moose

=item * Carp

=item * JSON

=item * Moose::Util::TypeConstraints

=item * Config::Simple

=back

=head1 INCOMPATIBILITIES

None reported

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-composition@rt.cpan.org>, or through the web interface at
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
