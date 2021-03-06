use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok('OpenEHR::Composition::Elements::ProblemDiagnosis'); }

my @formats = qw[FLAT STRUCTURED RAW];
#@formats = qw[RAW];
for my $format (@formats) {
    ok(my $ajcc_stage = OpenEHR::Composition::Elements::ProblemDiagnosis::AJCC_Stage->new(
        local_code => '2a'), 'Create new AJCC Stage object');
    ok($ajcc_stage->composition_format($format), "Set $format format for AJCC Stage");

    ok(my $diagnosis = OpenEHR::Composition::Elements::ProblemDiagnosis::Diagnosis->new(
        diagnosis => 'Colorectal Cancer'),  'Create new Diagnosis object');
    ok($diagnosis->composition_format($format), "Set $format format for Diagnosis Stage");


    ok(my $problem_diagnosis = OpenEHR::Composition::Elements::ProblemDiagnosis->new(
        ajcc_stage => [$ajcc_stage],
        diagnosis => [$diagnosis],
        ), 
        'Constructor with AJCC Stage Data');

    ok($problem_diagnosis->composition_format($format),  "Set $format composition format");
    ok(my $composition = $problem_diagnosis->compose, "Compose called for $format format composition");
    #print Dumper $composition;
}


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
