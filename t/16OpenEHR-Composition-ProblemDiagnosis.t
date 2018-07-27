use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok('OpenEHR::Composition::ProblemDiagnosis'); }


ok(my $problem_diagnosis_0 = OpenEHR::Composition::ProblemDiagnosis->new(), 
    'Constructor with no data');

is($problem_diagnosis_0->composition_format, 'STRUCTURED', 'Default composition format set');
ok(!$problem_diagnosis_0->compose, 'Compose failed for STRUCTURED composition with no data');

my $diagnosis_1 = &diagnosis_1();
ok(my $problem_diagnosis_1 = OpenEHR::Composition::ProblemDiagnosis->new(
    $diagnosis_1), 'Constructor called with hashref');
is($problem_diagnosis_1->composition_format, 'STRUCTURED', 'Default composition format set');
ok($problem_diagnosis_1->compose, 'Compose called for STRUCTURED composition using defaults');

SKIP: {
    skip "Not implemented yet", 1;
    ok(my $problem_diagnosis_2 = OpenEHR::Composition::ProblemDiagnosis->new(),
        'Constructor with no data');
    ok($problem_diagnosis_2->composition_format('FLAT'), 'Set composition format to FLAT');
    ok($problem_diagnosis_2->compose, 'Compose called for FLAT composition');
    print Dumper $problem_diagnosis_2;
};

    

done_testing;

sub diagnosis_1 {
    my $diagnosis = {
        'ajcc_stage' => [
            {   'ajcc_stage_version'  => ['AJCC Stage version 55'],
                'ajcc_stage_grouping' => ['Stage IB']
            }
        ],
        'colorectal_diagnosis' => [
            { 'synchronous_tumour_indicator' => [ { '|code' => 'at0003' } ] }
        ],
        'diagnosis' => ['Diagnosis 59'],
        'modified_dukes_stage' =>
            [ { 'modified_dukes_stage' => [ { '|code' => 'at0006' } ] } ],
        'tumour_id' => [
            {   'tumour_identifier' => [
                    {   '|id'       => '1b85693c-a17a-426c-ad74-0fb086375da3',
                        '|assigner' => 'Assigner',
                        '|issuer'   => 'Issuer',
                        '|type'     => 'Prescription'
                    }
                ]
            }
        ],
        'clinical_evidence' =>
            [ { 'base_of_diagnosis' => ['6 Histology of metastasis'] } ],
        'upper_gi_staging' => [
            {   'transarterial_chemoembolisation' =>
                    [ { '|code' => 'at0015' } ],
                'portal_invasion' => [ { '|code' => 'at0005' } ],
                'child-pugh_score' =>
                    [ { 'grade' => [ { '|code' => 'at0027' } ] } ],
                'pancreatic_clinical_stage' => [ { '|code' => 'at0012' } ],
                'bclc_stage' =>
                    [ { 'bclc_stage' => [ { '|code' => 'at0007' } ] } ],
                'number_of_lesions' => [96]
            }
        ],
        'integrated_tnm' => [
            {   'integrated_stage_grouping' =>
                    ['Integrated Stage grouping 31'],
                'integrated_tnm_edition' => ['Integrated TNM Edition 44'],
                'integrated_n'           => ['Integrated N 15'],
                'grading_at_diagnosis' =>
                    ['G4 Undifferentiated / anaplastic'],
                'integrated_m' => ['Integrated M 25'],
                'integrated_t' => ['Integrated T 99']
            }
        ],
        'inrg_staging' => [ { 'inrg_stage' => [ { '|code' => 'at0004' } ] } ],
        'cancer_diagnosis' => [
            {   'recurrence_indicator' => [ { '|code' => 'at0016' } ],
                'tumour_laterality'    => [ { '|code' => 'at0033' } ],
                'metastatic_site'      => [ { '|code' => 'at0023' } ],
                'topography' => ['Topography 75'],
                'morphology' => ['Morphology 46']
            }
        ],
        'final_figo_stage' => [
            {   'figo_grade' => [ { '|code' => 'at0008' } ],
                'figo_version' => ['FIGO version 99']
            }
        ],
        'event_date'         => ['2018-07-24T14:05:01.806+01:00'],
        'testicular_staging' => [
            {   'lung_metastases_sub-stage_grouping' =>
                    [ { '|code' => 'at0021' } ],
                'extranodal_metastases'     => [ { '|code' => 'at0019' } ],
                'stage_grouping_testicular' => [ { '|code' => 'at0010' } ]
            }
        ]
    };
    return $diagnosis;
}
