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

    note("Searching for RAW composition using compositionUid: $test_uid");
    ok( $path_report1->request_format('RAW'), 'Set request format to RAW' );
    ok( $path_report1->find_by_uid($test_uid),
        'Query RAW composition by ehrId'
    );
    ok( !$path_report1->err_msg, 'No Error Message set' );
    is( $path_report1->response_format,
        'RAW', 'Composition returned in RAW format' );
    is( $path_report1->template_id,
        'GEL - Generic Lab Report import.v0',
        'Composition Template ID'
    );
    ok( $path_report1->composition_response, 'Composition Returned' );

    #print Dumper $path_report1->composition_response;
    ok( !$path_report1->deleted, 'Composition deleted value is false' );
    is( $path_report1->lastVersion, '1',
        'Composition last version is false' );

    note("Searching for FLAT composition using compositionUid: $test_uid");
    ok( my $path_report2 = OpenEHR::REST::Composition->new(),
        "PathologyReport Construction" );
    ok( $path_report2->request_format('FLAT'), "Request format set to FLAT" );
    ok( $path_report2->find_by_uid($test_uid),
        "Query FLAT composition by ehrId"
    );
    ok( !$path_report2->err_msg, "No Error Message set" );
    is( $path_report2->response_format,
        'FLAT', "Composition returned in FLAT format" );
    is( $path_report2->template_id,
        'GEL - Generic Lab Report import.v0',
        "Composition Template ID"
    );
    ok( $path_report2->composition_response,
        "Composition response Returned" );

    #print Dumper $path_report2->composition_response;
    ok( !$path_report2->deleted, "Composition deleted value is false" );
    is( $path_report2->lastVersion, '1',
        "Composition last version is false" );

    note(
        "Searching for STRUCTURED composition using compositionUid: $test_uid"
    );
    ok( my $path_report3 = OpenEHR::REST::Composition->new(),
        "PathologyReport Construction" );
    ok( $path_report3->request_format('STRUCTURED'),
        "Request format set to STRUCTURED"
    );
    ok( $path_report3->find_by_uid($test_uid),
        "Query STRUCTURED composition by ehrId"
    );
    ok( !$path_report3->err_msg, "No Error Message set" );
    is( $path_report3->response_format,
        'STRUCTURED', "Composition returned in STRUCTURED format" );
    is( $path_report3->template_id,
        'GEL - Generic Lab Report import.v0',
        "Composition Template ID"
    );
    ok( $path_report3->composition_response, "Composition Returned" );

    #print Dumper $path_report3->composition_response;
    ok( !$path_report3->deleted, "Composition deleted value is false" );
    is( $path_report3->lastVersion, '1',
        "Composition last version is false" );

    note("Searching for TDD composition using compositionUid: $test_uid");
    ok( my $path_report4 = OpenEHR::REST::Composition->new(),
        "PathologyReport Construction" );
    ok( $path_report4->request_format('TDD'), 'Request format set to TDD' );
    ok( $path_report4->find_by_uid( $test_uid, 'TDD' ),
        "Query TDD composition by ehrId" );
    is( $path_report4->err_msg,
        'XML responses from TDD not handled yet',
        "Error Message set"
    );
    is( $path_report4->response_format,
        'TDD', "Composition returned in TDD format" );
    is( $path_report4->template_id,
        'XML responses from TDD not handled yet',
        "Composition Template ID"
    );
    ok( $path_report4->composition_response, "Composition Returned" );

    #print Dumper $path_report4->composition_response;
    ok( !$path_report4->deleted, "Composition deleted value is false" );
    is( $path_report4->lastVersion, '0',
        "Composition last version is false" );
}

done_testing();

