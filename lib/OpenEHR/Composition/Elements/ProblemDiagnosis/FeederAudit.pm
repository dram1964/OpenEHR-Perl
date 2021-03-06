package OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit;

use warnings;
use strict;
use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has event_date => (
    is  => 'rw',
    isa => 'DateTime',
);

has event_ref => (
    is  => 'rw',
    isa => 'Str',
);
has system_id => (
    is      => 'rw',
    isa     => 'Str',
    default => 'Infoflex',
);

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
        'originating_system_audit' => [
            {
                '|system_id' => $self->system_id,          #'Infoflex',
                '|time'      => $self->event_date->ymd,    #'2011-01-01T00:00Z',
                '|version_id' =>
                  $self->event_ref,    # '5C0734F2-512-A414-9CAE-BF1AF760D0AQ'
            }
        ]
    };
    return $composition;
}

sub compose_raw {
    my $self = shift;
    print Dumper;
    my $composition = {
        '@class'                   => 'FEEDER_AUDIT',
        'originating_system_audit' => {
            'time' => {
                '@class' => 'DV_DATE_TIME',
                'value'  => $self->event_date->ymd,    #'2011-01-01T00:00:00Z'
            },
            '@class'    => 'FEEDER_AUDIT_DETAILS',
            'system_id' => $self->system_id,           #'Infoflex',
            'version_id' =>
              $self->event_ref,    #'5C0734F2-512-A414-9CAE-BF1AF760D0AQ'
        }
    };
    return $composition;
}

sub compose_flat {
    my $self = shift;
    my $path =
'gel_cancer_diagnosis/problem_diagnosis:__TEST__/_feeder_audit/originating_system_audit|';

    my $composition = {
        $path . 'time'       => $self->event_date->ymd,
        $path . 'system_id'  => $self->system_id,
        $path . 'version_id' => $self->event_ref,
    };
    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit - composition element


=head1 VERSION

This document describes OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit;
    my $template = OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit->new(
    );
    my $template_hash = $template->compose();


  
=head1 DESCRIPTION

Used to create a template element for adding to a Problem Diagnosis composition object. 

=head1 INTERFACE 

=head1 ATTRIBUTES

=head2 ajcc_stage_grouping

The AJCC Stage grouping. Must be one of the following: 
    'Stage l', 'Stage IA', 'Stage IB', 'Stage ll', 'Stage IIA',
    'Stage IIB', 'Stage IIC', 'Stage III', 'Stage IIIA', 'Stage IIIB',
    'Stage IIIC', 'Stage 4' 

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

OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit requires no configuration files or 
environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

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
