use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;
use JSON;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;

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
ok( $demog_new->update_or_new($ehr1->ehr_id), 'Using update_or_new for new party info' );
is( $demog_new->action, 'CREATE', 'Action is CREATE for new party info');
note( 'New Party info can be found at: ' . $demog_new->href );

my $demog_update = OpenEHR::REST::Demographics->new();
$party->{firstNames} = 'Tweedle Deedle';
ok( $demog_update->party($party), 'Add party update for existing ehr');
is( $demog_update->party->{firstNames}, 'Tweedle Deedle', 'Party updated with new value');
ok( $demog_update->update_or_new($ehr1->ehr_id), 'Using update_or_new for existing party info' );
print $demog_update->err_msg if( $demog_update->err_msg);
is( $demog_update->action, 'UPDATE', 'Action is update for existing party info');
note( 'Updated Party info can be found at: ' . $demog_update->href );

done_testing();

sub get_random_subject() {
    my $subject_id = int( rand(1000000000) );
    $subject_id .= '0000000000';
    if ( $subject_id =~ /^([\d]{10,10}).*/ ) {
        $subject_id = $1;
    }
    return $subject_id;
}
