use strict;
use warnings;

use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;
use JSON;

my $subjectId = int( rand(1000000000) );
$subjectId .= '0000000000';
if ( $subjectId =~ /^([\d]{10,10}).*/ ) {
    $subjectId = $1;
}
print "Subject ID: $subjectId\n";


my $ehr6 = OpenEHR::REST::EHR->new(
    {
        subject_id        => $subjectId,
        subject_namespace => 'uk.nhs.nhs_number',
        committer_name    => 'Committer Name',
    }
);
$ehr6->find_or_new;
if ( $ehr6->action eq 'CREATE' ) {
    print 'EHR can be found at ', $ehr6->href, "\n";
}
elsif ($ehr6->action eq 'RETRIEVE') {
    print "EHR already exists for this subject ($subjectId)\n";
    print 'EHR can be found at ', $ehr6->href, "\n";
}
else {
    print "Error in submission:\n";
    print $ehr6->err_msg;
}

my $party = {
    "firstNames"  => "Bruce",
    "lastNames"   => "Wayne",
    "gender"      => "MALE",
    "dateOfBirth" => "2014-03-03T15:04:24.456Z",
    "address" =>
      { "address" => "Fake Street 15, Gotham City" },
    "partyAdditionalInfo" => [
        { "key" => "ehrId",     "value" => $ehr6->ehr_id, },
        { "key" => "uk.nhs.nhs_number", "value" => "$subjectId" },
    ]
};

my $demographics = OpenEHR::REST::Demographics->new();
$demographics->party($party);
$demographics->update_or_new($ehr6->ehr_id);
if ($demographics->action eq 'CREATE') {
    print "Party information added\n";
}
else {
    print $demographics->err_msg;
}

=head1 NAME

create_new_ehr

=head2 Description

This script is useful for adding a dummy patient to the OpenEHR database. 
The generated EHR ID can be added into the OpenEHR.conf prior to running
the OpenEHR test suite

=cut
