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
);
has colorectal_diagnosis => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has diagnosis => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has modified_dukes_stage => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has tumour_id => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has clinical_evidence => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has upper_gi_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has integrated_tnm => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has inrg_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has cancer_diagnosis => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has final_figo_stage => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has event_date => (
    is      => 'rw',
    isa     => 'ArrayRef',
);
has testicular_staging => (
    is      => 'rw',
    isa     => 'ArrayRef',
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
    my $composition;
    if ($self->ajcc_stage) {
        $composition->{ajcc_stage} = $self->ajcc_stage;
    }
    if ($self->colorectal_diagnosis) {
        $composition->{colorectal_diagnosis} = $self->colorectal_diagnosis;
    }
    if ($self->diagnosis) {
        $composition->{diagnosis} = $self->diagnosis;
    }
    if ($self->modified_dukes_stage) {
        $composition->{modified_dukes_stage} = $self->modified_dukes_stage;
    }
    if ($self->tumour_id) {
        $composition->{tumour_id} = $self->tumour_id;
    }
    if ($self->clinical_evidence) {
        $composition->{clinical_evidence} = $self->clinical_evidence;
    }
    if ($self->upper_gi_staging) {
        $composition->{upper_gi_staging} = $self->upper_gi_staging;
    }
    if ($self->integrated_tnm) {
        $composition->{integrated_tnm} = $self->integrated_tnm;
    }
    if ($self->inrg_staging) {
        $composition->{inrg_staging} = $self->inrg_staging;
    }
    if ($self->cancer_diagnosis) {
        $composition->{cancer_diagnosis} = $self->cancer_diagnosis;
    }
    if ($self->final_figo_stage) {
        $composition->{final_figo_stage} = $self->final_figo_stage;
    }
    if ($self->event_date) {
        $composition->{event_date} = $self->event_date;
    }
    if ($self->testicular_staging) {
        $composition->{testicular_staging} = $self->testicular_staging;
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {};

    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition;
    if ($self->ajcc_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/ajcc_stage/ajcc_stage_grouping'} = 
            'Stage IIA';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/ajcc_stage/ajcc_stage_version'} = 
            'AJCC Stage version 32';
    }
    if ($self->colorectal_diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/colorectal_diagnosis/synchronous_tumour_indicator:0|code'} = 
            'at0002';
    }
    if ($self->diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/diagnosis'} = 'Diagnosis 83';
    }
    if ($self->modified_dukes_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/modified_dukes_stage:0/modified_dukes_stage|code'} 
            = 'at0003';
    }
    if ($self->tumour_id) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0'}
            = '16567b05-9857-4b4d-aade-171f806ed875';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|issuer'}
            = 'Issuer';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|type'}
            = 'Prescription';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|assigner'}
            = 'Assigner';
    }
    if ($self->clinical_evidence) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/clinical_evidence:0/base_of_diagnosis'}
            = '7 Histology of primary tumour';
    }
    if ($self->upper_gi_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/number_of_lesions'}
            = 888;
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/pancreatic_clinical_stage|code'}
            = 'at0012';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/portal_invasion|code'}
            = 'at0005';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/child-pugh_score:0/grade|code'}
            = 'at0027';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/bclc_stage:0/bclc_stage|code'}
            = 'at0007';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/transarterial_chemoembolisation|code'}
            = 'at0017';
    }
    if ($self->integrated_tnm) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_stage_grouping'}
            = 'Integrated Stage grouping 70';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_m'}
            = 'Integrated M 74';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_n'}
            = 'Integrated N 77';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_t'}
            = 'Integrated T 5';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_tnm_edition'}
            = 'Integrated TNM Edition 55';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/grading_at_diagnosis'}
            = 'G3 Poorly differentiated';
    }
    if ($self->inrg_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/inrg_staging:0/inrg_stage|code'}
            = 'at0004';
    }
    if ($self->cancer_diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/tumour_laterality|code'}
            = 'at0030';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/topography'}
            = 'Topography 90';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/morphology:0'}
            = 'Morphology 96';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/metastatic_site|code'}
            = 'at0018';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/recurrence_indicator|code'}
            = 'at0015';
    }
    if ($self->final_figo_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/final_figo_stage/figo_version'}
            = 'FIGO version 63';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/final_figo_stage/figo_grade|code'}
            = 'at0003';
    }
    if ($self->event_date) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/event_date'} = '2018-07-24T14:06:41.753+01:00';
    }
    if ($self->testicular_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/extranodal_metastases|code'}
            = 'at0018';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/stage_grouping_testicular|code'}
            = 'at0010';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/lung_metastases_sub-stage_grouping|code'}
            = 'at0021';
    }
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
