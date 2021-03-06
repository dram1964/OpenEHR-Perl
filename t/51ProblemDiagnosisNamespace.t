use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Composition;

BEGIN { use_ok('OpenEHR::Composition::CancerReport'); }

ok( my $pd = OpenEHR::Composition::Elements::ProblemDiagnosis->new(),
    'Setup ProblemDiagnosis Schema' );

ok(
    my $feeder_audit =
      $pd->element('FeederAudit')->new(
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
    my $ajcc_stage = $pd->element('AJCC_Stage')->new(
        local_code => '1B',
    ),
    'Create new AJCC Stage object'
);

ok(
    my $diagnosis = $pd->element('Diagnosis')->new(
        code => 'C71.6',
        value => 'Malignant neoplasm of cerebrum, cerebellum',
    ),
    'Create new Diagnosis object'
);

ok(
    my $colorectal_diagnosis = $pd->element('ColorectalDiagnosis')->new(
        local_code       => '2',
    ),
    'Create new Diagnosis object'
);

ok(
    my $final_figo_stage = $pd->element('FinalFigoStage')->new(
        local_code => 'IB',
    ),
    'Create new Final Figo object'
);

ok(
    my $modified_dukes = $pd->element('ModifiedDukes')->new(
        local_code => 'B'
    ),
    'Create new Modified Dukes object'
);

ok(
    my $tumour_id = $pd->element('TumourID')->new(
        id       => 'aassdddffee',
        issuer   => 'uclh',
        assigner => 'cancer care',
        type     => 'local',
    ),
    'Create new Tumour ID object'
);

ok(
    my $clinical_evidence = $pd->element('ClinicalEvidence')->new(
        local_code => '0',),
    'Create new Clinical Evidence object'
);

ok(
    my $bclc_stage = $pd->element('BCLC_Stage')->new(
        local_code => 'D',
    ),
    'Create new BCLC Stage object'
);

ok(
    my $portal_invasion = $pd->element('PortalInvasion')->new(
        local_code       => 'N',
    ),
    'Create new Portal Invasion object'
);

ok(
    my $pancreatic_clinical_stage =
      $pd->element('PancreaticClinicalStage')->new(
        local_code => 31,
      ),
    'Create new Pancreatic Clinical Stage object'
);

ok(
    my $child_pugh_score = $pd->element('ChildPughScore')->new(
        local_code => 'A',
    ),
    'Create new Child-Pugh Score object'
);

ok(
    my $tace = $pd->element('TACE')->new(
        local_code => 'Y',
    ),
    'Create new TACE object'
);

ok(
    my $upper_gi = $pd->element('UpperGI')->new(
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
    my $tumour_laterality = $pd->element('TumourLaterality')->new(
        local_code       => 'B',
    ),
    'Create new Tumour Laterality object'
);

ok(
    my $metastatic_site = $pd->element('MetastaticSite')->new(
        local_code       => '08',
    ),
    'Create new Metastatic Site object'
);

ok(
    my $recurrence_indicator = $pd->element('RecurrenceIndicator')->new(
        local_code       => 'NN',
    ),
    'Create new Recurrence Indicator object'
);

ok( 
    my $morphology1 = $pd->element('Morphology')->new(
        local_code      => '8071/3',
    ),
    'Create new Morphology object'
);

ok( 
    my $morphology2 = $pd->element('Morphology')->new(
        local_code      => 'M80713',
        terminology => 'SNOMED-NK'
    ),
    'Create new Morphology object'
);

ok( 
    my $topography = $pd->element('Topography')->new(
        local_code      => 'C06.9',
    ),
    'Create new Topography object'
);

ok(
    my $cancer_diagnosis = $pd->element('CancerDiagnosis')->new(
        tumour_laterality    => [$tumour_laterality],
        metastatic_site      => [$metastatic_site],
        recurrence_indicator => [$recurrence_indicator],
        morphology           => [$morphology1, $morphology2],
        topography           => [$topography],
    ),
    'Create new Cancer Diagnosis object'
);

ok(
    my $integrated_tnm = $pd->element('Integrated_TNM')->new(
        integrated_t         => 'T1a',
        integrated_m         => 'M0',
        stage_grouping       => 'I',
        tnm_edition          => '7',
        integrated_n         => 'N0',
        grading_at_diagnosis => 'GX',
    ),
    'Create new Integrated TNM object'
);

ok(
    my $inrg_staging = $pd->element('INRG_Staging')->new(
        local_code=> 'M',
    ),
    'Create new INRG Staging object'
);

ok(
    my $lung_metastases = $pd->element('LungMetastases')->new(
        local_code       => 'L1',
    ),
    'Create new Lung Metastases object'
);

ok(
    my $extranodal_metastases = $pd->element('ExtranodalMetastases')->new(
        local_code       => 'L',
    ),
    'Create new Extranodal Metastases object'
);

ok(
    my $stage_group_testicular = $pd->element('StageGroupTesticular')->new(
        local_code       => '3A',
    ),
    'Create new Lung Metastases object'
);

ok(
    my $testicular_staging = $pd->element('TesticularStaging')->new(
        lung_metastases        => [$lung_metastases],
        extranodal_metastases        => [$extranodal_metastases],
        stage_group_testicular => [$stage_group_testicular],
    ),
    'Create new Testicular Staging object'
);

ok(
    my $problem_diagnosis = $pd->element('ProblemDiagnosis')->new(
        feeder_audit         => $feeder_audit,
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
    ),
    'Create new ProblemDiagnosis object'
);

my @formats = qw( FLAT STRUCTURED RAW);

for my $format (@formats) {
    note("Testing $format format composition");
    SKIP: {
        skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
            unless $ENV{OPENEHR_SUBMISSION};
        my $ehr1 = &get_new_random_subject();
        $ehr1->get_new_ehr;
        if ( $ehr1->err_msg ) {
            die $ehr1->err_msg;
        }
        note( 'EhrId: ' . $ehr1->ehr_id );
        note( 'SubjectId: ' . $ehr1->subject_id );
        ok(
            my $cancer_report = OpenEHR::Composition::CancerReport->new(
                problem_diagnoses => [$problem_diagnosis],
                report_id         => $ehr1->ehr_id . 'CREP',
                report_date => DateTime->now,
            ),
            'Create New Cancer Report Object'
        );
        ok( $cancer_report->composition_format($format),
            "Set $format composition format" );

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
    };
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
