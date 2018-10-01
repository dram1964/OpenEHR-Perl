use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;
use JSON;
use OpenEHR::REST::EHR;

BEGIN {
    use_ok('OpenEHR::REST::Demographics');
}

diag( 'Testing OpenEHR::REST::Demographics '
      . $OpenEHR::REST::Demographics::VERSION );

SKIP: {
skip 'No Demographics server' unless $ENV{DEMOG_SERVER};
ok( my $demog_existing = OpenEHR::REST::Demographics->new(),
    "Constructor called" );
ok( my $ehrid = $demog_existing->test_ehrid, 'Test EhrId Accessible' );
ok( my $nhs_number = $demog_existing->test_subject_id,
    'Test Subject Id Accessible' );
ok( $demog_existing->get_by_ehrid($ehrid), "Get by ehrid method called" );
diag( $demog_existing->err_msg ) if $demog_existing->err_msg;
is( $demog_existing->action, "RETRIEVE",
    "get_by_ehrid was RETRIEVE for existing subject" );


note('Testing demographics for probable non-existing record');
my $subject_id = &get_random_subject();

ok(
    my $ehr1 = OpenEHR::REST::EHR->new(
        {
            subject_id        => $subject_id,
            subject_namespace => 'uk.nhs.nhs_number',
            committer_name    => 'Committer Name',
        }
    ),
    'Initialise new ehr'
);
ok( $ehr1->find_or_new, 'find_or_new method called to CREATE new ehr' );
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
    address => { address => "Through the Looking-Glass, Down the Rabbit Hole" },
    partyAdditionalInfo => [
        {
            key   => "ehrId",
            value => $ehr1->ehr_id,
        },
        {
            key   => "uk.nhs.nhs_number",
            value => $subject_id,
        },
    ],
};
my $party_json = to_json($party);
my $demog_new  = OpenEHR::REST::Demographics->new();

ok( $demog_new->add_party($party_json), 'Added party info for new ehr ' );
diag( $demog_new->err_msg ) if $demog_new->err_msg;
is( $demog_new->action, 'CREATE', 'Response is CREATE' );
note( 'New Party info can be found at: ' . $demog_new->href );

note('Updating Last Names for newly created Party');
my $demog_update = OpenEHR::REST::Demographics->new();
$demog_update->get_by_ehrid( $ehr1->ehr_id );
$demog_update->party->{lastNames} = "Dum";

$party_json = to_json( $demog_update->party );
ok(
    $demog_update->update_party($party_json),
    'Updated party info for previous ehr'
);
diag( $demog_update->err_msg ) if $demog_update->err_msg;
is( $demog_update->action, 'UPDATE', 'Response is UPDATE' );
note( 'Update Party info can be found at: ' . $demog_update->href );

note ('Searching for all Party Records with Surname Tweedle');

my $surname_search = OpenEHR::REST::Demographics->new();

ok( $surname_search->query( { firstNames => 'Tweedle' }), 'Add last name to query');
ok( $surname_search->run_query(), 'Run Query');
diag ( $surname_search->err_msg) if $surname_search->err_msg;
is( ref($surname_search->parties), 'ARRAY', 'Array of Parties returned');
for my $party ( @{ $surname_search->parties } ) {
    print $party->{id}, "\n";
}


}

done_testing;

sub get_random_subject() {
    my $subject_id = int( rand(1000000000) );
    $subject_id .= '0000000000';
    if ( $subject_id =~ /^([\d]{10,10}).*/ ) {
        $subject_id = $1;
    }
    return $subject_id;
}
