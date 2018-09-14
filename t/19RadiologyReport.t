use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::Composition::Elements::Radiology::RequesterOrder;

my $requester_order = OpenEHR::Composition::Elements::Radiology::RequesterOrder->new(
    id => '1232341234234',
);

ok( my $radreport = OpenEHR::Composition::RadiologyReport->new(
        report_id       => '1X999333',
        patient_comment => 'Patient feeling poorly',
        requester_order => [$requester_order],
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
