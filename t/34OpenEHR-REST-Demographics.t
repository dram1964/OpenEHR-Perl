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
    skip 'No Demographics server' unless $ENV{OPENEHR_DEMOGRAPHICS};
    ok( my $demog_existing = OpenEHR::REST::Demographics->new(),
        "Constructor called" );
    ok( my $ehrid = $demog_existing->test_ehrid, 'Test EhrId Accessible' );
    ok( my $nhs_number = $demog_existing->test_subject_id,
        'Test Subject Id Accessible' );
    my $test_party = {
        firstNames  => "Test",
        lastNames   => "Test-Patient",
        gender      => "MALE",
        dateOfBirth => DateTime->new(
            year   => 1950,
            month  => 1,
            day    => 1,
            hour   => 0,
            minute => 0,
          )->ymd,
        address =>
          { address => "21 Winding Road, London, NW1 2PG" },
        partyAdditionalInfo => [
            {
                key   => "ehrId",
                value => $ehrid,
            },
            {
                key   => "uk.nhs.nhs_number",
                value => $nhs_number,
            },
        ],
    };
    ok( $demog_existing->party($test_party), "Added party to REST object");
    ok( $demog_existing->update_or_new($ehrid), "Called update_or_new for Test Patient"); 

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
        address =>
          { address => "Through the Looking-Glass, Down the Rabbit Hole" },
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
    my $demog_new  = OpenEHR::REST::Demographics->new();
    ok( $demog_new->party($party), 'Add party info for new ehr');
    ok( $demog_new->submit_new_party, 'Submit new party info');

    diag( $demog_new->err_msg ) if $demog_new->err_msg;
    is( $demog_new->action, 'CREATE', 'Response is CREATE' );
    note( 'New Party info can be found at: ' . $demog_new->href );

    note('Updating Last Names for newly created Party');
    my $demog_update = OpenEHR::REST::Demographics->new();
    $demog_update->get_by_ehrid( $ehr1->ehr_id );
    $demog_update->party->{lastNames} = "Dum";

    ok(
        $demog_update->submit_party_update,
        'Updated party info for previous ehr'
    );
    diag( $demog_update->err_msg ) if $demog_update->err_msg;
    is( $demog_update->action, 'UPDATE', 'Response is UPDATE' );
    note( 'Update Party info can be found at: ' . $demog_update->href );

    note('Searching with GET for all Party Records with Firstname Tweedle');
    my $firstname_get = OpenEHR::REST::Demographics->new();
    ok( $firstname_get->query( { firstnames => 'Tweedle' } ),
        'Add first name to query' );
    ok( $firstname_get->get_query(), 'Run GET Query' );
    diag( $firstname_get->err_msg ) if $firstname_get->err_msg;
    is( ref( $firstname_get->parties ), 'ARRAY', 'Array of Parties returned' );

    my $party_id;
    for my $party ( @{ $firstname_get->parties } ) {
        $party_id = $party->{id};
    }

    note( 'Testing delete for Party ID: ', $party_id );
    my $delete = OpenEHR::REST::Demographics->new();
    ok( $delete->delete_party($party_id), "Delete called for Party $party_id" );
    diag( $delete->err_msg ) if $delete->err_msg;
    is( $delete->action, 'DELETE', 'Action is DELETE' );


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
