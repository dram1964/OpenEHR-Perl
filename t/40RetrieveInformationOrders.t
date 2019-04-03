use strict;
use warnings;
use Test::More;
use Data::Dumper;

use OpenEHR::REST::AQL;

my $states = {
        #planned   => 526,
        scheduled => 529,
        #aborted   => 531,
        #complete  => 532,
};

SKIP: {
    skip 'Submission Disabled: Set $OPENEHR_SUBMISSION to run this test', 1 
        unless $ENV{OPENEHR_SUBMISSION};

    for my $state ( keys %{ $states } ) {
        ok( my $query = OpenEHR::REST::AQL->new(), "Construct AQL object" );
        ok( $query->find_orders_by_state($state), "Search for $state Orders" );
        for my $result (@{ $query->resultset } ) {
            is( $result->{current_state}, $state, "Current state is $state"); 
            is( $result->{current_state_code}, $states->{ $state }, "Current state code is " . $states->{ $state }); 
        }
    }
};

done_testing;
