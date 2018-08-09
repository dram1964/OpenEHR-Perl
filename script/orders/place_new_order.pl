use strict;
use warnings;
use DateTime;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::InformationOrder;
use OpenEHR::REST::Composition;

# Create a ndw EHR
my $nhs_number = $ARGV[0];
die &usage unless $nhs_number;

if ($nhs_number eq 'rand') {
    $nhs_number = &generate_random_nhs_number();
}
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
else {
    print "Error: Something went wrong\n";
    print $ehr->err_msg;
}

# Create a new Order Object
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
my $request_id = int(rand(1000000000));
my $planned_order =
      OpenEHR::Composition::InformationOrder->new( 
        current_state => 'planned',
        start_date    => $start_date,
        end_date      => $end_date,
        timing        => $timing,
        expiry_time   => $expiry_time,
        request_id    => $request_id,
);
my $format = 'STRUCTURED';
$planned_order->composition_format($format);
$planned_order->compose;

# Submit Order
my $order = OpenEHR::REST::Composition->new();
$order->composition($planned_order);
unless ( $format eq 'RAW' ) {
    $order->template_id('GEL - Data request Summary.v1'),
}
$order->submit_new( $ehr->ehr_id );
if ( $order->err_msg ) {
    print "Error occurred in submission: " . $order->err_msg . "\n";
}
print "Subject ID: $nhs_number\n";
print "New Composition: " . $order->compositionUid . "\n";
print "HREF: " . $order->href . "\n";

sub generate_random_nhs_number() {
    my $subject_id = int( rand(10000000000) );
    $subject_id .= '0000000000';
    if ( $subject_id =~ /^(\d{10,10}).*/ ) {
        $subject_id = $1;
    }
    return $subject_id;
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
