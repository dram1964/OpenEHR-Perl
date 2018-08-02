use strict;
use warnings;
use DateTime;
use OpenEHR::REST::EHR;

my $nhs_number = $ARGV[0];
die &usage unless $nhs_number;

if ($nhs_number eq 'rand') {
    $nhs_number = &generate_random_nhs_number();
}
print "Creating an order for NHS Number: $nhs_number\n";

sub generate_random_nhs_number() {
    my $subject_id = int( rand(10000000000) );
    $subject_id .= '0000000000';
    if ( $subject_id =~ /^(\d{10,10}).*/ ) {
        $subject_id = $1;
    }
    return $subject_id;
}


my $start_date = DateTime->new(
    year    => 2011,
    month   => 1,
    day     => 1,
);

my $end_date = DateTime->new(
    year    => 2017,
    month   => 12,
    day     => 31,
);

my $timing  = DateTime->now();

my $expiry_time = DateTime->new(
    year    => 2019,
    month   => 11,
    day     => 30,
);

my $subject = {
    subject_id        => $nhs_number,
    subject_namespace => 'uk.nhs.nhs_number',
};
my $ehr = OpenEHR::REST::EHR->new($subject);

$ehr->find_or_new();
if ($ehr->action eq 'RETRIEVE') {
    print "EHR exists for this patient. EHR ID: " . $ehr->ehr_id . "\n";
}
elsif ($ehr->action eq 'CREATE') {
    print "Created an new EHR for this patient. EHR ID: " . $ehr->ehr_id . "\n";
}

sub usage() {
    my $message = << "END_USAGE";
Usage: 
$0 [ nhs_number | rand ]

You must provide an NHS Number (10 digits) or the keyword rand 
to place an order

END_USAGE

    print $message;
}
