use strict;
use warnings;

use Test::More;
use OpenEHR::REST::AQL;
use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::PathologyReport;
use Data::Dumper;
use DateTime::Format::DateParse;

my ( $update, $uid );

my $collected =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
my $received =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
my $resulted =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');

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
        {   result        => '88.9 mmol/l',
            comment       => 'This is the sodium comment',
            ref_range     => '80-90',
            testcode      => 'NA',
            testname      => 'Sodium',
            result_status => 'Final',
        },
        {   result        => '52.9 mmol/l',
            comment       => 'This is the potassium comment',
            ref_range     => '50-70',
            testcode      => 'K',
            testname      => 'Potassium',
            result_status => 'Final',
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
    test_status   => 'Final',
    clinical_info => 'Patient feeling unwell',
};

ok( my $report = OpenEHR::Composition::LabResultReport->new(),
    'Construct a blank LabResultReport object' );
ok( $report->report_id('1112233322233'),   'report_id mutator' );
ok( $report->patient_comment('Hello EHR'), 'comment mutator' );
ok( $report->add_labtests($data),          'Add Labtests from hash table' );
ok( $report->composer_name('David Ramlakhan'),
    'Add composer name to rest client'
);

my $aql   = OpenEHR::REST::AQL->new();
my $ehrId = $aql->test_ehrid;
my $query = "SELECT c as compos FROM EHR[ehr_id/value = '$ehrId']";
$query .= " CONTAINS COMPOSITION c ORDER BY c/context/start_time DESC";
$aql->statement($query);

$aql->run_query;
diag $aql->err_msg if $aql->err_msg;
$uid = $aql->resultset->[0]->{compos}->{uid}->{value};
note( 'Preparing FLAT update to composition with UID: ' . $uid );
ok( $report->composition_format('FLAT'), 'FLAT format set' );
ok( $update = OpenEHR::REST::PathologyReport->new(),
    'Create PathologyReport object' );
ok( $update->composition($report), 'Add composition to update' );
ok( $update->update_by_uid($uid),  'Updated with new composition' );
diag( $update->err_msg ) if $update->err_msg;
note( 'Composition update can be found at: ' . $update->href );

$aql->run_query;
diag $aql->err_msg if $aql->err_msg;
$uid = $aql->resultset->[0]->{compos}->{uid}->{value};
note( 'Preparing STRUCTURED update to composition with UID: ' . $uid );
ok( $report->composition_format('STRUCTURED'), 'STRUCTURED format set' );
ok( $update = OpenEHR::REST::PathologyReport->new(),
    'Create PathologyReport object' );
ok( $update->composition($report), 'Add composition to update' );
ok( $update->update_by_uid($uid),  'Updated with new composition' );
diag( $update->err_msg ) if $update->err_msg;
note( 'Composition update can be found at: ' . $update->href );

$aql->run_query;
diag $aql->err_msg if $aql->err_msg;
$uid = $aql->resultset->[0]->{compos}->{uid}->{value};
note( 'Preparing RAW update to composition with UID: ' . $uid );
ok( $report->composition_format('RAW'), 'RAW format set' );
ok( $update = OpenEHR::REST::PathologyReport->new(),
    'Create PathologyReport object' );
ok( $update->composition($report), 'Add composition to update' );
ok( $update->update_by_uid($uid),  'Updated with new composition' );
diag( $update->err_msg ) if $update->err_msg;
note( 'Composition update can be found at: ' . $update->href );

SKIP: {
    skip "TDD updates not implemented yet", 1;
    $aql->run_query;
    diag $aql->err_msg if $aql->err_msg;
    $uid = $aql->resultset->[0]->{compos}->{uid}->{value};
    note( 'Preparing TDD update to composition with UID: ' . $uid );
    ok( $report->composition_format('TDD'), 'TDD format set' );
    ok( $update = OpenEHR::REST::PathologyReport->new(),
        'Create PathologyReport object' );
    ok( $update->composition($report), 'Add composition to update' );
    ok( $update->update_by_uid($uid),  'Updated with new composition' );
    diag( $update->err_msg ) if $update->err_msg;
    note( 'Composition update can be found at: ' . $update->href );
}

done_testing;
