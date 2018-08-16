package OpenEHR::Composition::LabTest::Requester;

use warnings;
use strict;
use Carp;
use Moose;
extends 'OpenEHR::Composition';
use version; our $VERSION = qv('0.0.2');

has ordering_provider => (is => 'rw', isa => 'OpenEHR::Composition::LabTest::OrderingProvider');
has professional      => (is => 'rw', isa => 'OpenEHR::Composition::LabTest::Professional');

sub compose {
    my $self = shift;
    $self->composition_format('RAW') if ($self->composition_format eq 'TDD');
    $self->ordering_provider->composition_format($self->composition_format);
    $self->professional->composition_format($self->composition_format);
    my $formatter = 'compose_' . lc($self->composition_format);
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
    my $composition = [{ 
        professional_identifier => [$self->professional->compose()], 
        ordering_provider => [ { ordering_provider =>  [$self->ordering_provider->compose()] } ]
    }];
    return $composition;
}

sub compose_raw {
    my $self = shift;
    my $items;
    push @{$items}, $self->professional->compose();
    push @{$items}, $self->ordering_provider->compose();  
    my $composition = { 
        'name' => {
            '@class' => 'DV_TEXT',
            'value' => 'Requester'
        },
        'archetype_details' => {
            'rm_version' => '1.0.1',
            'archetype_id' => {
                'value' => 'openEHR-EHR-CLUSTER.individual_professional.v1',
                '@class' => 'ARCHETYPE_ID'
            },
            '@class' => 'ARCHETYPED'
        },
        items => $items,
        '@class' => 'CLUSTER',
        'archetype_node_id' => 'openEHR-EHR-CLUSTER.individual_professional.v1',
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $composition = {
        %{$self->professional->compose()}, 
        %{$self->ordering_provider->compose()}};
    return $composition;
}



no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::LabTest::Requester - Requestor composition element


=head1 VERSION

This document describes OpenEHR::Composition::LabTest::Requester version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::Composition::LabTest::Professional;
    use OpenEHR::Composition::LabTest::OrderingProvider;
    use OpenEHR::Composition::LabTest::Requester;

    my $ordering_provider = OpenEHR::Composition::LabTest::OrderingProvider->new(
        given_name => 'A&E',
        family_name => 'UCLH'
    );

    my $professional = OpenEHR::Composition::LabTest::Professional->new({
        id          => 'AB01',
        assigner    => 'Carecast',
        issuer      => 'UCLH',
        type        => 'local',
    });

    my $requester = OpenEHR::Composition::LabTest::Requester->new(
        ordering_provider   => $ordering_provider,
        professional        => $professional,
    );

    $requester->composition_format('FLAT');
    my $requester_hashref = $requester->compose;


=head1 DESCRIPTION

Used to create a hashref element of a requestor for insertion to a 
composition object. The requestor element may contain a 
OpenEHR::Composition::LabTest::Professional object and/or an 
OpenEHR::Composition::LabTest::OrderingProvider object

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 ordering_provider

Identity of the care provider represented as an 
OpenEHR::Composition::LabTest::OrderingProvider object

=head2 professional

Identity of the individual at the care provider responsible 
for the request
    

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
  
OpenEHR::Composition::LabTest::Requester requires no configuration files or environment variables.


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
C<bug-openehr-composition-requester@rt.cpan.org>, or through the web interface at
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
