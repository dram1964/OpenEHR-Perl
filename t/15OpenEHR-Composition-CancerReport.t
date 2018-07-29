use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::ProblemDiagnosis;
use OpenEHR::Composition::ProblemDiagnosis::AJCC_Stage;
use OpenEHR::Composition::ProblemDiagnosis::Diagnosis;
use OpenEHR::Composition::ProblemDiagnosis::ColorectalDiagnosis;
use OpenEHR::Composition::ProblemDiagnosis::ModifiedDukes;
use OpenEHR::Composition::ProblemDiagnosis::TumourID;
use OpenEHR::Composition::ProblemDiagnosis::ClinicalEvidence;

BEGIN { use_ok('OpenEHR::Composition::CancerReport'); }

my @formats = qw( FLAT STRUCTURED RAW); 
#@formats = qw(RAW);
for my $format (@formats) {
    note("Testing $format format composition");
    my $ehr1 = &get_new_random_subject();
    $ehr1->get_new_ehr;
    if ( $ehr1->err_msg ) {
        die $ehr1->err_msg;
    }
    diag( 'EhrId: ' . $ehr1->ehr_id );
    diag( 'SubjectId: ' . $ehr1->subject_id );

    ok(my $ajcc_stage = OpenEHR::Composition::ProblemDiagnosis::AJCC_Stage->new(
            ajcc_stage_grouping => 'Stage IB',
        ),'Create new AJCC Stage object'
    );
    ok( $ajcc_stage->composition_format($format), "Set $format format for AJCC Stage");


    ok(my $diagnosis = OpenEHR::Composition::ProblemDiagnosis::Diagnosis->new(
        diagnosis => 'Colorectal Cancer'),  'Create new Diagnosis object');
    ok($diagnosis->composition_format($format), "Set $format format for Diagnosis");

    ok(my $colorectal_diagnosis = OpenEHR::Composition::ProblemDiagnosis::ColorectalDiagnosis->new(
        code => 'at0003',
        value => '2 Appendix',
        terminology => 'local',
        ),  'Create new Diagnosis object');
    ok($colorectal_diagnosis->composition_format($format), "Set $format format for Colorectal Diagnosis");

    ok(my $modified_dukes = OpenEHR::Composition::ProblemDiagnosis::ModifiedDukes->new(
        code => 'at0006',
        value => 'Dukes Stage D',
        terminology => 'local',
        ),  'Create new Modified Dukes object');
    ok($modified_dukes->composition_format($format), "Set $format format for Modified Dukes");

    ok(my $tumour_id = OpenEHR::Composition::ProblemDiagnosis::TumourID->new(
        id => 'aassdddffee',
        issuer => 'uclh',
        assigner => 'cancer care',
        type    => 'local',
        ),  'Create new Tumour ID object');
    ok($tumour_id->composition_format($format), "Set $format format for Tumour ID");

    ok(my $clinical_evidence = OpenEHR::Composition::ProblemDiagnosis::ClinicalEvidence->new(
        evidence => '2 Clinical investigation including all diagnostic techniques',
        ),  'Create new Clinical Evidence object');
    ok($clinical_evidence->composition_format($format), "Set $format format for Clinical Evidence");

    ok( my $problem_diagnosis = OpenEHR::Composition::ProblemDiagnosis->new(
            ajcc_stage => [$ajcc_stage],
            diagnosis   => [$diagnosis],
            colorectal_diagnosis   => [$colorectal_diagnosis],
            modified_dukes  => [$modified_dukes],
            tumour_id => [$tumour_id],
            clinical_evidence => [$clinical_evidence],
        ), 'Create new ProblemDiagnosis object'
    );
    ok( $problem_diagnosis->composition_format($format), "Set $format composition format for ProblemDiagnosis");

    ok( my $cancer_report = OpenEHR::Composition::CancerReport->new(
        problem_diagnoses => [$problem_diagnosis],
        ),
        'Create New Cancer Report Object'
    );
    ok( $cancer_report->composition_format($format), "Set $format composition format");

    ok( my $query = OpenEHR::REST::Composition->new(), "Construct REST query" );
    ok( $query->composition($cancer_report), "Add composition to new query" );
    ok( $query->template_id('GEL Cancer diagnosis input.v0'),
       "Added template for $format composition");
    ok( $query->submit_new( $ehr1->ehr_id ), "Submit new information order" );
    ok( !$query->err_msg, "No error message returned from REST call" );
    if ( $query->err_msg ) {
            diag( "Error occurred in submission: " . $query->err_msg );
    }
    is( $query->action, "CREATE", "Action is CREATE" );
    diag( $query->compositionUid );    # the returned CompositionUid;
    diag( $query->href );              # URL to view the submitted composition;
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
