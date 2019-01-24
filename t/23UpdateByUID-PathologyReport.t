use strict;
use warnings;

use Test::More;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::Composition;
use Data::Dumper;
use DateTime::Format::DateParse;

my $ehr = &get_new_random_subject;
$ehr->find_or_new;
my $ehr_id = $ehr->ehr_id;
print Dumper $ehr_id;
my $data   = &get_pathology_data;
my $authorised =
  DateTime::Format::DateParse->parse_datetime('2017-12-01T05:30:00');

SKIP: {
    skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1
      unless $ENV{OPENEHR_SUBMISSION};
    
    for my $format ( ( qw/FLAT STRUCTURED RAW/ ) ) {

        note("Constructing Original $format Composition");
        ok(
            my $original_composition = OpenEHR::Composition::LabResultReport->new(),
            'Construct a blank LabResultReport object'
        );
        ok( $original_composition->report_id('1112233322233'),
            'report_id mutator' );

        ok( $original_composition->report_date($authorised),
            'report_date mutator' );
        ok( $original_composition->patient_comment('Original Comment'),
            'comment mutator' );
        ok( $original_composition->add_labtests($data),
            'Add Labtests from hash table' );
        ok( $original_composition->composer_name('David Ramlakhan'),
            'Add composer name to rest client' );
        ok( $original_composition->composition_format($format),
            "Set composition format to $format" );

        note("Submitting Original Composition");
        my $insert = OpenEHR::REST::Composition->new();
        ok( $insert->template_id('GEL - Generic Lab Report import.v0'),
            "Add template to REST object" );
        ok(
            $insert->composition($original_composition),
            'Add composition object to rest client'
        );
        ok( $insert->submit_new($ehr_id), 'Submit composition' );
        diag( $insert->err_msg ) if $insert->err_msg;
        is( $insert->action, 'CREATE', 'New Composition Added' );
        my $uid = $insert->compositionUid;

        note( "Preparing $format update to composition with UID: $uid" );
        my $update_composition = $original_composition;
        is( $update_composition->composition_format,
            $format, "Composition still in $format format" );
        ok( $update_composition->patient_comment('Updated Comment'),
            'Updated Composition comment' );

        my $update = OpenEHR::REST::Composition->new();
        ok( $update->composition($update_composition),
            'Add composition to update' );
        ok( $update->template_id('GEL - Generic Lab Report import.v0'),
            'Add template_id for FLAT composition' );
        ok( $update->update_by_uid($uid), 'Updated with new composition' );
        is( $update->action, 'UPDATE', 'Submission is an Update' );
        diag( $update->err_msg ) if $update->err_msg;
        note( 'Composition update can be found at: ' . $update->href );
    }
};

done_testing;

sub get_pathology_data {

    my $collected =
      DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
    my $received =
      DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
    my $resulted =
      DateTime::Format::DateParse->parse_datetime('2017-12-01T02:30:00');

    my $data = {
        ordercode      => 'ELL',
        ordername      => 'Electrolytes',
        spec_type      => 'Blood',
        collected      => $collected,
        collect_method => 'Phlebotomy',
        received       => $received,
        labnumber      => {
            id       => '17V333322',
            assigner => 'Winpath',
            issuer   => 'UCLH Pathology',
        },
        labresults => [
            {
                result_value => '88.9
    This is the sodium comment',
                range_low     => '80',
                range_high    => '90',
                testcode      => 'NA',
                testname      => 'Sodium',
                result_status => 'Final',
                unit          => 'mmol/L',
            },
            {
                result        => '52.9 mmol/l',
                comment       => 'This is the potassium comment',
                range_low     => '50',
                range_high    => '70',
                testcode      => 'K',
                testname      => 'Potassium',
                result_status => 'Final',
                unit          => 'mmol/L',
            },
        ],
        order_number => {
            id       => 'TQ00112233',
            assigner => 'TQuest',
            issuer   => 'UCLH',
        },
        report_date => $resulted,
        clinician   => {
            id       => 'AB01',
            assigner => 'Carecast',
            issuer   => 'UCLH',
        },
        location => {
            id     => 'ITU1',
            parent => 'UCLH',
        },
        test_status   => 'Partial',
        clinical_info => 'Patient feeling unwell',
    };

    return $data;
}

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
