use strict;
use warnings;

use Test::More;
use DateTime;
use Data::Dumper;

use OpenEHR::REST::Composition;

ok( my $path_report1 = OpenEHR::REST::Composition->new(),
    "PathologyReport Construction" );
my $test_uid = $path_report1->test_uid;

SKIP: {
    skip "Test Uid value not set", 4 unless $test_uid;

    for my $format ( ( qw/FLAT RAW STRUCTURED TDD/ ) ) {

        note("Searching for $format composition using compositionUid: $test_uid");
        ok( $path_report1->request_format($format), "Set request format to $format" );
        ok( $path_report1->find_by_uid($test_uid),
            "Query $format composition by ehrId"
        );
        SKIP: {
            skip "TDD compositions not fully implemented", 1 if ($format eq 'TDD');
            ok( !$path_report1->err_msg, 'No Error Message set' );
            is( $path_report1->template_id,
                'GEL - Generic Lab Report import.v0',
                'Composition Template ID'
            );
            is( $path_report1->lastVersion, '1',
                'Composition last version is true' );
            ok( !$path_report1->deleted, 'Composition deleted value is false' );
        };
        is( $path_report1->response_format,
            $format, "Composition returned in $format format" );
        ok( $path_report1->composition_response, 'Composition Returned' );
    }

};

done_testing();

