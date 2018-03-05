use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;
use JSON;

BEGIN {
    use_ok('OpenEHR::REST::Demographics');
}

diag('Testing OpenEHR::REST::Demographics '
    . $OpenEHR::REST::Demographics::VERSION );
ok( my $demog = OpenEHR::REST::Demographics->new(), "Constructor called" );
ok( my $ehrid = $demog->test_ehrid, 'Test EhrId inherited from Parent' );

my $party = {
    firstNames  => "Tweedle",
    lastNames   => "Dee",
    gender      => "MALE",
    dateOfBirth => DateTime->new(
        year   => 1960,
        month  => 11,
        day    => 10,
        hour   => 0,
        minute => 0,
        )->ymd,
    address =>
        { address => "Through the Looking-Glass, Down the Rabbit Hole" },
    partyAdditionalInfo =>
        [ { key => "hospital_number", value => "90807060", } ],
};
my $party_json = to_json($party);

SKIP: {
    skip "REST Demographics not installed yet", 1;
    ok( $demog->get_by_ehrid($ehrid), "Get by ehrid method called" );
    diag( $demog->err_msg ) if $demog->err_msg;
    is( $demog->action, "RETRIEVE", "Response action is RETRIEVE" );

    ok( my $demog = OpenEHR::REST::Demographics->new(),
        "Constructor called" );
    ok( $demog->add_party($party_json), "Add party method called" );
    diag( $demog->err_msg ) if $demog->err_msg;
    is( $demog->action, "CREATE", "Response action is RETRIEVE" );
}

done_testing;
