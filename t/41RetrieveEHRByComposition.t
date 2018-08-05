use strict;
use warnings;
use Test::More;
use Data::Dumper;

use OpenEHR::REST::AQL;

ok(my $query = OpenEHR::REST::AQL->new(), "Construct AQL object");
ok($query->find_ehr_by_uid('4cc9bdb9-0af3-4d67-894b-d7a51c3259be::default::1'), 'Find EHR by UID');
ok(my $ehr = $query->resultset->[0], 'Assign first row of resultset to $ehr');
ok($ehr->{ehrid}, 'Retrieve ehrid from $ehr');
ok($ehr->{ptnumber}, 'Retrieve ptnumber from $ehr');
print Dumper $query->resultset;


done_testing;
