use strict;
use warnings;
use Test::More;
use Data::Dumper;

use OpenEHR::REST::AQL;

SKIP: {
    skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
        unless $ENV{OPENEHR_SUBMISSION};

    ok( my $query = OpenEHR::REST::AQL->new(), "Construct AQL object" );
    SKIP: {
        skip "No test composition defined", 1 unless $ENV{OPENEHR_TEST_UID};
print Dumper $query->test_uid;
        ok( $query->find_ehr_by_uid( $query->test_uid ), 'Find EHR by UID' );
        is( scalar @{ $query->resultset }, 1, 'Only one result found');
        ok( my $ehr = $query->resultset->[0],
            'Assign first row of resultset to $ehr'
        );
        ok( $ehr->{ehrid},    'Retrieve ehrid from $ehr' );
        ok( $ehr->{ptnumber}, 'Retrieve ptnumber from $ehr' );
    };
    print Dumper $query->resultset;
};

done_testing;
