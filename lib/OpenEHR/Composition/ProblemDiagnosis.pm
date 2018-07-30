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
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::AJCC_Stage]',
);

=head2 colorectal_diagnosis($colorectal_diagnosis_object)

Used to get or set the Colorectal Diagnosis item for the Problem Diagnosis

=cut 

has colorectal_diagnosis => (
    is => 'rw',
    isa =>
        'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::ColorectalDiagnosis]',
);

=head2 diagnosis($diagnosis_object)

Used to get or set the diagnosis item for the Problem Diagnosis

=cut 

has diagnosis => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::Diagnosis]',
);

=head2 modified_dukes($modified_dukes_object)

Used to get or set the modified_dukes item for the Problem Diagnosis

=cut 

has modified_dukes => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::ModifiedDukes]',
);

=head2 tumour_id($tumour_id_object)

Used to get or set the tumour_id item for the Problem Diagnosis

=cut 

has tumour_id => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::TumourID]',
);

=head2 clinical_evidence($clinical_evidence_object)

Used to get or set the clinical_evidence item for the Problem Diagnosis

=cut 

has clinical_evidence => (
    is => 'rw',
    isa =>
        'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::ClinicalEvidence]',
);

=head2 upper_gi_staging($upper_gi_object)

Used to get or set the upper_gi item for the Problem Diagnosis

=cut 

has upper_gi_staging => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::UpperGI]',
);

=head2 integrated_tnm($upper_gi_object)

Used to get or set the integrated tnm item for the Problem Diagnosis

=cut 

has integrated_tnm => (
    is  => 'rw',
    isa => 'ArrayRef[OpenEHR::Composition::ProblemDiagnosis::Integrated_TNM]',
);

=head2 inrg_staging($upper_gi_object)

Used to get or set the inrg staging item for the Problem Diagnosis

=cut 

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
        'cancer_diagnosis' => [
            {   'morphology'           => ['Morphology 86'],
                'tumour_laterality'    => [ { '|code' => 'at0029' } ],
                'metastatic_site'      => [ { '|code' => 'at0023' } ],
                'topography'           => ['Topography 90'],
                'recurrence_indicator' => [ { '|code' => 'at0014' } ]
            }
        ],
    };

=head1 comment
=cut

    if ( $self->inrg_staging ) {
        for my $inrg_staging ( @{ $self->inrg_staging } ) {
            push @{ $composition->{inrg_staging} },
                $inrg_staging->compose;
        }
    }
    if ( $self->upper_gi_staging ) {
        for my $upper_gi_staging ( @{ $self->upper_gi_staging } ) {
            push @{ $composition->{upper_gi_staging} },
                $upper_gi_staging->compose;
        }
    }
    if ( $self->clinical_evidence ) {
        for my $clinical_evidence ( @{ $self->clinical_evidence } ) {
            push @{ $composition->{clinical_evidence} },
                $clinical_evidence->compose;
        }
    }
    if ( $self->tumour_id ) {
        for my $tumour_id ( @{ $self->tumour_id } ) {
            push @{ $composition->{tumour_id} }, $tumour_id->compose;
        }
    }
    if ( $self->modified_dukes ) {
        for my $modified_dukes ( @{ $self->modified_dukes } ) {
            push @{ $composition->{modified_dukes_stage} },
                $modified_dukes->compose;
        }
    }
    if ( $self->colorectal_diagnosis ) {
        for my $colorectal_diagnosis ( @{ $self->colorectal_diagnosis } ) {
            push @{ $composition->{colorectal_diagnosis} },
                $colorectal_diagnosis->compose;
        }
    }
    if ( $self->diagnosis ) {
        for my $diagnosis ( @{ $self->diagnosis } ) {
            push @{ $composition->{diagnosis} }, $diagnosis->compose;
        }
    }
    if ( $self->ajcc_stage ) {
        for my $ajcc_stage ( @{ $self->ajcc_stage } ) {
            push @{ $composition->{ajcc_stage} }, $ajcc_stage->compose;
        }
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

=head1 comment
=cut

    if ( $self->inrg_staging ) {
        for my $inrg_staging ( @{ $self->inrg_staging } ) {
            push @{ $composition->{data}->{items} },
                $inrg_staging->compose;
        }
    }
    if ( $self->integrated_tnm ) {
        for my $integrated_tnm ( @{ $self->integrated_tnm } ) {
            push @{ $composition->{data}->{items} },
                $integrated_tnm->compose;
        }
    }
    if ( $self->upper_gi_staging ) {
        for my $upper_gi_staging ( @{ $self->upper_gi_staging } ) {
            push @{ $composition->{data}->{items} },
                $upper_gi_staging->compose;
        }
    }
    if ( $self->clinical_evidence ) {
        for my $clinical_evidence ( @{ $self->clinical_evidence } ) {
            push @{ $composition->{data}->{items} },
                $clinical_evidence->compose;
        }
    }
    if ( $self->tumour_id ) {
        for my $tumour_id ( @{ $self->tumour_id } ) {
            push @{ $composition->{data}->{items} }, $tumour_id->compose;
        }
    }
    if ( $self->modified_dukes ) {
        for my $modified_dukes ( @{ $self->modified_dukes } ) {
            push @{ $composition->{data}->{items} }, $modified_dukes->compose;
        }
    }
    if ( $self->colorectal_diagnosis ) {
        for my $colorectal_diagnosis ( @{ $self->colorectal_diagnosis } ) {
            push @{ $composition->{data}->{items} },
                $colorectal_diagnosis->compose;
        }
    }
    if ( $self->diagnosis ) {
        for my $diagnosis ( @{ $self->diagnosis } ) {
            push @{ $composition->{data}->{items} }, $diagnosis->compose;
        }
    }
    if ( $self->ajcc_stage ) {
        for my $ajcc ( @{ $self->ajcc_stage } ) {
            push @{ $composition->{data}->{items} }, $ajcc->compose;
        }
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

        # Final Figo Stage
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|code'
            => 'at0008',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|value'
            => 'ib',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_version'
            => 'FIGO version 99',
        'gel_cancer_diagnosis/problem_diagnosis:__TEST__/final_figo_stage/figo_grade|terminology'
            => 'local',

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

    };

=head1 comment 
=cut

    if ( $self->inrg_staging ) {
        my $inrg_staging_index = '0';
        my $inrg_staging_comp;
        for my $inrg_staging ( @{ $self->inrg_staging } ) {
            my $composition_fragment = $inrg_staging->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$inrg_staging_index/;
                $inrg_staging_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $inrg_staging_index++;
            $composition = { ( %$composition, %{$inrg_staging_comp} ) };
        }
    }
    if ( $self->upper_gi_staging ) {
        my $upper_gi_staging_index = '0';
        my $upper_gi_staging_comp;
        for my $upper_gi_staging ( @{ $self->upper_gi_staging } ) {
            my $composition_fragment = $upper_gi_staging->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$upper_gi_staging_index/;
                $upper_gi_staging_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $upper_gi_staging_index++;
            $composition = { ( %$composition, %{$upper_gi_staging_comp} ) };
        }
    }
    if ( $self->clinical_evidence ) {
        my $clinical_evidence_index = '0';
        my $clinical_evidence_comp;
        for my $clinical_evidence ( @{ $self->clinical_evidence } ) {
            my $composition_fragment = $clinical_evidence->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$clinical_evidence_index/;
                $clinical_evidence_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $clinical_evidence_index++;
            $composition = { ( %$composition, %{$clinical_evidence_comp} ) };
        }
    }
    if ( $self->tumour_id ) {
        my $tumour_id_index = '0';
        my $tumour_id_comp;
        for my $tumour_id ( @{ $self->tumour_id } ) {
            my $composition_fragment = $tumour_id->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$tumour_id_index/;
                $tumour_id_comp->{$new_key} = $composition_fragment->{$key};
            }
            $tumour_id_index++;
            $composition = { ( %$composition, %{$tumour_id_comp} ) };
        }
    }
    if ( $self->modified_dukes ) {
        my $modified_dukes_index = '0';
        my $modified_dukes_comp;
        for my $modified_dukes ( @{ $self->modified_dukes } ) {
            my $composition_fragment = $modified_dukes->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$modified_dukes_index/;
                $modified_dukes_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $modified_dukes_index++;
            $composition = { ( %$composition, %{$modified_dukes_comp} ) };
        }
    }
    if ( $self->colorectal_diagnosis ) {
        my $colorectal_diagnosis_index = '0';
        my $colorectal_diagnosis_comp;
        for my $colorectal_diagnosis ( @{ $self->colorectal_diagnosis } ) {
            my $composition_fragment = $colorectal_diagnosis->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$colorectal_diagnosis_index/;
                $colorectal_diagnosis_comp->{$new_key} =
                    $composition_fragment->{$key};
            }
            $colorectal_diagnosis_index++;
            $composition =
                { ( %$composition, %{$colorectal_diagnosis_comp} ) };
        }
    }
    if ( $self->diagnosis ) {
        my $diagnosis_index = '0';
        my $diagnosis_comp;
        for my $diagnosis ( @{ $self->diagnosis } ) {
            my $composition_fragment = $diagnosis->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__DIAG__/$diagnosis_index/;
                $diagnosis_comp->{$new_key} = $composition_fragment->{$key};
            }
            $diagnosis_index++;
            $composition = { ( %$composition, %{$diagnosis_comp} ) };
        }
    }
    if ( $self->ajcc_stage ) {
        my $ajcc_index = '0';
        my $ajcc_comp;
        for my $ajcc ( @{ $self->ajcc_stage } ) {
            my $composition_fragment = $ajcc->compose;
            for my $key ( keys %{$composition_fragment} ) {
                my $new_key = $key;
                $new_key =~ s/__AJCC__/$ajcc_index/;
                $ajcc_comp->{$new_key} = $composition_fragment->{$key};
            }
            $ajcc_index++;
            $composition = { ( %$composition, %{$ajcc_comp} ) };
        }
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
