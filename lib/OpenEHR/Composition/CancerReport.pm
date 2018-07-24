package OpenEHR::Composition::CancerReport;

use warnings;
use strict;
use Carp;
use Moose;
use DateTime;
use Data::Dumper;
extends 'OpenEHR::Composition';

use version; our $VERSION = qv('0.0.2');

sub compose {
    my $self = shift;
    $self->composition_format('RAW')
      if ( $self->composition_format eq 'TDD' );

    my $formatter = 'compose_' . lc( $self->composition_format );
    $self->$formatter();
}

sub compose_structured {
    my $self = shift;
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

    return $composition;
}

sub compose_raw {
    my $self = shift;
    my $context = [
                {
                    'participant' => [
                        {
                            'participant_identifier' => [
                                {
                                    '|id' =>
                                      'bd47cba4-695f-48cb-8451-1e83ef5a4ea2',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ],
                            'study_identifier' => [
                                {
                                    '|id' =>
                                      '7427eb9d-a03a-4f41-ad8b-391919c1d561',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ]
                        }
                    ],
                    'report_id' => ['Report ID 81']
                }
            ];
    my $problem_diagnosis = [
                {
                    'ajcc_stage' => [
                        {
                            'ajcc_stage_version'  => ['AJCC Stage version 77'],
                            'ajcc_stage_grouping' => ['Stage IIB']
                        }
                    ],
                    'colorectal_diagnosis' => [
                        {
                            'synchronous_tumour_indicator' => [
                                {
                                    '|code' => 'at0008'
                                }
                            ]
                        }
                    ],
                    'diagnosis'            => ['Diagnosis 9'],
                    'modified_dukes_stage' => [
                        {
                            'modified_dukes_stage' => [
                                {
                                    '|code' => 'at0003'
                                }
                            ]
                        }
                    ],
                    'tumour_id' => [
                        {
                            'tumour_identifier' => [
                                {
                                    '|id' =>
                                      'a03fcd1f-1ae9-4e99-8799-5e7d0c0b7edd',
                                    '|assigner' => 'Assigner',
                                    '|issuer'   => 'Issuer',
                                    '|type'     => 'Prescription'
                                }
                            ]
                        }
                    ],
                    'clinical_evidence' => [
                        {
                            'base_of_diagnosis' => [
'2 Clinical investigation including all diagnostic techniques'
                            ]
                        }
                    ],
                    'upper_gi_staging' => [
                        {
                            'transarterial_chemoembolisation' => [
                                {
                                    '|code' => 'at0017'
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
                                            '|code' => 'at0029'
                                        }
                                    ]
                                }
                            ],
                            'pancreatic_clinical_stage' => [
                                {
                                    '|code' => 'at0011'
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
                            'number_of_lesions' => [925]
                        }
                    ],
                    'integrated_tnm' => [
                        {
                            'integrated_stage_grouping' =>
                              ['Integrated Stage grouping 38'],
                            'integrated_tnm_edition' =>
                              ['Integrated TNM Edition 34'],
                            'integrated_n' => ['Integrated N 82'],
                            'grading_at_diagnosis' =>
                              ['G3 Poorly differentiated'],
                            'integrated_m' => ['Integrated M 52'],
                            'integrated_t' => ['Integrated T 57']
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
                                    '|code' => 'at0029'
                                }
                            ],
                            'metastatic_site' => [
                                {
                                    '|code' => 'at0027'
                                }
                            ],
                            'topography' => ['Topography 76'],
                            'morphology' => ['Morphology 98']
                        }
                    ],
                    'final_figo_stage' => [
                        {
                            'figo_grade' => [
                                {
                                    '|code' => 'at0022'
                                }
                            ],
                            'figo_version' => ['FIGO version 90']
                        }
                    ],
                    'event_date'         => ['2018-07-24T11:55:26.550+01:00'],
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
            ];
    my $composition = {
        'gel_cancer_diagnosis' => {
            'context' => $context,
            'problem_diagnosis' => $problem_diagnosis,
        },
        'ctx/language'                  => $self->language_code,
        'ctx/territory'                 => $self->territory_code,
        'ctx/composer_name'             => $self->composer_name,
        'ctx/time'                      => DateTime->now->datetime,
        'ctx/id_namespace'              => $self->id_namespace,
        'ctx/id_scheme'                 => $self->id_scheme,
        'ctx/health_care_facility|name' => $self->facility_name,
        'ctx/health_care_facility|id'   => $self->facility_id,
    };

    return $composition;
}
#       'ctx/participation_id'          => '199',
#       'ctx/participation_function'    => 'requester',
#       'ctx/participation_mode'        => 'face-to-face communication',
#       'ctx/participation_name'        => 'Dr. Marcus Johnson',
#       'ctx/participation_id:1'        => '198',
#       'ctx/participation_function:1'  => 'performer',
#       'ctx/participation_name:1'      => 'Lara Markham',

sub compose_flat {
    my $self        = shift;
    my $composition = {
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/number_of_lesions'
          => 888,
        'ctx/id_scheme'     => 'HOSPITAL-NS',
        'ctx/composer_name' => 'Silvia Blake',
'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/extranodal_metastases|code'
          => 'at0018',
        'gel_cancer_diagnosis/problem_diagnosis:0/final_figo_stage/figo_version'
          => 'FIGO version 63',
'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/tumour_laterality|code'
          => 'at0030',
        'gel_cancer_diagnosis/context/participant/study_identifier' =>
          'c5385c3d-6d38-4092-be7e-e29da08aabaf',
'gel_cancer_diagnosis/problem_diagnosis:0/colorectal_diagnosis/synchronous_tumour_indicator:0|code'
          => 'at0002',
        'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0'
          => '16567b05-9857-4b4d-aade-171f806ed875',
'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/metastatic_site|code'
          => 'at0018',
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/bclc_stage:0/bclc_stage|code'
          => 'at0007',
'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|issuer'
          => 'Issuer',
        'gel_cancer_diagnosis/context/report_id' => 'Report ID 17',
        'ctx/id_namespace'                       => 'HOSPITAL-NS',
        'gel_cancer_diagnosis/context/participant/participant_identifier|type'
          => 'Prescription',
        'gel_cancer_diagnosis/context/participant/participant_identifier|issuer'
          => 'Issuer',
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/transarterial_chemoembolisation|code'
          => 'at0017',
'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/recurrence_indicator|code'
          => 'at0015',
'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|type'
          => 'Prescription',
        'ctx/health_care_facility|id' => '9091',
        'ctx/participation_id'        => '199',
        'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/morphology:0'
          => 'Morphology 96',
'gel_cancer_diagnosis/problem_diagnosis:0/clinical_evidence:0/base_of_diagnosis'
          => '7 Histology of primary tumour',
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/child-pugh_score:0/grade|code'
          => 'at0027',
'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_stage_grouping'
          => 'Integrated Stage grouping 70',
        'gel_cancer_diagnosis/problem_diagnosis:0/diagnosis' => 'Diagnosis 83',
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/pancreatic_clinical_stage|code'
          => 'at0012',
'gel_cancer_diagnosis/problem_diagnosis:0/upper_gi_staging/portal_invasion|code'
          => 'at0005',
        'ctx/participation_function' => 'requester',
'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_tnm_edition'
          => 'Integrated TNM Edition 55',
        'ctx/participation_id:1'        => '198',
        'ctx/participation_name:1'      => 'Lara Markham',
        'ctx/health_care_facility|name' => 'Hospital',
'gel_cancer_diagnosis/context/participant/participant_identifier|assigner'
          => 'Assigner',
        'gel_cancer_diagnosis/context/participant/participant_identifier' =>
          '61b07166-fb83-4e42-8670-e07623a70285',
        'gel_cancer_diagnosis/context/participant/study_identifier|issuer' =>
          'Issuer',
'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/grading_at_diagnosis'
          => 'G3 Poorly differentiated',
        'ctx/language' => 'en',
        'gel_cancer_diagnosis/context/participant/study_identifier|type' =>
          'Prescription',
'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/lung_metastases_sub-stage_grouping|code'
          => 'at0021',
'gel_cancer_diagnosis/problem_diagnosis:0/inrg_staging:0/inrg_stage|code'
          => 'at0004',
'gel_cancer_diagnosis/problem_diagnosis:0/ajcc_stage/ajcc_stage_grouping'
          => 'Stage IIA',
        'ctx/participation_function:1' => 'performer',
        'ctx/participation_name'       => 'Dr. Marcus Johnson',
        'ctx/territory'                => 'US',
'gel_cancer_diagnosis/problem_diagnosis:0/final_figo_stage/figo_grade|code'
          => 'at0003',
        'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_m'
          => 'Integrated M 74',
        'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_n'
          => 'Integrated N 77',
        'ctx/participation_mode' => 'face-to-face communication',
        'gel_cancer_diagnosis/context/participant/study_identifier|assigner' =>
          'Assigner',
        'gel_cancer_diagnosis/problem_diagnosis:0/cancer_diagnosis/topography'
          => 'Topography 90',
'gel_cancer_diagnosis/problem_diagnosis:0/testicular_staging/stage_grouping_testicular|code'
          => 'at0010',
        'gel_cancer_diagnosis/problem_diagnosis:0/integrated_tnm/integrated_t'
          => 'Integrated T 5',
'gel_cancer_diagnosis/problem_diagnosis:0/tumour_id/tumour_identifier:0|assigner'
          => 'Assigner',
'gel_cancer_diagnosis/problem_diagnosis:0/modified_dukes_stage:0/modified_dukes_stage|code'
          => 'at0003',
        'gel_cancer_diagnosis/problem_diagnosis:0/event_date' =>
          '2018-07-24T14:06:41.753+01:00',
        'gel_cancer_diagnosis/problem_diagnosis:0/ajcc_stage/ajcc_stage_version'
          => 'AJCC Stage version 32'
    };

    return $composition;
}

no Moose;

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

OpenEHR::Composition::InformationOrder - Information Order composition element


=head1 VERSION

This document describes OpenEHR::Composition::InformationOrder version 0.0.2


=head1 SYNOPSIS

    use OpenEHR::Composition::CancerReport;
    my $planned_order = OpenEHR::Composition::CancerReport->new(
    );
    my $info_order_hash = $planned_order->compose;


  
=head1 DESCRIPTION

Used to create a hashref element of an cancer report 
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

OpenEHR::Composition::CancerReport requires no configuration files or 
environment variables.


=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

When using the RAW format compositions, uids are not automatically assigned to 
instructions or actions

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
