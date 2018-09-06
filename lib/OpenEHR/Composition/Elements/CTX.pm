package OpenEHR::Composition::Elements::CTX;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        'language'                  => $self->language_code,
        'territory'                 => $self->territory_code,
        'composer_name'             => $self->composer_name . '-' . $self->composition_format,
        'id_namespace'              => $self->id_namespace,
        'id_scheme'                 => $self->id_scheme,
        'health_care_facility|name' => $self->facility_name,
        'health_care_facility|id'   => $self->facility_id,
    };
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        category => {
            'value'         => 'event',
            '@class'        => 'DV_CODED_TEXT',
            'defining_code' => {
                'code_string'    => '433',
                '@class'         => 'CODE_PHRASE',
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value'  => 'openehr'
                }
            }
        },
        'territory' => {
            'terminology_id' => {
                'value'  => $self->territory_terminology,
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => $self->territory_code,
            '@class'      => 'CODE_PHRASE'
        },
        'language' => {
            'terminology_id' => {
                'value'  => $self->language_terminology,
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => $self->language_code,
            '@class'      => 'CODE_PHRASE'
        },
        'context' => {
            'start_time' => {
                'value'  => DateTime->now->datetime,
                '@class' => 'DV_DATE_TIME'
            },
            'health_care_facility' => {
                'name'         => $self->facility_name,
                'external_ref' => {
                    'namespace' => $self->id_namespace,
                    'type'      => 'PARTY',
                    'id'        => {
                        'value'  => $self->facility_id,
                        'scheme' => $self->id_scheme,
                        '@class' => 'GENERIC_ID'
                    },
                    '@class' => 'PARTY_REF'
                },
                '@class' => 'PARTY_IDENTIFIED'
            },
            'setting' => {
                'value'         => 'other care',
                'defining_code' => {
                    'terminology_id' => {
                        'value'  => 'openehr',
                        '@class' => 'TERMINOLOGY_ID'
                    },
                    'code_string' => '238',
                    '@class'      => 'CODE_PHRASE'
                },
                '@class' => 'DV_CODED_TEXT',
            },
        '@class' => 'EVENT_CONTEXT',
        },
        'composer' => {
            'name'   => $self->composer_name . '-' . $self->composition_format,
            '@class' => 'PARTY_IDENTIFIED'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {
        'ctx/language'                  => $self->language_code,
        'ctx/territory'                 => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name . '-' . $self->composition_format,
        'ctx/id_namespace'              => $self->id_namespace,
        'ctx/id_scheme'                 => $self->id_scheme, 
        'ctx/health_care_facility|name' => $self->facility_name,
        'ctx/health_care_facility|id'   => $self->facility_id,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::CTX - CTX composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::CTX version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::CTX;
    my $ctx = OpenEHR::Composition::Elements::CTX->new(
    );
    my $ctx_hash = $ctx->compose;


  
=head1 DESCRIPTION

Used to create a hashref element of an CTX composition element. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head1 METHODS

=head1 DIAGNOSTICS

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::Elements::CTX gathers all attribute properties
from OpenEHR::Composition

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

When using the RAW format compositions, uids are not automatically assigned to 
instructions or actions

Please report any bugs or feature requests to
C<bug-openehr-composition-filler@rt.cpan.org>, or through the web interface at
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
