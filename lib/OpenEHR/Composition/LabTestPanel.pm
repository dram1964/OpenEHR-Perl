package OpenEHR::Composition::LabTestPanel;

use warnings;
use strict;
use Carp;
use Moose;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has lab_results =>
    ( is => 'rw', isa => 'ArrayRef[OpenEHR::Composition::LabResult]' );

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
        if ( $self->composition_format eq 'TDD' );
    for my $result ( @{ $self->lab_results } ) {
        $result->composition_format( $self->composition_format );
    }

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $composition = {
        laboratory_result => [],

    };
    for my $result ( @{ $self->lab_results } ) {
        push @{ $composition->{laboratory_result} }, $result->compose();
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {};

    my $index = '0';
    for my $result ( @{ $self->lab_results } ) {
        my $fc = $result->compose();
        for my $key ( keys %{$fc} ) {
            my $new_key = $key;
            $new_key =~ s/__RESULT__/$index/;
            $composition->{$new_key} = $fc->{$key};
        }
        $index++;
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Laboratory test panel'
        },
        '@class'            => 'CLUSTER',
        'archetype_details' => {
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-CLUSTER.laboratory_test_panel.v0'
            },
            '@class'     => 'ARCHETYPED',
            'rm_version' => '1.0.1'
        },
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.laboratory_test_panel.v0',
        'items'             => [],
    };
    for my $result ( @{ $self->lab_results } ) {
        push @{ $composition->{items} }, $result->compose();
    }
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::LabTestPanel - A LabTestPanel composition element


=head1 VERSION

This document describes OpenEHR::Composition::LabTestPanel version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::LabTestPanel;
    use OpenEHR::Composition::LabResult;


    my $labresult1 = OpenEHR::Composition::LabResult->new(
        result_value => 59,
        comment => 'this is the sodium result',
        ref_range => '50-60',
        testcode => 'NA',
        testname => 'Sodium',
        result_status  => 'Complete',
    );

    my $labresult2 = OpenEHR::Composition::LabResult->new(
        result_value => 88,
        comment => 'this is the potassium result',
        ref_range => '80-90',
        testcode => 'K',
        testname => 'Potassium',
        result_status  => 'Complete',
    );


    my $labpanel = OpenEHR::Composition::LabTestPanel->new(
        lab_results => [$labresult1, $labresult2],
    );

    $labpanel->composition_format('STRUCTURED');
    my $struct = $labpanel->compose;

  
=head1 DESCRIPTION

A LabTestPanel object contains an array of OpenEHR::Composition::LabResult
objects. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 lab_results     

An ArrayRef of OpenEHR::Composition::LabResult objects representing the
results recorded for each test analyte

=head1 METHODS

=head2 compose

Returns a hashref of the object in the requested format

=head2 compose_structured

Returns a hashref of the object in STRUCTURED format

=head2 compose_raw

Returns a hashref of the object in RAW format

=head2 compose_flat

Returns a hashref of the object in FLAT format


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
  
OpenEHR::Composition::LabTestPanel requires no configuration files or environment variables.


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
C<bug-openehr-composition-labtestpanel@rt.cpan.org>, or through the web interface at
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
