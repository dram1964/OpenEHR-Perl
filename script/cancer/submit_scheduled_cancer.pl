use strict;
use warnings;
use DateTime::Format::DateParse;
use JSON;
use DBI;

use OpenEHR::Composition::CancerReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomesLiveTest');

my $orders_rs = $schema->resultset('InformationOrder')->search(
    {
        order_state_code => 529,
        subject_id_type  => 'uk.nhs.nhs_number',
        service_type     => 'cancer',
    },
    {
        columns => [
            qw/ subject_ehr_id subject_id data_start_date data_end_date subject_id/
        ]
    },
);

my $patient_number;
while ( my $order = $orders_rs->next ) {
    print join( ":",
        $order->subject_id, $order->data_start_date, $order->data_end_date, ),
      "\n";
    &report_cancer(
        $order->subject_ehr_id,  $order->subject_id,
        $order->data_start_date, $order->data_end_date
    );
}

sub report_cancer {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = @_;
    my $reports_rs = $schema->resultset('InfoflexCancerTest')->search(
        {
            nhs_number           => $nhs_number,
            event_date_diagnosis => { '>=' => $start_date },
            event_date_diagnosis => { '<=' => $end_date },
            reported_date        => undef,
        },
    );
    while ( my $report = $reports_rs->next ) {
        print join( ":",
            $report->patient_hospital_number,
            $report->nhs_number, $report->event_date_diagnosis,
          ),
          "\n";

        my $cancer_report = OpenEHR::Composition::CancerReport->new();

        my $pd = OpenEHR::Composition::Elements::ProblemDiagnosis->new();
        my $problem_diagnosis = $pd->element('ProblemDiagnosis')->new();

        my (
            $ajcc_stage,           $diagnosis,
            $colorectal_diagnosis, $final_figo_stage,
            $modified_dukes,       $tumour_id,
            $clinical_evidence,    $bclc_stage,
            $portal_invasion,      $pancreatic_clinical_stage,
            $child_pugh_score,     $tace,
            $upper_gi,             $tumour_laterality,
            $metastatic_site,      $recurrence_indicator,
            $integrated_tnm,       $inrg_staging,
            $lung_metastases,      $stage_group_testicular,
            $testicular_staging
        );

        my $cancer_diagnosis = $pd->element('CancerDiagnosis')->new();
        if ( $report->tumour_laterality ) {
            my $tumour_laterality = $pd->element('TumourLaterality')->new(
                code        => $report->tumour_laterality,
                value       => $report->tumour_laterality,
                terminology => 'local',
            );
            $cancer_diagnosis->tumour_laterality( [$tumour_laterality] );
        }
        if ( $report->metastatic_site ) {
            my $metastatic_site = $pd->element('MetastaticSite')->new(
                code        => $report->metastatic_site,
                value       => $report->metastatic_site,
                terminology => 'local',
            );
            $cancer_diagnosis->metastatic_site( [$metastatic_site] );
        }
        if ( $report->cancer_recurrence_care_plan_indicator ) {
            my $recurrence_indicator =
              $pd->element('RecurrenceIndicator')->new(
                code        => $report->cancer_recurrence_care_plan_indicator,
                value       => $report->cancer_recurrence_care_plan_indicator,
                terminology => 'local',
              );
            $cancer_diagnosis->recurrence_indicator( [$recurrence_indicator] );
        }
        if ( $report->morphology_icd03 ) {
            $cancer_diagnosis->morphology( $report->morphology_icd03 );
        }
        if ( $report->topography_icd03 ) {
            $cancer_diagnosis->topography( $report->topography_icd03 );
        }
        $problem_diagnosis->cancer_diagnosis( [$cancer_diagnosis] );

        $cancer_report->problem_diagnoses( [ $problem_diagnosis ] );
        $cancer_report->report_id( $ehrid . 'CREP' );
        $cancer_report->composition_format('STRUCTURED');
        my $composition = $cancer_report->compose;
        print Dumper $composition;
    }
}
