use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::RadiologyReport;

ok( my $radreport = OpenEHR::Composition::RadiologyReport->new(
        report_id       => '1X999333',
        patient_comment => 'Patient feeling poorly',
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
