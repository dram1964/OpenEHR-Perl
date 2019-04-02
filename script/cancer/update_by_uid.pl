use strict;
use warnings;
use DateTime::Format::DateParse;
use JSON;
use DBI;

use OpenEHR::Composition::CancerReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $uid = $ARGV[0]; #'8b6591eb-4b1b-48f9-a9a4-09178d622d6d::default::2';
die "Aborting: No UID specified on command line\n" unless $uid;

my $subject_id = &get_subject_id($uid); #'9467484064';
die "Aborting: Unable to find nhs_number from UID\n" unless $subject_id;

my ($data_start_date, $data_end_date) = &get_start_end_dates($subject_id);
#my $data_start_date = '2001-03-07';
#my $data_end_date = '2019-03-19';
die "Aborting: Unable to find order start_date for nhs_number\n" unless $data_start_date;
die "Aborting: Unable to find order end_date for nhs_number\n" unless $data_end_date;

print join ("#", $uid, $subject_id, $data_start_date, $data_end_date), "\n";


&report_cancer_update(
    $subject_id,
    $data_start_date, 
    $data_end_date
);

sub get_start_end_dates {
    my $subject_id = shift;
    my $order_rs = $schema->resultset('InformationOrder')->search(
        {
            subject_id => $subject_id,
            service_type => 'cancer',
        },
        {
            order_by => { -desc => 'order_date'},
            columns => [ qw(data_start_date data_end_date) ],
            rows => 1,
        }
    );
    if ( $order_rs == 1 ) {
        my $order = $order_rs->first;
        return $order->data_start_date, $order->data_end_date;
    }
    else {
        return 0;
    }
}

sub get_subject_id {
    my $uid = shift;
    my $composition_rs = $schema->resultset('InfoflexCancer')->search(
        {
            composition_id => $uid,
        },
        {
            columns => 'nhs_number',
            distinct => 1,
        }
    );
    if ( $composition_rs->count == 1 ) {
        return $composition_rs->first->nhs_number;
    }
    else {
        return 0;
    }
}



sub report_cancer_update {
    my ( $nhs_number, $start_date, $end_date ) = @_;
    my $cancer_report = OpenEHR::Composition::CancerReport->new( 
        report_date => DateTime->now,
    );
    my $events;
    my $reports_rs = $schema->resultset('InfoflexCancer')->search(
        {
            nhs_number           => $nhs_number,
            event_date_diagnosis => { '>=' => $start_date, '<=' => $end_date },
        },
    );
    while ( my $report = $reports_rs->next ) {
        print join( ":",
            $report->patient_hospital_number,
            $report->nhs_number,
            $report->event_date_diagnosis,
            $report->event_icd10_diagnosis_code,
          ),
          "\n";
        next unless $report->event_icd10_diagnosis_code;
              
        my $pd = OpenEHR::Composition::Elements::ProblemDiagnosis->new();
        my $problem_diagnosis = $pd->element('ProblemDiagnosis')->new();

        my ( $tumour_id );

        if ( $report->synchronous_tumour_indicator ) {
            my $colorectal_diagnosis = &get_colorectal_diagnosis( $report, $pd );
            $problem_diagnosis->colorectal_diagnosis( [ $colorectal_diagnosis ] );
        }

        if ( $report->basis_of_diagnosis ) {
            my $clinical_evidence = &get_clinical_evidence( $report, $pd );
            $problem_diagnosis->clinical_evidence( [$clinical_evidence] );
        }
        if ( $report->event_date_diagnosis ) {
            my $feeder_audit = &get_feeder_audit( $report, $pd );
            $problem_diagnosis->feeder_audit( $feeder_audit );
            push @{ $events }, $feeder_audit->event_ref;
        }


        my $diagnosis = &get_diagnosis( $report, $pd );
        $problem_diagnosis->diagnosis( [$diagnosis] );

        my $cancer_diagnosis = &get_cancer_diagnosis( $report, $pd );
        $problem_diagnosis->cancer_diagnosis( [$cancer_diagnosis] );

        if ( my $testicular_staging = &get_testicular_staging( $report, $pd ) )
        {
            $problem_diagnosis->testicular_staging( [$testicular_staging] );
        }

        if ( $report->neuroblastoma_risk_group_cyta ) {
            my $inrg_staging = &get_inrg_staging( $report, $pd );
            $problem_diagnosis->inrg_staging( [$inrg_staging] );
        }

        if ( my $integrated_tnm = &get_integrated_tnm( $report, $pd ) ) {
            $problem_diagnosis->integrated_tnm( [$integrated_tnm] );
        }

        if ( $report->ajcc_tnm_stage_group_skin ) {
            my $ajcc_stage = &get_ajcc_stage( $report, $pd );
            $problem_diagnosis->ajcc_stage( [$ajcc_stage] );
        }
        if ( $report->figo_stage_group_skin ) {
            my $figo_stage = &get_figo_stage( $report, $pd );
            $problem_diagnosis->final_figo_stage( [$figo_stage] );
        }
        if ( $report->modified_dukes_stage_colo ) {
            my $modified_dukes = &get_modified_dukes( $report, $pd );
            $problem_diagnosis->modified_dukes( [$modified_dukes] );
        }

=head1 Placeholder

Placeholder for pancreated clinical stage
This data is not currently in the Infoflex Extract
        if ( $report->pancreatic_clinical_stage ) {
            my $panc_stage = &get_panc_stage( $report, $pd );
            $upper_gi->pancreatic_clinical_stage( [$panc_stage] );
        }
=cut

        my $upper_gi = $pd->element('UpperGI')->new();
        if ( defined( $report->bclc_stage_upper_gi ) ) {
            my $bclc_stage = &get_bclc_stage( $report, $pd );
            $upper_gi->bclc_stage( [$bclc_stage] );
        }
        if ( $report->portal_invasion_upper_gi ) {
            my $portal_invasion = &get_portal_invasion( $report, $pd );
            $upper_gi->portal_invasion( [$portal_invasion] );
        }
        if ( $report->number_of_lesions_cns ) {
            my $number_lesions = &get_number_lesions( $report, $pd );
            $upper_gi->lesions($number_lesions);
        }
        if ( $report->child_pugh_score_upper_gi ) {
            my $child_pugh_score = &get_child_pugh_score( $report, $pd );
            $upper_gi->child_pugh_score( [$child_pugh_score] );
        }
        if ( $report->transarterial_chemoembolisation_upper_gi ) {
            my $tace = &get_tace( $report, $pd );
            $upper_gi->tace( [$tace] );
        }
        if (   $upper_gi->bclc_stage
            || $upper_gi->portal_invasion
            || $upper_gi->pancreatic_clinical_stage
            || $upper_gi->lesions
            || $upper_gi->tace
            || $upper_gi->child_pugh_score )
        {
            $problem_diagnosis->upper_gi_staging( [$upper_gi] );
        }

        push @{ $cancer_report->problem_diagnoses }, $problem_diagnosis;
    }

    $cancer_report->report_id( &get_report_id() );
    $cancer_report->composition_format('STRUCTURED');
    my $composition = $cancer_report->compose;

=for removal
    print Dumper $composition;
=cut
    my $query = OpenEHR::REST::Composition->new();
    $query->composition($cancer_report);
    $query->template_id('GEL Cancer diagnosis input.v0');
    $query->update_by_uid($uid);
    if ( $query->err_msg ) {
        print 'Error occurred in submission: ' . $query->err_msg;
        return 0;
    }
    else {
        print 'Action is: ',                   $query->action,         "\n";
        print 'Composition UID: ',             $query->compositionUid, "\n";
        print 'Composition can be found at: ', $query->href,           "\n";
        &update_report_date( $events, $query->compositionUid );
    }
}

sub update_report_date() {
    my ( $events, $composition_uid ) = @_;
    my $search = $schema->resultset('InfoflexCancer')->search(
        {
            event_reference_diagnosis => { '=' => $events},
        }
    );
    my $now = DateTime->now->datetime;
    $now =~ s/T/ /;
    $search->update(
        {
            composition_id => $composition_uid,
            reported_date  => $now,
            reported_by    => $0,
        }
    );

}

sub get_report_id {
    my $report_id = int( rand(1000000000000000) );
    $report_id .= '0000000000000000';
    if ( $report_id =~ /^([\d]{16,16}).*/ ) {
        $report_id = $1;
    }
    return $report_id;
}

sub get_clinical_evidence {
    my $report            = shift;
    my $pd                = shift;
    my $clinical_evidence = $pd->element('ClinicalEvidence')
      ->new( local_code => $report->basis_of_diagnosis );
    return $clinical_evidence;
}

sub get_colorectal_diagnosis {
    my $report            = shift;
    my $pd                = shift;
    my $colorectal_diagnosis = $pd->element('ColorectalDiagnosis')
      ->new( local_code => $report->synchronous_tumour_indicator );
    return $colorectal_diagnosis;
}

sub get_number_lesions {
    my $report         = shift;
    my $pd             = shift;
    my $number_lesions = $report->number_of_lesions_cns;
    return $number_lesions;
}

sub get_inrg_staging {
    my $report = shift;
    my $pd     = shift;
    my $inrg_stage = $pd->element('INRG_Staging')->new(
        local_code => $report->neuroblastoma_risk_group_cyta);
    return $inrg_stage;
}

sub get_integrated_tnm {
    my $report         = shift;
    my $pd             = shift;
    my $integrated_tnm = $pd->element('Integrated_TNM')->new();
    my $items_found    = 0;
    if ( $report->t_category ) {
        $integrated_tnm->integrated_t( $report->t_category );
        $items_found++;
    }
    if ( $report->n_category ) {
        $integrated_tnm->integrated_n( $report->n_category );
        $items_found++;
    }
    if ( $report->m_category ) {
        $integrated_tnm->integrated_m( $report->m_category );
        $items_found++;
    }
    if ( $report->tnm_stage_grouping ) {
        $integrated_tnm->stage_grouping( $report->tnm_stage_grouping );
        $items_found++;
    }
    if ( $report->tnm_edition_number ) {
        $integrated_tnm->tnm_edition( $report->tnm_edition_number );
        $items_found++;
    }
    if ( $report->grade_of_differentiation ) {
        $integrated_tnm->grading_at_diagnosis(
            $report->grade_of_differentiation );
        $items_found++;
    }
    if ( $items_found > 0 ) {
        return $integrated_tnm;
    }
    else {
        return 0;
    }
}

sub get_tace {
    my $report = shift;
    my $pd     = shift;
    my $tace   = $pd->element('TACE')
      ->new( local_code => $report->transarterial_chemoembolisation_upper_gi );
    return $tace;
}

sub get_panc_stage {
    my $report = shift;
    my $pd     = shift;
    my $panc   = $pd->element('PancreaticClinicalStage')
      ->new( local_code => $report->pancreatic_clinical_stage );
    return $panc;
}

sub get_child_pugh_score {
    my $report           = shift;
    my $pd               = shift;
    my $child_pugh_score = $pd->element('ChildPughScore')
      ->new( local_code => $report->child_pugh_score_upper_gi );
    return $child_pugh_score;
}

sub get_portal_invasion {
    my $report          = shift;
    my $pd              = shift;
    my $portal_invasion = $pd->element('PortalInvasion')
      ->new( value => $report->portal_invasion_upper_gi );
    return $portal_invasion;
}

sub get_bclc_stage {
    my $report = shift;
    my $pd     = shift;
    my $bclc_stage =
      $pd->element('BCLC_Stage')->new( value => $report->bclc_stage_upper_gi );
    return $bclc_stage;
}

sub get_modified_dukes {
    my $report         = shift;
    my $pd             = shift;
    my $modified_dukes = $pd->element('ModifiedDukes')
      ->new( local_code => $report->modified_dukes_stage_colo );
    return $modified_dukes;
}


sub get_ajcc_stage {
    my $report     = shift;
    my $pd         = shift;
    my $ajcc_stage = $pd->element('AJCC_Stage')
      ->new( ajcc_code => $report->ajcc_tnm_stage_group_skin );
    return $ajcc_stage;
}


sub get_figo_stage {
    my $report     = shift;
    my $pd         = shift;
    my $figo_stage = $pd->element('FinalFigoStage')
      ->new( value => $report->figo_stage_group_skin, );
    return $figo_stage;
}

sub get_feeder_audit {
    my $report         = shift;
    my $pd             = shift;
    my $feeder_audit = $pd->element('FeederAudit')->new( 
        event_date => DateTime::Format::DateParse->parse_datetime($report->event_date_diagnosis),
        event_ref => $report->event_reference_diagnosis,
    );
    return $feeder_audit;
}

sub get_diagnosis {
    my $report         = shift;
    my $pd             = shift;
    my $diagnosis_code = $report->event_icd10_diagnosis_code;
    if ($diagnosis_code) {
        my $diagnosis =
          $pd->element('Diagnosis')->new( code => $diagnosis_code, );
        my $search_code = $diagnosis_code;
        $search_code =~ s/\.//;
        if ( length( $search_code) == 3 ) {
            $search_code .= 'X';
        }
        print Dumper $search_code;
        my $code_name_rs = $schema->resultset('CodesIcd10')
          ->search( { code => $search_code, }, { rows => 1, }, );
        my $code_name = $code_name_rs->first;
        if ($code_name) {
            my $description = $code_name->description;
            if ($description) {
                $diagnosis->value($description);
            }
        }
        else {
            $diagnosis->value($diagnosis_code);
        }
        return $diagnosis;
    }
    else {
        return 0;
    }
}

sub get_testicular_staging {
    my $report             = shift;
    my $pd                 = shift;
    my $testicular_staging = $pd->element('TesticularStaging')->new();
    my $items_found        = 0;
    if ( $report->stage_grouping_testicular ) {
        my $stage_group_testicular = $pd->element('StageGroupTesticular')
          ->new( local_code => $report->stage_grouping_testicular, );
        $testicular_staging->stage_group_testicular(
            [$stage_group_testicular] );
        $items_found++;
    }
    if ( $report->extranodal_metastases_urology ) {
        my $extranodal_metastases_urology = $pd->element('ExtranodalMetastases')
          ->new( local_code => $report->extranodal_metastases_urology, );
        $testicular_staging->extranodal_metastases(
            [$extranodal_metastases_urology] );
        $items_found++;
    }
    if ( $report->lung_metastases_urology ) {
        my $lung_metastases = $pd->element('LungMetastases')
          ->new( local_code => $report->lung_metastases_urology, );
        $testicular_staging->lung_metastases( [$lung_metastases] );
        $items_found++;
    }
    if ( $items_found > 0 ) {
        return $testicular_staging;
    }
    else {
        return 0;
    }
}

sub get_cancer_diagnosis {
    my $report           = shift;
    my $pd               = shift;
    my $cancer_diagnosis = $pd->element('CancerDiagnosis')->new();
    if ( $report->tumour_laterality ) {
        my $tumour_laterality = $pd->element('TumourLaterality')
          ->new( local_code => $report->tumour_laterality, );
        $cancer_diagnosis->tumour_laterality( [$tumour_laterality] );
    }
    if ( $report->metastatic_site ) {
        my $metastatic_site = $pd->element('MetastaticSite')
          ->new( local_code => $report->metastatic_site, );
        $cancer_diagnosis->metastatic_site( [$metastatic_site] );
    }
    if ( $report->cancer_recurrence_care_plan_indicator ) {
        my $recurrence_indicator =
          $pd->element('RecurrenceIndicator')
          ->new( local_code => $report->cancer_recurrence_care_plan_indicator,
          );
        $cancer_diagnosis->recurrence_indicator( [$recurrence_indicator] );
    }

    my ( $morphologies, $morphology_snomed, $morphology_icd );
    if ( $report->morphology_snomed ) {
        $morphology_snomed = $pd->element('Morphology')->new(
            local_code  => $report->morphology_snomed,
            terminology => 'SNM198'
        );

        #$cancer_diagnosis->morphology( [$morphology] );
    }
    if ( $report->morphology_icd03 ) {
        $morphology_icd =
          $pd->element('Morphology')
          ->new( local_code => $report->morphology_icd03, );

        #$cancer_diagnosis->morphology( [$morphology] );
    }

    for my $morphology ( ( $morphology_snomed, $morphology_icd ) ) {
        if ($morphology) {
            push @{$morphologies}, $morphology;
        }
    }
    if ( $morphologies->[0] ) {
        $cancer_diagnosis->morphology($morphologies);
    }
    $cancer_diagnosis->morphology($morphologies);
    if ( $report->topography_icd03 ) {
        my $topography =
          $pd->element('Topography')
          ->new( local_code => $report->topography_icd03, );
        $cancer_diagnosis->topography( [$topography] );
    }
    return $cancer_diagnosis;
}

