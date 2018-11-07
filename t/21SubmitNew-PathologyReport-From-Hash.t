use strict;
use warnings;
use Test::More;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::Composition;
note(
    "testing OpenEHR::Composition::LabResultReport 
        $OpenEHR::Composition::LabResultReport::VERSION"
);

my $collected =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
my $received =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
my $resulted =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T02:30:00');
my $authorised = 
    DateTime::Format::DateParse->parse_datetime('2017-12-01T04:14:00');

my $data = [
    {   ordercode      => 'ELL',
        ordername      => 'Electrolytes',
        order_mapping   => [
            {
                code => '3212-5',
                terminology => 'RAMLINC',
            },
        ],
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
                result_value           => '<88.9
This is the sodium comment',
                unit                   => 'mmol/l',
                range_low              => '80',
                range_high          => '90',
                testcode               => 'NA',
                testname               => 'Sodium',
                result_status          => 'Final',
                result_mapping     => [
                    {
                        code => '5195-3',
                        terminology => 'LOINC',
                    },
                    {
                        code => '35338',
                        terminology => 'GEL',
                    }
                ],
            },
            {   
                result_value           => '52.9
This is the potassium comment',
                unit                   => 'mmol/l',
                range_low              => '50',
                range_high          => '70',
                testcode               => 'K',
                testname               => 'Potassium',
                result_status          => 'Final',
                result_mapping     => [
                    {
                        code => '5196-3',
                        terminology => 'LOINC',
                    },
                    {
                        code => '35339',
                        terminology => 'GEL',
                    }
                ],
            },
            {   
                result_value           => ' 1.0%  0.9
This is the basophil comment',
                unit                   => 'x10^9/L',
                range_low              => '0.0',
                range_high          => '0.1',
                testcode               => 'BA',
                testname               => 'Basophils',
                result_status          => 'Final',
                result_mapping     => [
                    {
                        code => '5193-3',
                        terminology => 'LOINC',
                    },
                    {
                        code => '35389',
                        terminology => 'GEL',
                    }
                ],
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
    {   ordercode      => 'SFLC',
        ordername      => 'Serum Free Light Chains',
        spec_type      => 'Blood',
        collected      => $collected,
        collect_method => 'Phlebotomy',
        received       => $received,
        labnumber      => {
            id       => '17V555522',
            assigner => 'Winpath',
            issuer   => 'UCLH Pathology',
        },
        labresults => [
            {   result_value        => '15.0',
                unit => 'mg/L',
                testcode      => 'KAPA',
                testname      => 'Free Kappa Light Chains',
                result_status => 'Final',
            },
            {   result_value        => 'Positive',
                unit => 'mg/L',
                testcode      => 'LAMB',
                testname      => 'Free Lambda Light Chains',
                result_status => 'Final',
            },
        ],
        order_number => {
            id       => 'TQ00333221',
            assigner => 'TQuest',
            issuer   => 'UCLH',
        },
        report_date => $resulted,
        clinician   => {
            id       => 'AB02',
            assigner => 'Carecast',
            issuer   => 'UCLH',
        },
        location => {
            id     => 'ITU2',
            parent => 'UCLH',
        },
        test_status   => 'Final',
        clinical_info => 'Dizzy spells',
    }
];

ok( my $report = OpenEHR::Composition::LabResultReport->new(),
    'Construct a blank LabResultReport object' );
ok( $report->report_id('1112233322233'),   'report_id mutator' );
ok( $report->report_date($authorised),   'report_date mutator' );
ok( $report->patient_comment('Hello EHR'), 'comment mutator' );
for my $order ( @{$data} ) {
    ok( $report->add_labtests($order), 'Add Labtests from hash table' );
}
ok( $report->composer_name('David Ramlakhan'),
    'Add composer name to rest client'
);
is( $report->composition_format,
    'STRUCTURED', 'STRUCTURED format set by default' );

my $path_report = OpenEHR::REST::Composition->new();

note('Testing submit_new method with FLAT composition');
ok( $report->composition_format('FLAT'), 'Set FLAT composition format' );
ok( $path_report->composition($report),
    'Add composition object to rest client'
);
ok( $path_report->template_id('GEL - Generic Lab Report import.v0'),
    'Add template_id for FLAT composition' );
ok( $path_report->submit_new( $report->test_ehrid ), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

$path_report->err_msg('');
note('Testing submit_new method with STRUCTURED composition');
ok( $report->composition_format('STRUCTURED'),
    'Set STRUCTURED composition format'
);
ok( $path_report->composition($report),
    'Add composition object to rest client'
);
ok( $path_report->template_id('GEL - Generic Lab Report import.v0'),
    'Add template_id for FLAT composition' );
ok( $path_report->submit_new( $report->test_ehrid ), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

$path_report->err_msg('');
note('Testing submit_new method with RAW composition');
ok( $report->composition_format('RAW'), 'Set RAW composition format' );
ok( $path_report->composition($report),
    'Add composition object to rest client'
);
ok( $path_report->submit_new( $report->test_ehrid ), 'Submit composition' );
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
    ok( $path_report->composition($report),
        'Add composition object to rest client'
    );
    ok( $path_report->submit_new( $report->test_ehrid ),
        'Submit composition' );
    diag( $path_report->err_msg ) if $path_report->err_msg;
    ok( !$path_report->err_msg, 'No Error Message set' );
    is( $path_report->action, 'CREATE', 'Action is CREATE' );
    ok( $path_report->compositionUid, 'Composition UID set' );
    ok( $path_report->href,           'HREF set' );
    note( 'Composition can be found at: ' . $path_report->href );
}

done_testing;
