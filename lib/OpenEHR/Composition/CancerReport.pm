package OpenEHR::Composition::CancerReport;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';
use OpenEHR::Composition::Elements::ProblemDiagnosis;
use OpenEHR::Composition::Elements::CTX;

use version; our $VERSION = qv('0.0.2');

has problem_diagnoses => (
    is      => 'rw',
    isa     => 'ArrayRef[OpenEHR::Composition::Elements::ProblemDiagnosis]',
    default => sub { [] }
);

has ctx => (
    is      => 'rw',
    isa     => 'OpenEHR::Composition::Elements::CTX',
    default => \&_set_ctx,
);

has report_id => (
    is  => 'rw',
    isa => 'Str',
);

has report_date => ( is => 'rw', isa => 'DateTime' );

=head1 _set_ctx

Adds the context and ctx elements to the Information Order

=cut 

sub _set_ctx {
    my $self = shift;
    my $ctx  = OpenEHR::Composition::Elements::CTX->new();
    $self->ctx($ctx);
}

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        $problem_diagnosis->composition_format( $self->composition_format );
    }
    $self->ctx->composition_format( $self->composition_format );
    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self        = shift;
    my $ctx         = $self->ctx->compose;
    my $composition = {
        ctx                    => $ctx,
        'gel_cancer_diagnosis' => {
            context           => {
                report_id  => $self->report_id,
                start_time => $self->report_date->ymd,
            },
        },
    };
    my $problem_diagnoses;
    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        push @{$problem_diagnoses}, $problem_diagnosis->compose;
    }
    $composition->{gel_cancer_diagnosis}->{problem_diagnosis} =
      $problem_diagnoses;

    return $composition;
}

sub compose_raw {
    my $self = shift;
    my $ctx  = $self->ctx->compose;
    $ctx->{context}->{other_context} = {
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Tree'
        },
        'items' => [
            {
                'value' => {
                    'value'  => $self->report_id,
                    '@class' => 'DV_TEXT'
                },
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value'  => 'Report ID'
                },
                '@class'            => 'ELEMENT',
                'archetype_node_id' => 'at0002'
            },
        ],
        '@class'            => 'ITEM_TREE',
        'archetype_node_id' => 'at0001'
    };
    $ctx->{context}->{start_time} = {
        'value'  => $self->report_date->ymd,
        '@class' => 'DV_DATE_TIME',
    };

    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-COMPOSITION.report.v1',
        'uid'               => {
            '@class' => 'OBJECT_VERSION_ID',
            'value'  => 'de7b024f-aba4-4401-ab73-4d18bb49d60d::default::1'
        },
        'archetype_details' => {
            '@class'       => 'ARCHETYPED',
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                '@class' => 'ARCHETYPE_ID',
                'value'  => 'openEHR-EHR-COMPOSITION.report.v1'
            },
            'template_id' => {
                'value'  => 'GEL Cancer diagnosis input.v0',
                '@class' => 'TEMPLATE_ID'
            }
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'GEL Cancer diagnosis'
        },
        '@class' => 'COMPOSITION',
    };
    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        push @{ $composition->{content} }, $problem_diagnosis->compose;
    }

    $composition = { %{$composition}, %{$ctx} };

    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $composition;

    my $problem_diagnosis_index = '0';
    my $problem_diagnosis_comp;
    for my $problem_diagnosis ( @{ $self->problem_diagnoses } ) {
        my $composition_fragment = $problem_diagnosis->compose();
        for my $key ( keys %{$composition_fragment} ) {
            my $new_key = $key;
            $new_key =~ s/__TEST__/$problem_diagnosis_index/;
            $problem_diagnosis_comp->{$new_key} = $composition_fragment->{$key};
        }
        $problem_diagnosis_index++;
    }

    my $ctx = $self->ctx->compose;
    $composition = {
        %{$ctx},
        'gel_cancer_diagnosis/context/report_id' => $self->report_id,
        'gel_cancer_diagnosis/context/start_time' => $self->report_date->ymd,
        %{$problem_diagnosis_comp},
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::InformationOrder - Information Order composition element


=head1 VERSION

This document describes OpenEHR::Composition::InformationOrder version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::CancerReport;
    my $planned_order = OpenEHR::Composition::CancerReport->new(
    );
    my $info_order_hash = $planned_order->compose;


  
=head1 DESCRIPTION

Used to create a hashref element of an cancer report 
composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

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

None

=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::Composition::CancerReport requires no configuration files or 
environment variables.


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
