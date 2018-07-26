use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::ProblemDiagnosis;

BEGIN { use_ok('OpenEHR::Composition::CancerReport'); }

my @formats = qw( FLAT STRUCTURED); 
@formats = qw(STRUCTURED);
for my $format (@formats) {
    note("Testing $format format composition");
    my $ehr1 = &get_new_random_subject();
    $ehr1->get_new_ehr;
    if ( $ehr1->err_msg ) {
        die $ehr1->err_msg;
    }
    diag( 'EhrId: ' . $ehr1->ehr_id );
    diag( 'SubjectId: ' . $ehr1->subject_id );

    my $diagnosis = &diagnosis_1_structured;
    my $diagnosis_1 = OpenEHR::Composition::ProblemDiagnosis->new($diagnosis);
    my $context_1   = &context_1_structured;

    ok( my $cancer_report = OpenEHR::Composition::CancerReport->new(
            diagnoses => [$diagnosis_1],
            contexts  => [$context_1],
        ),
        'Create New Cancer Report Object'
    );
    ok( $cancer_report->composition_format($format), "Set $format composition format");
    ok( $cancer_report->compose_structured, "Create $format Composition");

    ok( my $query = OpenEHR::REST::Composition->new(), "Construct REST query" );
    ok( $query->composition($cancer_report), "Add composition to new query" );
    ok( $query->template_id('GEL Cancer diagnosis input.v0'),
       "Added template for STRUCTURED composition");
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
sub context_1_structured {
    my $context = {
        'participant' => [
            {   'participant_identifier' => [
                    {   '|id'       => '85e10b15-7b79-46c0-8d94-892cad063048',
                        '|assigner' => 'Assigner',
                        '|issuer'   => 'Issuer',
                        '|type'     => 'Prescription'
                    }
                ],
                'study_identifier' => [
                    {   '|id'       => '0a9db4b5-44cb-4254-ae23-722c1178c265',
                        '|assigner' => 'Assigner',
                        '|issuer'   => 'Issuer',
                        '|type'     => 'Prescription'
                    }
                ]
            }
        ],
        'report_id' => ['Report ID 75']
    };
    return $context;
}

sub diagnosis_1_structured {
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

=head1 structured_composition

    my $composition = {
        'gel_cancer_diagnosis' => {
            'context' => [
                {
                    'participant' => [
                        {
                            'participant_identifier' => [
                                {
                                    '|id' =>
                                      '85e10b15-7b79-46c0-8d94-892cad063048',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ],
                            'study_identifier' => [
                                {
                                    '|id' =>
                                      '0a9db4b5-44cb-4254-ae23-722c1178c265',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ]
                        }
                    ],
                    'report_id' => ['Report ID 75']
                }
            ],
            'problem_diagnosis' => [
                {
                    'ajcc_stage' => [
                        {
                            'ajcc_stage_version'  => ['AJCC Stage version 55'],
                            'ajcc_stage_grouping' => ['Stage IB']
                        }
                    ],
                    'colorectal_diagnosis' => [
                        {
                            'synchronous_tumour_indicator' => [
                                {
                                    '|code' => 'at0003'
                                }
                            ]
                        }
                    ],
                    'diagnosis'            => ['Diagnosis 59'],
                    'modified_dukes_stage' => [
                        {
                            'modified_dukes_stage' => [
                                {
                                    '|code' => 'at0006'
                                }
                            ]
                        }
                    ],
                    'tumour_id' => [
                        {
                            'tumour_identifier' => [
                                {
                                    '|id' =>
                                      '1b85693c-a17a-426c-ad74-0fb086375da3',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ]
                        }
                    ],
                    'clinical_evidence' => [
                        {
                            'base_of_diagnosis' => ['6 Histology of metastasis']
                        }
                    ],
                    'upper_gi_staging' => [
                        {
                            'transarterial_chemoembolisation' => [
                                {
                                    '|code' => 'at0015'
                                }
                            ],
                            'portal_invasion' => [
                                {
                                    '|code' => 'at0005'
                                }
                            ],
                            'child-pugh_score' => [
                                {
                                    'grade' => [
                                        {
                                            '|code' => 'at0027'
                                        }
                                    ]
                                }
                            ],
                            'pancreatic_clinical_stage' => [
                                {
                                    '|code' => 'at0012'
                                }
                            ],
                            'bclc_stage' => [
                                {
                                    'bclc_stage' => [
                                        {
                                            '|code' => 'at0007'
                                        }
                                    ]
                                }
                            ],
                            'number_of_lesions' => [96]
                        }
                    ],
                    'integrated_tnm' => [
                        {
                            'integrated_stage_grouping' =>
                              ['Integrated Stage grouping 31'],
                            'integrated_tnm_edition' =>
                              ['Integrated TNM Edition 44'],
                            'integrated_n' => ['Integrated N 15'],
                            'grading_at_diagnosis' =>
                              ['G4 Undifferentiated / anaplastic'],
                            'integrated_m' => ['Integrated M 25'],
                            'integrated_t' => ['Integrated T 99']
                        }
                    ],
                    'inrg_staging' => [
                        {
                            'inrg_stage' => [
                                {
                                    '|code' => 'at0004'
                                }
                            ]
                        }
                    ],
                    'cancer_diagnosis' => [
                        {
                            'recurrence_indicator' => [
                                {
                                    '|code' => 'at0016'
                                }
                            ],
                            'tumour_laterality' => [
                                {
                                    '|code' => 'at0033'
                                }
                            ],
                            'metastatic_site' => [
                                {
                                    '|code' => 'at0023'
                                }
                            ],
                            'topography' => ['Topography 75'],
                            'morphology' => ['Morphology 46']
                        }
                    ],
                    'final_figo_stage' => [
                        {
                            'figo_grade' => [
                                {
                                    '|code' => 'at0008'
                                }
                            ],
                            'figo_version' => ['FIGO version 99']
                        }
                    ],
                    'event_date'         => ['2018-07-24T14:05:01.806+01:00'],
                    'testicular_staging' => [
                        {
                            'lung_metastases_sub-stage_grouping' => [
                                {
                                    '|code' => 'at0021'
                                }
                            ],
                            'extranodal_metastases' => [
                                {
                                    '|code' => 'at0019'
                                }
                            ],
                            'stage_grouping_testicular' => [
                                {
                                    '|code' => 'at0010'
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        'ctx/participation_function'    => 'requester',
        'ctx/id_scheme'                 => 'HOSPITAL-NS',
        'ctx/participation_id:1'        => '198',
        'ctx/composer_name'             => 'Silvia Blake',
        'ctx/participation_function:1'  => 'performer',
        'ctx/participation_name:1'      => 'Lara Markham',
        'ctx/health_care_facility|name' => 'Hospital',
        'ctx/participation_name'        => 'Dr. Marcus Johnson',
        'ctx/territory'                 => 'US',
        'ctx/health_care_facility|id'   => '9091',
        'ctx/participation_mode'        => 'face-to-face communication',
        'ctx/participation_id'          => '199',
        'ctx/language'                  => 'en',
        'ctx/id_namespace'              => 'HOSPITAL-NS'
    };
=cut

