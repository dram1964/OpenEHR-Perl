use strict;
use warnings;

use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;
use Genomes_100K::Model;
use Data::Dumper;
use JSON;

my $patient_number = $ARGV[0];

my $schema = Genomes_100K::Model->connect('CRIUGenomesTest');
my $pathology_demogs_rs = $schema->resultset('PathologyResult')->search(
    {
        patient_number => $patient_number,
    },
    { columns => [qw/patient_name dob gender nhs_number/] },
);

my ($first_name, $last_name, $gender, $dob) = ('', '', '', '');

if (my $demogs = $pathology_demogs_rs->first) {
    my $patient_name = $demogs->patient_name;
    ($last_name,$first_name) = split(",", $patient_name);
    $gender = $demogs->gender;
    if ($gender eq 'M') {
        $gender = 'MALE';
    }
    elsif ($gender eq 'F') {
        $gender = 'FEMALE';
    }
    else {
        $gender = 'UNKNOWN';
    }
    $dob = $demogs->dob;
    print Dumper $dob;
}
else {
    die "Patient $patient_number not found\n";
}
print join(":", $first_name, $last_name, $gender, $dob), "\n";

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
    "firstNames"  => $first_name, #"Bruce",
    "lastNames"   => $last_name, #"Wayne",
    "gender"      => $gender, #"MALE",
    "dateOfBirth" => $dob, #"2014-03-03T15:04:24.456Z",
    "partyAdditionalInfo" => [
        { "key" => "ehrId",     "value" => $ehr6->ehr_id, },
        { "key" => "uk.nhs.nhs_number", "value" => "$subjectId" },
    ]
};
my $party_json = to_json($party);

my $demographics = OpenEHR::REST::Demographics->new();
$demographics->add_party($party_json);
if ($demographics->action eq 'CREATE') {
    print "Party information added\n";
}
else {
    print $demographics->err_msg;
}
