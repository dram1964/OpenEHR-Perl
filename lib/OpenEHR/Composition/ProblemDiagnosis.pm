package OpenEHR::Composition::ProblemDiagnosis;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

has ajcc_stage => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'ajcc_stage_version'  => ['AJCC Stage version 55'],
            'ajcc_stage_grouping' => ['Stage IB']
        }
    ]},
);
has colorectal_diagnosis => (
    is  => 'rw',
    isa => 'ArrayRef',
    default => sub {
        [ { 'synchronous_tumour_indicator' => [ { '|code' => 'at0003' } ] } ]
    },
);
has diagnosis => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {['Diagnosis 59']},
);
has modified_dukes_stage => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[ { 'modified_dukes_stage' => [ { '|code' => 'at0006' } ] } ]},
);
has tumour_id => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'tumour_identifier' => [
                {   '|id'       => '1b85693c-a17a-426c-ad74-0fb086375da3',
                    '|assigner' => 'Assigner',
                    '|issuer'   => 'Issuer',
                    '|type'     => 'Prescription'
                }
            ]
        }
    ]},
);
has clinical_evidence => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[ { 'base_of_diagnosis' => ['6 Histology of metastasis'] } ]},
);
has upper_gi_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'transarterial_chemoembolisation' => [ { '|code' => 'at0015' } ],
            'portal_invasion'                 => [ { '|code' => 'at0005' } ],
            'child-pugh_score' =>
                [ { 'grade' => [ { '|code' => 'at0027' } ] } ],
            'pancreatic_clinical_stage' => [ { '|code' => 'at0012' } ],
            'bclc_stage' =>
                [ { 'bclc_stage' => [ { '|code' => 'at0007' } ] } ],
            'number_of_lesions' => [96]
        }
    ]},
);
has integrated_tnm => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'integrated_stage_grouping' => ['Integrated Stage grouping 31'],
            'integrated_tnm_edition'    => ['Integrated TNM Edition 44'],
            'integrated_n'              => ['Integrated N 15'],
            'grading_at_diagnosis' => ['G4 Undifferentiated / anaplastic'],
            'integrated_m'         => ['Integrated M 25'],
            'integrated_t'         => ['Integrated T 99']
        }
    ]},
);
has inrg_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[ { 'inrg_stage' => [ { '|code' => 'at0004' } ] } ]},
);
has cancer_diagnosis => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'recurrence_indicator' => [ { '|code' => 'at0016' } ],
            'tumour_laterality'    => [ { '|code' => 'at0033' } ],
            'metastatic_site'      => [ { '|code' => 'at0023' } ],
            'topography' => ['Topography 75'],
            'morphology' => ['Morphology 46']
        }
    ]},
);
has final_figo_stage => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'figo_grade'   => [ { '|code' => 'at0008' } ],
            'figo_version' => ['FIGO version 99']
        }
    ]},
);
has event_date => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {['2018-07-24T14:05:01.806+01:00']},
);
has testicular_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {[
        {   'lung_metastases_sub-stage_grouping' =>
                [ { '|code' => 'at0021' } ],
            'extranodal_metastases'     => [ { '|code' => 'at0019' } ],
            'stage_grouping_testicular' => [ { '|code' => 'at0010' } ]
        }
    ]},
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
        ajcc_stage           => $self->ajcc_stage,
        colorectal_diagnosis => $self->colorectal_diagnosis,
        diagnosis            => $self->diagnosis,
        modified_dukes_stage => $self->modified_dukes_stage,
        tumour_id            => $self->tumour_id,
        clinical_evidence    => $self->clinical_evidence,
        upper_gi_staging     => $self->upper_gi_staging,
        integrated_tnm       => $self->integrated_tnm,
        inrg_staging         => $self->inrg_staging,
        cancer_diagnosis     => $self->cancer_diagnosis,
        final_figo_stage     => $self->final_figo_stage,
        event_date           => $self->event_date,
        testicular_staging   => $self->testicular_staging,
    };

    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {};

    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {};

    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::ProblemDiagnosis - Problem Diagnosis composition element


=head1 VERSION

This document describes OpenEHR::Composition::ProblemDiagnosis version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::ProblemDiagnosis;
    my $diagnosis = OpenEHR::Composition::ProblemDiagnosis->new(
    );
    my $diagnosis_hash = $diagnosis->compose();


  
=head1 DESCRIPTION

Used to create a hashref element of an problem diagnosis 
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

OpenEHR::Composition::ProblemDiagnosis requires no configuration files or 
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
