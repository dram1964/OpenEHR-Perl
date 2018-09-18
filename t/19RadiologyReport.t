use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::RadiologyReport;

my $requester_order = OpenEHR::Composition::Elements::ImagingExam::RequesterOrder->new(
    id => '1232341234234',
);
my $report_reference = OpenEHR::Composition::Elements::ImagingExam::ReportReference->new(
    id => '99887766',
);
my $reciever_order = OpenEHR::Composition::Elements::ImagingExam::ReceiverOrder->new(
    id => 'rec-1235',
);


ok( my $radreport = OpenEHR::Composition::RadiologyReport->new(
        report_id       => '1X999333',
        patient_comment => 'Patient feeling poorly',
        requester_order => [$requester_order],
        report_reference => [$report_reference],
    ),
    'Radiology Report Constructor'
);

for my $format ( (qw/FLAT/) ) {
    ok($radreport->composition_format($format), "Set format to $format");
    ok(my $composition = $radreport->compose, "Called compose for $format format");
    is(ref($composition), "HASH", "Composition is a HASHREF");
    ok(my $json = $radreport->print_json, "Called print_json for $format format");
    print Dumper $composition;
}


done_testing;
