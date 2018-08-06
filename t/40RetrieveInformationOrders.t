use strict;
use warnings;
use Test::More;
use Data::Dumper;

use OpenEHR::REST::AQL;

ok(my $query = OpenEHR::REST::AQL->new(), "Construct AQL object");
ok($query->find_orders_by_state('planned'), "Search for planned Orders");
ok($query->find_orders_by_state('completed'), "Search for completed Orders");
ok($query->find_orders_by_state('aborted'), "Search for aborted Orders");
eval {$query->find_order_by_state('waiting')};
ok($@, 'Query fails with invalid state');
ok($query->find_orders_by_state('scheduled'), "Search for scheduled Orders");
print Dumper $query->resultset;


done_testing;
