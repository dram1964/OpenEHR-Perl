package OpenEHR::Composition;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR';
use Moose::Util::TypeConstraints;
use Config::Simple;

use version; our $VERSION = qv('0.0.2');

my $config_file = 'OpenEHR.conf';
my $cfg         = new Config::Simple($config_file)
    or carp "Error reading $config_file: $!";

enum 'CompositionFormat' => [qw( FLAT STRUCTURED RAW TDD )];

has composition_format => (
    is       => 'rw',
    isa      => 'CompositionFormat',
    default  => $cfg->{composition_format} || 'STRUCTURED',
    required => 1,
);

has composer_name => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    default  => 'Aupen Ayre',
);

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition - Holds Global Configuration for 
OpenEHR::Composition::* objects


=head1 VERSION

This document describes OpenEHR::Composition version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition;
    my $config = OpenEHR::Composition->new();
    say $config->composition_format;
    say $config->composer_name;

=head1 DESCRIPTION

This module provides global configuration for OpenEHR::Composition::*
objects. Default configuration is read from '/etc/OpenEHR.conf'


=head1 INTERFACE 

=head1 METHODS 

=head1 composition_format($format)

Used to get or set the composition format. Valid values are one of 
(RAW | STRUCTURED | FLAT | TDD), although TDD is not currently implemented. 


=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition requires no configuration files or environment 
variables.


=head1 DEPENDENCIES

OpenEHR
Moose
Carp
Moose::Util::TypeConstraints
Config::Simple

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
