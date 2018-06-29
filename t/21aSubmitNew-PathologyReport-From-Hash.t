use strict;
use warnings;
use Test::More;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::PathologyReport;
note("testing OpenEHR::REST::PathologyReport $OpenEHR::VERSION");

my $collected =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
my $received =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
my $resulted =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');

my $data = [{
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
    },
    {
    ordercode      => 'SFLC',
    ordername      => 'Serum Free Light Chains',
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
        {   result        => '15.0 mg/L',
            comment       => '',
            ref_range     => '',
            testcode      => 'KAPA',
            testname      => 'Free Kappa Light Chains',
            result_status => 'Final',
        },
        {   result        => '20 mg/L',
            comment       => '',
            ref_range     => '',
            testcode      => 'LAMB',
            testname      => 'Free Lambda Light Chains',
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
    clinical_info => 'Patient feeling unwell', }
];

ok( my $report = OpenEHR::Composition::LabResultReport->new(),
    'Construct a blank LabResultReport object' );
ok( $report->report_id('1112233322233'),   'report_id mutator' );
ok( $report->patient_comment('Hello EHR'), 'comment mutator' );
for my $order (@{$data}) {
    ok( $report->add_labtests($order),          'Add Labtests from hash table' );
}
ok( $report->composer_name('David Ramlakhan'),
    'Add composer name to rest client' );
is( $report->composition_format,
    'STRUCTURED', 'STRUCTURED format set by default' ); 

my $path_report = OpenEHR::REST::PathologyReport->new();

note('Testing submit_new method with FLAT composition');
ok( $report->composition_format('FLAT'), 'Set FLAT composition format' );
ok( $path_report->composition( $report ), 
    'Add composition object to rest client' );
ok( $path_report->submit_new($report->test_ehrid), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

note('Testing submit_new method with STRUCTURED composition');
ok( $report->composition_format('STRUCTURED'), 'Set STRUCTURED composition format' );
ok( $path_report->composition( $report ), 
    'Add composition object to rest client' );
ok( $path_report->submit_new($report->test_ehrid), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

note('Testing submit_new method with RAW composition');
ok( $report->composition_format('RAW'), 'Set RAW composition format' );
ok( $path_report->composition( $report ), 
    'Add composition object to rest client' );
ok( $path_report->submit_new($report->test_ehrid), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

SKIP: {
    skip "TDD compositions not supported yet", 1;
note('Testing submit_new method with TDD composition');
ok( $report->composition_format('TDD'), 'Set TDD composition format' );
ok( $path_report->composition( $report ), 
    'Add composition object to rest client' );
ok( $path_report->submit_new($report->test_ehrid), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );
};

done_testing;
