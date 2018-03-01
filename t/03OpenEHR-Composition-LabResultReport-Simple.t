use strict;
use warnings;
use Test::More;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::PathologyReport;

my $collected = DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
my $received = DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
my $resulted = DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');


my $data = {
    ordercode        => 'ELL',
    ordername        => 'Electrolytes',
    spec_type       => 'Blood',
    collected       => $collected,
    collect_method  => 'Phlebotomy',
    received        => $received,
    labnumber       => {
        id  => '17V333322', 
        assigner => 'Winpath',
        issuer => 'UCLH Pathology', 
    },
    labresults      => [
        {
            result          => '88.9 mmol/l',
            comment         => 'This is the sodium comment',
            ref_range       => '80-90',
            testcode             => 'NA',
            testname        => 'Sodium',
            result_status   => 'Final',
        },
        {
            result          => '52.9 mmol/l',
            comment         => 'This is the potassium comment',
            ref_range       => '50-70',
            testcode             => 'K',
            testname        => 'Potassium',
            result_status   => 'Final',
        },
    ],
    order_number    => { 
        id          => 'TQ00112233', 
        assigner    => 'TQuest',
        issuer      => 'UCLH', 
    },
    report_date     => $resulted,
    clinician       => {
        id          => 'AB01',
        assigner    => 'Carecast',
        issuer      => 'UCLH',
    },
    location        => {
        id              => 'ITU1',
        parent          => 'UCLH',
    },
    test_status     => 'Final',
    clinical_info   => 'Patient feeling unwell',
};

ok(my $report = OpenEHR::Composition::LabResultReport->new(),
    'Construct a blank LabResultReport object');
ok($report->report_id('1112233322233'), 'report_id mutator');
ok($report->patient_comment('Hello EHR'), 'comment mutator');
ok($report->add_labtests($data), 
    'Add Labtests from hash table');

ok($report->composition_format('FLAT'), 'Set FLAT composition format');
ok(my $flat = $report->compose(), 'Request composition');

my $path_report = OpenEHR::REST::PathologyReport->new();
my $ehrid = $report->test_ehrid;

ok($path_report->request_format($report->composition_format), 'Set report format for rest client');
is($path_report->request_format, 'FLAT', 'Format set to FLAT');
ok($path_report->composition(to_json($flat)), 'Add composition to rest client');
ok($path_report->composer_name('David Ramlakhan'), 'Add composer name to rest client');
ok($path_report->submit_new($ehrid), 'Submit composition');
diag($path_report->err_msg) if $path_report->err_msg;
ok(!$path_report->err_msg, 'No Error Message set');
is($path_report->action, 'CREATE', 'Action is CREATE');
ok($path_report->compositionUid, 'Composition UID set');
ok($path_report->href, 'HREF set');
note("Composition can be found at: " . $path_report->href);



done_testing;
