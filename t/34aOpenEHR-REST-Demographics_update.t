use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;
use JSON;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;

SKIP: {
    skip "No Demographics Server", 1 unless $ENV{DEMOGRAPHICS};

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
    ok( $demog_new->party($party), 'Added party info for new ehr ' );
    ok( $demog_new->submit_new_party, 'Submitted new party data');
    note( 'New Party info can be found at: ' . $demog_new->href );

    my $demog_retrieve = OpenEHR::REST::Demographics->new();
    ok( $demog_retrieve->get_by_ehrid( $ehr1->ehr_id ), 'Retrieve existing demographics from EHRID');
    is( $demog_retrieve->action, 'RETRIEVE', 'Action set to retrieve when party found');
    is( ref($demog_retrieve->party), 'HASH', 'Party set to hashref');
    my $party_info = $demog_retrieve->party;

    $party_info->{gender} = 'FEMALE';
    $party_info->{firstNames} = 'Tweedle Deedle';
    $party_info->{lastNames} = 'Dum';
    $party_info->{dateOfBirth} = '1952-12-12';
    my $demog_update_multi = OpenEHR::REST::Demographics->new();
    ok( $demog_update_multi->party($party_info), 'Set party for update');
    ok( $demog_update_multi->submit_party_update, 'Updated multiple attributes');
    is( $demog_update_multi->action, 'UPDATE', 'Action set to update when party updated');
    note( 'Update info can be found at: ' . $demog_update_multi->href );
};

done_testing();

sub get_random_subject() {
    my $subject_id = int( rand(1000000000) );
    $subject_id .= '0000000000';
    if ( $subject_id =~ /^([\d]{10,10}).*/ ) {
        $subject_id = $1;
    }
    return $subject_id;
}
