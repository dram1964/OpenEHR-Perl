use strict;
use warnings;
use Test::More;
use Data::Dumper;

use OpenEHR::REST::AQL;

SKIP: {
    skip "Works only for current version of Composition", 1;
ok( my $query = OpenEHR::REST::AQL->new(), "Construct AQL object" );
ok( $query->find_ehr_by_uid( $query->test_uid ), 'Find EHR by UID' );
ok( my $ehr = $query->resultset->[0],
    'Assign first row of resultset to $ehr'
);
ok( $ehr->{ehrid},    'Retrieve ehrid from $ehr' );
ok( $ehr->{ptnumber}, 'Retrieve ptnumber from $ehr' );
print Dumper $query->resultset;
}

done_testing;
