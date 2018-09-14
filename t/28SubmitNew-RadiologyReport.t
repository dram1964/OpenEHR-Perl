use strict;
use warnings;
use Test::More;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::Composition::Elements::Radiology::RequesterOrder;
use OpenEHR::Composition::Elements::Radiology::ReportReference;
use OpenEHR::REST::Composition;
note(
    "testing OpenEHR::Composition::RadiologyReport 
        $OpenEHR::Composition::RadiologyReport::VERSION"
);

my $collected =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:10:00');
my $received =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');
my $resulted =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');

my $requester_order = OpenEHR::Composition::Elements::Radiology::RequesterOrder->new(
    id => '2353332xh',
);
my $report_reference = OpenEHR::Composition::Elements::Radiology::ReportReference->new(
    id => '99bb88cc77',
);


ok( my $report = OpenEHR::Composition::RadiologyReport->new(),
    'Construct a blank RadiologyReport object' );
ok( $report->report_id('1112233322233'),   'report_id mutator' );
ok( $report->patient_comment('Hello EHR'), 'comment mutator' );
ok( $report->requester_order([$requester_order]), 'Add requester order ArrayRef');
#ok( $report->report_reference([$report_reference]), 'Add report reference ArrayRef');
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
ok( $path_report->template_id('GEL Generic radiology report import.v0'),
    'Add template_id for FLAT composition' );
ok( $path_report->submit_new( $report->test_ehrid ), 'Submit composition' );
diag( $path_report->err_msg ) if $path_report->err_msg;
ok( !$path_report->err_msg, 'No Error Message set' );
is( $path_report->action, 'CREATE', 'Action is CREATE' );
ok( $path_report->compositionUid, 'Composition UID set' );
ok( $path_report->href,           'HREF set' );
note( 'Composition can be found at: ' . $path_report->href );

done_testing;
