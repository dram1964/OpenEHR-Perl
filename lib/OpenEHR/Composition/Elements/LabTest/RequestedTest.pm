package OpenEHR::Composition::Elements::LabTest::RequestedTest;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use version; our $VERSION = qv('0.0.2');
use Data::Dumper;

has requested_test => ( is => 'rw', isa => 'Str' );
has name           => ( is => 'rw', isa => 'Str' );
has code           => ( is => 'rw', isa => 'Str', trigger => \&_check_blanks );
has terminology    => ( is => 'rw', isa => 'Str', default => 'local' );
has order_mapping  => ( is => 'rw', isa => 'ArrayRef[HashRef]' );

sub _check_blanks {
    my $self = shift;
    if ( $self->requested_test =~ /^\s*$/ ) {
        $self->requested_test( $self->code );
    }
    if ( $self->name =~ /^\s*$/ ) {
        $self->name( $self->code );
    }
}

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
        '_mapping' => [
        ],
        '|terminology' => $self->terminology,
        '|value'       => $self->name,
        '|code'        => $self->code,
    };
    if ( $self->order_mapping ) {
        for my $mapping ( @{ $self->order_mapping } ) {
            push @{ $composition->{'_mapping'} }, 
            {
                '|match' => '=',
                'target' => [
                    {
                        '|terminology' => $mapping->{terminology},
                        '|code'        => $mapping->{code},
                    },
                ],
            };
        }
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'at0005',
        'name'              => {
            '@class' => 'DV_TEXT',
            'value'  => 'Requested Test'
        },
        '@class' => 'ELEMENT',
        'value'  => {
            '@class'        => 'DV_CODED_TEXT',
            'value'         => $self->name,
            'defining_code' => {
                '@class'         => 'CODE_PHRASE',
                'code_string'    => $self->code,
                'terminology_id' => {
                    'value'  => $self->terminology,
                    '@class' => 'TERMINOLOGY_ID'
                }
            }
        }
    };
    if ( $self->order_mapping ) {
        for my $mapping ( @{ $self->order_mapping } ) {
            push @{ $composition->{value}->{'mappings'}  },
                {
                    'target' => {
                        '@class'         => 'CODE_PHRASE',
                        'code_string'    => $mapping->{code},
                        'terminology_id' => {
                            '@class' => 'TERMINOLOGY_ID',
                            'value'  => $mapping->{terminology},
                        }
                    },
                    '@class' => 'TERM_MAPPING',
                    'match'  => '=',
                };
        }
    }
    print Dumper $composition;
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $path        = 'laboratory_result_report/laboratory_test:__TEST__/';
    my $composition = {
        $path . 'requested_test'             => $self->requested_test,
        $path . 'requested_test|code'        => $self->code,
        $path . 'requested_test|terminology' => $self->terminology,
        $path . 'requested_test|value'       => $self->name,
    };
    if ( $self->order_mapping ) {
        for my $mapping ( @{ $self->order_mapping } ) {
            $composition->{ $path . 'requested_test/_mapping:0|match' } = '=';
            $composition->{ $path . 'requested_test/_mapping:0/target|code' } =
              $mapping->{code};
            $composition->{ $path
                  . 'requested_test/_mapping:0/target|terminology' } =
              $mapping->{terminology};
        }
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::LabTest::RequestedTest - [One line description of module's purpose here]


=head1 VERSION

This document describes OpenEHR::Composition::Elements::LabTest::RequestedTest version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::LabTest::RequestedTest;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


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
  
OpenEHR::Composition::Elements::LabTest::RequestedTest requires no configuration files or environment variables.


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
C<bug-openehr-composition-requestedtest@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Ramlakhan  C<< <dram1964@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2018, David Ramlakhan C<< <dram1964@gmail.com> >>. All rights reserved.

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
