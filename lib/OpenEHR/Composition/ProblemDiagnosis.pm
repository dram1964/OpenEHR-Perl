package OpenEHR::Composition::ProblemDiagnosis;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

=head2 ajcc_stage($ajcc_stage_object)

Used to get or set the AJCC Stage item for the Problem Diagnosis

=cut

has ajcc_stage => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::ProblemDiagnosis::AJCC_Stage',
);
has colorectal_diagnosis => (
    is  => 'rw',
    isa => 'ArrayRef',
);

=head2 diagnosis($diagnosis_object)

Used to get or set the diagnosis item for the Problem Diagnosis

=cut 

has diagnosis => (
    is  => 'rw',
    isa => 'OpenEHR::Composition::ProblemDiagnosis::Diagnosis',
);
has modified_dukes_stage => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has tumour_id => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has clinical_evidence => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has upper_gi_staging => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has integrated_tnm => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has inrg_staging => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has cancer_diagnosis => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has final_figo_stage => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has event_date => (
    is  => 'rw',
    isa => 'ArrayRef',
);
has testicular_staging => (
    is  => 'rw',
    isa => 'ArrayRef',
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
        'tumour_id' => [
            {   'tumour_identifier' => [
                    {   '|type'     => 'Prescription',
                        '|issuer'   => 'Issuer',
                        '|id'       => '5f51555a-249c-4f3e-9e98-5ca555839a9f',
                        '|assigner' => 'Assigner'
                    }
                ]
            }
        ],
        'modified_dukes_stage' =>
            [ { 'modified_dukes_stage' => [ { '|code' => 'at0007' } ] } ],
        'integrated_tnm' => [
            {   'integrated_m' => ['Integrated M 80'],
                'integrated_t' => ['Integrated T 28'],
                'integrated_stage_grouping' =>
                    ['Integrated Stage grouping 25'],
                'integrated_n'           => ['Integrated N 98'],
                'grading_at_diagnosis'   => ['G3 Poorly differentiated'],
                'integrated_tnm_edition' => ['Integrated TNM Edition 41']
            }
        ],
        'colorectal_diagnosis' => [
            { 'synchronous_tumour_indicator' => [ { '|code' => 'at0002' } ] }
        ],
        'final_figo_stage' => [
            {   'figo_version' => ['FIGO version 46'],
                'figo_grade'   => [ { '|code' => 'at0017' } ]
            }
        ],
        'event_date'         => ['2018-07-27T08:21:34.077+01:00'],
        'testicular_staging' => [
            {   'lung_metastases_sub-stage_grouping' =>
                    [ { '|code' => 'at0021' } ],
                'extranodal_metastases'     => [ { '|code' => 'at0019' } ],
                'stage_grouping_testicular' => [ { '|code' => 'at0007' } ]
            }
        ],
        'upper_gi_staging' => [
            {   'bclc_stage' =>
                    [ { 'bclc_stage' => [ { '|code' => 'at0005' } ] } ],
                'number_of_lesions' => [578],
                'child-pugh_score' =>
                    [ { 'grade' => [ { '|code' => 'at0028' } ] } ],
                'transarterial_chemoembolisation' =>
                    [ { '|code' => 'at0015' } ],
                'pancreatic_clinical_stage' => [ { '|code' => 'at0009' } ],
                'portal_invasion'           => [ { '|code' => 'at0004' } ]
            }
        ],
        'inrg_staging' => [ { 'inrg_stage' => [ { '|code' => 'at0005' } ] } ],
        'clinical_evidence' => [
            {   'base_of_diagnosis' => [
                    '2 Clinical investigation including all diagnostic techniques'
                ]
            }
        ],
        'cancer_diagnosis' => [
            {   'morphology'           => ['Morphology 86'],
                'tumour_laterality'    => [ { '|code' => 'at0029' } ],
                'metastatic_site'      => [ { '|code' => 'at0023' } ],
                'topography'           => ['Topography 90'],
                'recurrence_indicator' => [ { '|code' => 'at0014' } ]
            }
        ],
    };
    if ( $self->diagnosis ) {
        $composition->{diagnosis} = [ $self->diagnosis->compose ];
    }
    if ( $self->ajcc_stage ) {
        $composition->{ajcc_stage} = [ $self->ajcc_stage->compose ];
    }
    return $composition;
}

sub compose_raw {
    my $self        = shift;
    my $composition = {
        'archetype_node_id' => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
        'data'              => {
            'name' => {
                'value'  => 'structure',
                '@class' => 'DV_TEXT'
            },
            'items' => [
                {   'name' => {
                        'value'  => 'Tumour ID',
                        '@class' => 'DV_TEXT'
                    },
                    'items' => [
                        {   'value' => {
                                'id' =>
                                    '1b85693c-a17a-426c-ad74-0fb086375da3',
                                'issuer'   => 'Issuer',
                                '@class'   => 'DV_IDENTIFIER',
                                'assigner' => 'Assigner',
                                'type'     => 'Prescription'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Tumour identifier'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        }
                    ],
                    'archetype_details' => {
                        'archetype_id' => {
                            'value' => 'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        'rm_version' => '1.0.1',
                        '@class'     => 'ARCHETYPED'
                    },
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.tumour_id_gel.v0',
                    '@class' => 'CLUSTER'
                },
                {   'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            '@class' => 'ARCHETYPE_ID',
                            'value' =>
                                'openEHR-EHR-CLUSTER.clinical_evidence.v1'
                        }
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Clinical evidence'
                    },
                    'items' => [
                        {   'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => '6 Histology of metastasis'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Base of diagnosis'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0003'
                        }
                    ],
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.clinical_evidence.v1',
                    '@class' => 'CLUSTER'
                },
                {   '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                    'name' => {
                        'value'  => 'Cancer diagnosis',
                        '@class' => 'DV_TEXT'
                    },
                    'items' => [
                        {   'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    },
                                    '@class'      => 'CODE_PHRASE',
                                    'code_string' => 'at0016'
                                },
                                'value' => 'NN'
                            },
                            'name' => {
                                'value'  => 'Recurrence indicator',
                                '@class' => 'DV_TEXT'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0013'
                        },
                        {   'value' => {
                                'value'  => 'Morphology 46',
                                '@class' => 'DV_TEXT'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Morphology'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        },
                        {   'archetype_node_id' => 'at0002',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Topography'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Topography 75'
                            }
                        },
                        {   'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'value'         => '08 Skin',
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    },
                                    'code_string' => 'at0023',
                                    '@class'      => 'CODE_PHRASE'
                                }
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Metastatic site'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0017'
                        },
                        {   'archetype_node_id' => 'at0028',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Tumour laterality'
                            },
                            'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'value'         => 'Not known',
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    },
                                    'code_string' => 'at0033',
                                    '@class'      => 'CODE_PHRASE'
                                }
                            }
                        }
                    ],
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'archetype_id' => {
                            'value' =>
                                'openEHR-EHR-CLUSTER.cancer_diagnosis_gel.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        'rm_version' => '1.0.1'
                    }
                },
                {   'items' => [
                        {   'archetype_node_id' => 'at0001',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                'value'  => 'Integrated T',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated T 99'
                            }
                        },
                        {   'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated N'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated N 15'
                            },
                            'archetype_node_id' => 'at0002',
                            '@class'            => 'ELEMENT'
                        },
                        {   'archetype_node_id' => 'at0003',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated M'
                            },
                            'value' => {
                                'value'  => 'Integrated M 25',
                                '@class' => 'DV_TEXT'
                            }
                        },
                        {   'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Grading at diagnosis'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'G4 Undifferentiated / anaplastic'
                            },
                            'archetype_node_id' => 'at0005',
                            '@class'            => 'ELEMENT'
                        },
                        {   'archetype_node_id' => 'at0007',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated Stage grouping'
                            },
                            'value' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated Stage grouping 31'
                            }
                        },
                        {   '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0017',
                            'value'             => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated TNM Edition 44'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Integrated TNM Edition'
                            }
                        }
                    ],
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Integrated TNM'
                    },
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            '@class' => 'ARCHETYPE_ID',
                            'value' =>
                                'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0'
                        }
                    },
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.tnm_stage_clinical.v0',
                    '@class' => 'CLUSTER'
                },
                {   'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'archetype_id' => {
                            '@class' => 'ARCHETYPE_ID',
                            'value'  => 'openEHR-EHR-CLUSTER.inrg_staging.v0'
                        },
                        'rm_version' => '1.0.1'
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'INRG staging'
                    },
                    'items' => [
                        {   'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'defining_code' => {
                                    'code_string'    => 'at0004',
                                    '@class'         => 'CODE_PHRASE',
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    }
                                },
                                'value' => 'M'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'INRG stage'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        }
                    ],
                    '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.inrg_staging.v0'
                },
                {   'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                    '@class'            => 'CLUSTER',
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'archetype_id' => {
                            'value' =>
                                'openEHR-EHR-CLUSTER.modified_dukes_stage.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        'rm_version' => '1.0.1'
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Modified Dukes stage'
                    },
                    'items' => [
                        {   'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'defining_code' => {
                                    'code_string'    => 'at0006',
                                    '@class'         => 'CODE_PHRASE',
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    }
                                },
                                'value' => 'Dukes Stage D'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Modified Dukes stage'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        }
                    ]
                },
                {   '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.figo_grade.v0',
                    'items' => [
                        {   'archetype_node_id' => 'at0001',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'FIGO grade'
                            },
                            'value' => {
                                'value'         => 'ib',
                                'defining_code' => {
                                    'code_string'    => 'at0008',
                                    '@class'         => 'CODE_PHRASE',
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    }
                                },
                                '@class' => 'DV_CODED_TEXT'
                            }
                        },
                        {   'archetype_node_id' => 'at0005',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                'value'  => 'FIGO version',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                'value'  => 'FIGO version 99',
                                '@class' => 'DV_TEXT'
                            }
                        }
                    ],
                    'name' => {
                        'value'  => 'Final FIGO stage',
                        '@class' => 'DV_TEXT'
                    },
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            'value'  => 'openEHR-EHR-CLUSTER.figo_grade.v0',
                            '@class' => 'ARCHETYPE_ID'
                        }
                    }
                },
                {   'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0',
                    '@class' => 'CLUSTER',
                    'name'   => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Upper GI staging'
                    },
                    'items' => [
                        {   'archetype_node_id' =>
                                'openEHR-EHR-CLUSTER.bclc_stage.v0',
                            '@class' => 'CLUSTER',
                            'items'  => [
                                {   'value' => {
                                        '@class'        => 'DV_CODED_TEXT',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            '@class'      => 'CODE_PHRASE',
                                            'code_string' => 'at0007'
                                        },
                                        'value' => 'D'
                                    },
                                    'name' => {
                                        '@class' => 'DV_TEXT',
                                        'value'  => 'BCLC stage'
                                    },
                                    '@class'            => 'ELEMENT',
                                    'archetype_node_id' => 'at0001'
                                }
                            ],
                            'name' => {
                                'value'  => 'BCLC stage',
                                '@class' => 'DV_TEXT'
                            },
                            'archetype_details' => {
                                'archetype_id' => {
                                    '@class' => 'ARCHETYPE_ID',
                                    'value' =>
                                        'openEHR-EHR-CLUSTER.bclc_stage.v0'
                                },
                                'rm_version' => '1.0.1',
                                '@class'     => 'ARCHETYPED'
                            }
                        },
                        {   'archetype_details' => {
                                'rm_version'   => '1.0.1',
                                'archetype_id' => {
                                    '@class' => 'ARCHETYPE_ID',
                                    'value' =>
                                        'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                                },
                                '@class' => 'ARCHETYPED'
                            },
                            'items' => [
                                {   '@class'            => 'ELEMENT',
                                    'archetype_node_id' => 'at0026',
                                    'value'             => {
                                        '@class' => 'DV_CODED_TEXT',
                                        'value'  => 'Class A 5 to 6 points.',
                                        'defining_code' => {
                                            'terminology_id' => {
                                                'value'  => 'local',
                                                '@class' => 'TERMINOLOGY_ID'
                                            },
                                            'code_string' => 'at0027',
                                            '@class'      => 'CODE_PHRASE'
                                        }
                                    },
                                    'name' => {
                                        '@class' => 'DV_TEXT',
                                        'value'  => 'Grade'
                                    }
                                }
                            ],
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Child-Pugh score'
                            },
                            '@class' => 'CLUSTER',
                            'archetype_node_id' =>
                                'openEHR-EHR-CLUSTER.child_pugh_score.v0'
                        },
                        {   'name' => {
                                'value'  => 'Portal invasion',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                'value'         => 'N Not present',
                                'defining_code' => {
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    },
                                    '@class'      => 'CODE_PHRASE',
                                    'code_string' => 'at0005'
                                },
                                '@class' => 'DV_CODED_TEXT'
                            },
                            'archetype_node_id' => 'at0003',
                            '@class'            => 'ELEMENT'
                        },
                        {   '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0007',
                            'value'             => {
                                'magnitude' => 96,
                                '@class'    => 'DV_COUNT'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Number of lesions'
                            }
                        },
                        {   '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0008',
                            'value'             => {
                                '@class'        => 'DV_CODED_TEXT',
                                'defining_code' => {
                                    'code_string'    => 'at0012',
                                    '@class'         => 'CODE_PHRASE',
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    }
                                },
                                'value' => '31 Unresectable locally advanced'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Pancreatic clinical stage'
                            }
                        },
                        {   'value' => {
                                'value'         => 'Y Yes',
                                'defining_code' => {
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    },
                                    '@class'      => 'CODE_PHRASE',
                                    'code_string' => 'at0015'
                                },
                                '@class' => 'DV_CODED_TEXT'
                            },
                            'name' => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Transarterial chemoembolisation'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0014'
                        }
                    ],
                    'archetype_details' => {
                        'archetype_id' => {
                            '@class' => 'ARCHETYPE_ID',
                            'value' =>
                                'openEHR-EHR-CLUSTER.upper_gi_staging_gel.v0'
                        },
                        'rm_version' => '1.0.1',
                        '@class'     => 'ARCHETYPED'
                    }
                },
                {   'items' => [
                        {   'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'value'         => '3C',
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    },
                                    'code_string' => 'at0010',
                                    '@class'      => 'CODE_PHRASE'
                                }
                            },
                            'name' => {
                                'value'  => 'Stage grouping testicular',
                                '@class' => 'DV_TEXT'
                            },
                            '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001'
                        },
                        {   'archetype_node_id' => 'at0014',
                            '@class'            => 'ELEMENT',
                            'name'              => {
                                '@class' => 'DV_TEXT',
                                'value'  => 'Extranodal metastases'
                            },
                            'value' => {
                                '@class'        => 'DV_CODED_TEXT',
                                'defining_code' => {
                                    'code_string'    => 'at0019',
                                    '@class'         => 'CODE_PHRASE',
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    }
                                },
                                'value' => 'L Lung involvement'
                            }
                        },
                        {   'name' => {
                                'value' =>
                                    'Lung metastases sub-stage grouping',
                                '@class' => 'DV_TEXT'
                            },
                            'value' => {
                                'value' =>
                                    'L1 less than or equal to 3 metastases',
                                'defining_code' => {
                                    'terminology_id' => {
                                        '@class' => 'TERMINOLOGY_ID',
                                        'value'  => 'local'
                                    },
                                    'code_string' => 'at0021',
                                    '@class'      => 'CODE_PHRASE'
                                },
                                '@class' => 'DV_CODED_TEXT'
                            },
                            'archetype_node_id' => 'at0020',
                            '@class'            => 'ELEMENT'
                        }
                    ],
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Testicular staging'
                    },
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'archetype_id' => {
                            'value' =>
                                'openEHR-EHR-CLUSTER.testicular_staging_gel.v0',
                            '@class' => 'ARCHETYPE_ID'
                        },
                        'rm_version' => '1.0.1'
                    },
                    '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.testicular_staging_gel.v0'
                },
                {   'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Colorectal diagnosis'
                    },
                    'items' => [
                        {   '@class'            => 'ELEMENT',
                            'archetype_node_id' => 'at0001',
                            'value'             => {
                                'value'         => '2 Appendix',
                                'defining_code' => {
                                    '@class'         => 'CODE_PHRASE',
                                    'code_string'    => 'at0003',
                                    'terminology_id' => {
                                        'value'  => 'local',
                                        '@class' => 'TERMINOLOGY_ID'
                                    }
                                },
                                '@class' => 'DV_CODED_TEXT'
                            },
                            'name' => {
                                'value'  => 'Synchronous tumour indicator',
                                '@class' => 'DV_TEXT'
                            }
                        }
                    ],
                    'archetype_details' => {
                        '@class'       => 'ARCHETYPED',
                        'rm_version'   => '1.0.1',
                        'archetype_id' => {
                            '@class' => 'ARCHETYPE_ID',
                            'value' =>
                                'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0'
                        }
                    },
                    '@class' => 'CLUSTER',
                    'archetype_node_id' =>
                        'openEHR-EHR-CLUSTER.colorectal_diagnosis_gel.v0'
                }
            ],
            '@class'            => 'ITEM_TREE',
            'archetype_node_id' => 'at0001'
        },
        'name' => {
            '@class' => 'DV_TEXT',
            'value'  => 'Problem/Diagnosis'
        },
        'archetype_details' => {
            'rm_version'   => '1.0.1',
            'archetype_id' => {
                'value'  => 'openEHR-EHR-EVALUATION.problem_diagnosis.v1',
                '@class' => 'ARCHETYPE_ID'
            },
            '@class' => 'ARCHETYPED'
        },
        'protocol' => {
            'archetype_node_id' => 'at0032',
            '@class'            => 'ITEM_TREE',
            'items'             => [
                {   '@class'            => 'ELEMENT',
                    'archetype_node_id' => 'at0070',
                    'value'             => {
                        '@class' => 'DV_DATE_TIME',
                        'value'  => '2018-07-24T14:05:01.806+01:00'
                    },
                    'name' => {
                        '@class' => 'DV_TEXT',
                        'value'  => 'Event date'
                    }
                }
            ],
            'name' => {
                'value'  => 'Tree',
                '@class' => 'DV_TEXT'
            }
        },
        'language' => {
            'code_string'    => 'en',
            '@class'         => 'CODE_PHRASE',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value'  => 'ISO_639-1'
            }
        },
        'encoding' => {
            'terminology_id' => {
                'value'  => 'IANA_character-sets',
                '@class' => 'TERMINOLOGY_ID'
            },
            'code_string' => 'UTF-8',
            '@class'      => 'CODE_PHRASE'
        },
        '@class'  => 'EVALUATION',
        'subject' => { '@class' => 'PARTY_SELF' }
    };
    if ( $self->diagnosis ) {
        push @{ $composition->{data}->{items} }, $self->diagnosis->compose;
    }
    if ( $self->ajcc_stage ) {
        push @{ $composition->{data}->{items} }, $self->ajcc_stage->compose;
    }
    return $composition;
}

sub compose_flat {
    my $self        = shift;
    my $composition = {

        # Problem Diagnosis
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/language|terminology'
            => 'ISO_639-1',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/language|code' =>
            'en',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/encoding|code' =>
            'UTF-8',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/event_date' =>
            '2018-07-24T14:05:01.806+01:00',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/encoding|terminology'
            => 'IANA_character-sets',

        # Upper GI Staging
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/portal_invasion|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/pancreatic_clinical_stage|value'
            => '31 Unresectable locally advanced',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/number_of_lesions'
            => 97,
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/child-pugh_score:0/grade|code'
            => 'at0027',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/bclc_stage:0/bclc_stage|value'
            => 'D',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/transarterial_chemoembolisation|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/bclc_stage:0/bclc_stage|code'
            => 'at0007',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/pancreatic_clinical_stage|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/child-pugh_score:0/grade|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/pancreatic_clinical_stage|code'
            => 'at0012',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/transarterial_chemoembolisation|value'
            => 'Y Yes',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/transarterial_chemoembolisation|code'
            => 'at0015',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/bclc_stage:0/bclc_stage|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/portal_invasion|value'
            => 'N Not present',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/child-pugh_score:0/grade|value'
            => 'Class A 5 to 6 points.',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/upper_gi_staging/portal_invasion|code'
            => 'at0005',

        # Cancer Diagnosis
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/tumour_laterality|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/recurrence_indicator|value'
            => 'NN',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/tumour_laterality|code'
            => 'at0033',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/tumour_laterality|value'
            => 'Not known',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/topography'
            => 'Topography 75',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/metastatic_site|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/recurrence_indicator|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/metastatic_site|code'
            => 'at0023',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/morphology:0'
            => 'Morphology 46',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/metastatic_site|value'
            => '08 Skin',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/cancer_diagnosis/recurrence_indicator|code'
            => 'at0016',

        # Integrated TNM
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/integrated_t'
            => 'Integrated T 99',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/integrated_m'
            => 'Integrated M 25',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/integrated_stage_grouping'
            => 'Integrated Stage grouping 31',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/integrated_tnm_edition'
            => 'Integrated TNM Edition 44',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/integrated_n'
            => 'Integrated N 15',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/integrated_tnm/grading_at_diagnosis'
            => 'G4 Undifferentiated / anaplastic',

        # Final Figo Stage
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|code'
            => 'at0008',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|value'
            => 'ib',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_version'
            => 'FIGO version 99',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|terminology'
            => 'local',

        # INRG Staging
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/inrg_staging:0/inrg_stage|code'
            => 'at0004',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/inrg_staging:0/inrg_stage|value'
            => 'M',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/inrg_staging:0/inrg_stage|terminology'
            => 'local',

        # Clinical Evidence
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/clinical_evidence:0/base_of_diagnosis'
            => '6 Histology of metastasis',

        # Testicular Staging
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/extranodal_metastases|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/stage_grouping_testicular|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/stage_grouping_testicular|code'
            => 'at0010',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/extranodal_metastases|code'
            => 'at0019',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/stage_grouping_testicular|value'
            => '3C',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/lung_metastases_sub-stage_grouping|code'
            => 'at0021',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/lung_metastases_sub-stage_grouping|value'
            => 'L1 less than or equal to 3 metastases',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/extranodal_metastases|value'
            => 'L Lung involvement',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/testicular_staging/lung_metastases_sub-stage_grouping|terminology'
            => 'local',

        # Tumour ID
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id/tumour_identifier:0|issuer'
            => 'Issuer',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id/tumour_identifier:0'
            => '1b85693c-a17a-426c-ad74-0fb086375da3',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id/tumour_identifier:0|assigner'
            => 'Assigner',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/tumour_id/tumour_identifier:0|type'
            => 'Prescription',

        # Colorectal Diagnosis
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/colorectal_diagnosis/synchronous_tumour_indicator:0|value'
            => '2 Appendix',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/colorectal_diagnosis/synchronous_tumour_indicator:0|code'
            => 'at0003',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/colorectal_diagnosis/synchronous_tumour_indicator:0|terminology'
            => 'local',

        # Modified Dukes Stage
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/modified_dukes_stage:0/modified_dukes_stage|value'
            => 'Dukes Stage D',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/modified_dukes_stage:0/modified_dukes_stage|terminology'
            => 'local',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/modified_dukes_stage:0/modified_dukes_stage|code'
            => 'at0006',

    };
    if ( $self->diagnosis ) {
        $composition = { ( %$composition, %{ $self->diagnosis->compose } ) };
    }
    if ( $self->ajcc_stage ) {
        $composition = { ( %$composition, %{ $self->ajcc_stage->compose } ) };
    }

    return $composition;
}

=head1
    if ($self->ajcc_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/ajcc_stage/ajcc_stage_grouping'} = 
            'Stage IIA';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/ajcc_stage/ajcc_stage_version'} = 
            'AJCC Stage version 32';
    }
    if ($self->colorectal_diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/colorectal_diagnosis/synchronous_tumour_indicator:0|code'} = 
            'at0002';
    }
    if ($self->diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/diagnosis'} = 'Diagnosis 83';
    }
    if ($self->modified_dukes_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/modified_dukes_stage:0/modified_dukes_stage|code'} 
            = 'at0003';
    }
    if ($self->tumour_id) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/tumour_id/tumour_identifier:0'}
            = '16567b05-9857-4b4d-aade-171f806ed875';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/tumour_id/tumour_identifier:0|issuer'}
            = 'Issuer';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/tumour_id/tumour_identifier:0|type'}
            = 'Prescription';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/tumour_id/tumour_identifier:0|assigner'}
            = 'Assigner';
    }
    if ($self->clinical_evidence) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/clinical_evidence:0/base_of_diagnosis'}
            = '7 Histology of primary tumour';
    }
    if ($self->upper_gi_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/number_of_lesions'}
            = 888;
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/pancreatic_clinical_stage|code'}
            = 'at0012';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/portal_invasion|code'}
            = 'at0005';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/child-pugh_score:0/grade|code'}
            = 'at0027';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/bclc_stage:0/bclc_stage|code'}
            = 'at0007';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/upper_gi_staging/transarterial_chemoembolisation|code'}
            = 'at0017';
    }
    if ($self->integrated_tnm) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/integrated_stage_grouping'}
            = 'Integrated Stage grouping 70';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/integrated_m'}
            = 'Integrated M 74';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/integrated_n'}
            = 'Integrated N 77';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/integrated_t'}
            = 'Integrated T 5';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/integrated_tnm_edition'}
            = 'Integrated TNM Edition 55';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/integrated_tnm/grading_at_diagnosis'}
            = 'G3 Poorly differentiated';
    }
    if ($self->inrg_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/inrg_staging:0/inrg_stage|code'}
            = 'at0004';
    }
    if ($self->cancer_diagnosis) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/cancer_diagnosis/tumour_laterality|code'}
            = 'at0030';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/cancer_diagnosis/topography'}
            = 'Topography 90';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/cancer_diagnosis/morphology:0'}
            = 'Morphology 96';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/cancer_diagnosis/metastatic_site|code'}
            = 'at0018';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/cancer_diagnosis/recurrence_indicator|code'}
            = 'at0015';
    }
    if ($self->final_figo_stage) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/final_figo_stage/figo_version'}
            = 'FIGO version 63';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/final_figo_stage/figo_grade|code'}
            = 'at0003';
    }
    if ($self->event_date) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/event_date'} = '2018-07-24T14:06:41.753+01:00';
    }
    if ($self->testicular_staging) {
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/testicular_staging/extranodal_metastases|code'}
            = 'at0018';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/testicular_staging/stage_grouping_testicular|code'}
            = 'at0010';
        $composition->{'gel_cancer_diagnosis/problem_diagnosis__TEST__/testicular_staging/lung_metastases_sub-stage_grouping|code'}
            = 'at0021';
    }
=cut

=head1
=cut

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
