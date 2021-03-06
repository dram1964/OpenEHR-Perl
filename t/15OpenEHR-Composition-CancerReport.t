use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Composition;

BEGIN { use_ok('OpenEHR::Composition::CancerReport'); }

ok(
    my $feeder_audit1 =
      OpenEHR::Composition::Elements::ProblemDiagnosis::FeederAudit->new(
        event_date => DateTime->new(
            year  => 2011,
            month => 01,
            day   => 01,
        ),
        event_ref => '5C0734F2-512-A414-9CAE-BF1AF760D0AQ',
        system_id => 'Infoflex'
      ),
    'Create First FeederAudit element'
);

ok(
    my $ajcc_stage =
      OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage->new(
        local_code => '1A',
      ),
    'Create new AJCC Stage object'
);

ok(
    my $diagnosis =
      OpenEHR::Composition::Elements::ProblemDiagnosis::Diagnosis->new(
        code  => 'C71.6',
        value => 'Malignant neoplasm of cerebrum, cerebellum',
      ),
    'Create new Diagnosis object'
);

ok(
    my $colorectal_diagnosis =
      OpenEHR::Composition::Elements::ProblemDiagnosis::ColorectalDiagnosis
      ->new(
        local_code => 8,
      ),
    'Create new Diagnosis object'
);

ok(
    my $final_figo_stage =
      OpenEHR::Composition::Elements::ProblemDiagnosis::FinalFigoStage->new(
        local_code => 'IB',
      ),
    'Create new Final Figo object'
);

ok(
    my $modified_dukes =
      OpenEHR::Composition::Elements::ProblemDiagnosis::ModifiedDukes->new(
        local_code => 'D',
      ),
    'Create new Modified Dukes object'
);

ok(
    my $tumour_id =
      OpenEHR::Composition::Elements::ProblemDiagnosis::TumourID->new(
        id       => 'aassdddffee',
        issuer   => 'uclh',
        assigner => 'cancer care',
        type     => 'local',
      ),
    'Create new Tumour ID object'
);

ok(
    my $clinical_evidence =
      OpenEHR::Composition::Elements::ProblemDiagnosis::ClinicalEvidence->new(
        local_code => '2',
      ),
    'Create new Clinical Evidence object'
);

ok(
    my $bclc_stage =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::BCLC_Stage
      ->new(
        local_code => 'D',
      ),
    'Create new BCLC Stage object'
);

ok(
    my $portal_invasion =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PortalInvasion
      ->new(
        local_code => 'N',
      ),
    'Create new Portal Invasion object'
);

ok(
    my $pancreatic_clinical_stage =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::PancreaticClinicalStage
      ->new(
        local_code => '10',
      ),
    'Create new Pancreatic Clinical Stage object'
);

ok(
    my $child_pugh_score =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::ChildPughScore
      ->new(
        local_code => 'B',
      ),
    'Create new Child-Pugh Score object'
);

ok(
    my $tace =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI::TACE->new(
        local_code => 'Y',
      ),
    'Create new TACE object'
);

ok(
    my $upper_gi =
      OpenEHR::Composition::Elements::ProblemDiagnosis::UpperGI->new(
        bclc_stage                => [$bclc_stage],
        portal_invasion           => [$portal_invasion],
        pancreatic_clinical_stage => [$pancreatic_clinical_stage],
        child_pugh_score          => [$child_pugh_score],
        tace                      => [$tace],
        lesions                   => '95',
      ),
    'Create new Upper GI object'
);

ok(
    my $tumour_laterality =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::TumourLaterality
      ->new(
        local_code => '9',
      ),
    'Create new Tumour Laterality object'
);

ok(
    my $metastatic_site =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::MetastaticSite
      ->new(
        local_code => '08',
      ),
    'Create new Metastatic Site object'
);

ok(
    my $recurrence_indicator =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::RecurrenceIndicator
      ->new(
        local_code => 'NN',
      ),
    'Create new Recurrence Indicator object'
);

ok(
    my $morphology =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::Morphology
      ->new(
        local_code => '8071/3',
      ),
    'Create new Morphology object'
);

ok(
    my $topography =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis::Topography
      ->new(
        local_code => 'C06.9',
      ),
    'Create new Topography object'
);

ok(
    my $cancer_diagnosis =
      OpenEHR::Composition::Elements::ProblemDiagnosis::CancerDiagnosis->new(
        tumour_laterality    => [$tumour_laterality],
        metastatic_site      => [$metastatic_site],
        recurrence_indicator => [$recurrence_indicator],
        morphology           => [$morphology],
        topography           => [$topography],
      ),
    'Create new Cancer Diagnosis object'
);

ok(
    my $integrated_tnm =
      OpenEHR::Composition::Elements::ProblemDiagnosis::Integrated_TNM->new(
        integrated_t         => 'Integrated T 90',
        integrated_m         => 'Integrated M 25',
        stage_grouping       => 'Integrated Stage grouping 31',
        tnm_edition          => 'Integrated TNM Edition 44',
        integrated_n         => 'Integrated N 15',
        grading_at_diagnosis => 'G4',
      ),
    'Create new Integrated TNM object'
);

ok(
    my $inrg_staging =
      OpenEHR::Composition::Elements::ProblemDiagnosis::INRG_Staging->new(
        local_code => 'M',
      ),
    'Create new INRG Staging object'
);

ok(
    my $lung_metastases =
      OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::LungMetastases
      ->new(
        local_code => 'L1',
      ),
    'Create new Lung Metastases object'
);

ok(
    my $extranodal_metastases =
      OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::ExtranodalMetastases
      ->new(
        local_code => 'B',
      ),
    'Create new Extranodal Metastases object'
);

ok(
    my $stage_group_testicular =
      OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging::StageGroupTesticular
      ->new(
        local_code => '3C',
      ),
    'Create new Lung Metastases object'
);

ok(
    my $testicular_staging =
      OpenEHR::Composition::Elements::ProblemDiagnosis::TesticularStaging->new(
        lung_metastases        => [$lung_metastases],
        extranodal_metastases  => [$extranodal_metastases],
        stage_group_testicular => [$stage_group_testicular],
      ),
    'Create new Testicular Staging object'
);

my $event_date = DateTime->new(
    year  => 2016,
    month => 10,
    day   => 15,
);

ok(
    my $problem_diagnosis1 =
      OpenEHR::Composition::Elements::ProblemDiagnosis->new(
        ajcc_stage           => [$ajcc_stage],
        diagnosis            => [$diagnosis],
        colorectal_diagnosis => [$colorectal_diagnosis],
        modified_dukes       => [$modified_dukes],
        tumour_id            => [$tumour_id],
        clinical_evidence    => [$clinical_evidence],
        upper_gi_staging     => [$upper_gi],
        integrated_tnm       => [$integrated_tnm],
        inrg_staging         => [$inrg_staging],
        testicular_staging   => [$testicular_staging],
        cancer_diagnosis     => [$cancer_diagnosis],
        final_figo_stage     => [$final_figo_stage],
        feeder_audit        => $feeder_audit1,
      ),
    'Create First ProblemDiagnosis object'
);

$event_date = DateTime->new(
    year  => 2017,
    month => 3,
    day   => 12,
);

ok(
    my $problem_diagnosis2 =
      OpenEHR::Composition::Elements::ProblemDiagnosis->new(
        ajcc_stage           => [$ajcc_stage],
        diagnosis            => [$diagnosis],
        colorectal_diagnosis => [$colorectal_diagnosis],
        modified_dukes       => [$modified_dukes],
        tumour_id            => [$tumour_id],
        clinical_evidence    => [$clinical_evidence],
        upper_gi_staging     => [$upper_gi],
        integrated_tnm       => [$integrated_tnm],
        inrg_staging         => [$inrg_staging],
        testicular_staging   => [$testicular_staging],
        cancer_diagnosis     => [$cancer_diagnosis],
        final_figo_stage     => [$final_figo_stage],
        feeder_audit        => $feeder_audit1,
      ),
    'Create Second ProblemDiagnosis object'
);

my @formats = qw( FLAT STRUCTURED RAW);
#@formats = qw(STRUCTURED);

for my $format (@formats) {
    note("Testing $format format composition");
    my $ehr1 = &get_new_random_subject();
    $ehr1->get_new_ehr;
    if ( $ehr1->err_msg ) {
        die $ehr1->err_msg;
    }
    note( 'EhrId: ' . $ehr1->ehr_id );
    note( 'SubjectId: ' . $ehr1->subject_id );
    ok(
        my $cancer_report = OpenEHR::Composition::CancerReport->new(
            problem_diagnoses => [ $problem_diagnosis1, $problem_diagnosis2 ],
            report_id         => 'TT123123Z',
            report_date       => DateTime->now(),
        ),
        'Create New Cancer Report Object'
    );
    ok( $cancer_report->composition_format($format),
        "Set $format composition format" );
    my $composition = $cancer_report->compose;
    #print Dumper $composition;

    ok( my $query = OpenEHR::REST::Composition->new(), "Construct REST query" );
    ok( $query->composition($cancer_report), "Add composition to new query" );
    ok( $query->template_id('GEL Cancer diagnosis input.v0'),
        "Added template for $format composition" );
    ok( $query->submit_new( $ehr1->ehr_id ), "Submit new composition" );
    ok( !$query->err_msg, "No error message returned from REST call" );
    if ( $query->err_msg ) {
        diag( "Error occurred in submission: " . $query->err_msg );
    }
    is( $query->action, "CREATE", "Action is CREATE" );
    note( $query->compositionUid );    # the returned CompositionUid;
    note( $query->href );              # URL to view the submitted composition;
}

done_testing;

sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
        $subject_id .= '0000000000';
        if ( $subject_id =~ /^(\d{10,10}).*/ ) {
            $subject_id = $1;
        }
        my $subject = {
            subject_id        => $subject_id,
            subject_namespace => 'uk.nhs.nhs_number',
        };
        $ehr = OpenEHR::REST::EHR->new($subject);
        $ehr->find_by_subject_id;
        $action = $ehr->action;
    }
    return $ehr;
}
