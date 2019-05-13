use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use OpenEHR::REST::AQL;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use Genomes_100K::Schema;
use Genomes_100K::Model;

my ($service_type, $help);

GetOptions (
    "type=s" => \$service_type,
    "help" => \$help,
    )
or &usage("Error in command line arguments\n");

die &usage unless $service_type;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $update_rs = &find_orders_with_no_expiry();
if ( $update_rs->count > 0) {
    while ( my $update = $update_rs->next ) {
        if ( my $expiry_date = &find_expiry_date_by_uid( $update->composition_uid ) ) {;
            my $result = &update_information_order_expiry_date($update->composition_uid, $expiry_date);
            die unless $result;
        }
        else {
            print "No expiry date on ", $update->composition_uid, "\n";
        }
    }
}
else {
    print "No null expiry dates found in Information Orders\n"
}

sub update_information_order_expiry_date {
    my ( $composition_uid, $expiry_date ) = @_;
    print "Updating $composition_uid to Expiry Date: $expiry_date\n";
    my $information_order = $schema->resultset('InformationOrder')->search(
        {
            composition_uid => $composition_uid
        }
    );
    my $status = $information_order->update( 
        {
            expiry_date => $expiry_date,
        }
    );
    return $status;
}
    
sub find_expiry_date_by_uid {
    my $composition_uid = shift;
    my $expiry_query = << "END_EXPIRY_QUERY";
    select c/content/expiry_time/value as expiry_time
    from Composition c
    where c/uid/value = '$composition_uid'
END_EXPIRY_QUERY

    my $query = OpenEHR::REST::AQL->new();
    $query->statement($expiry_query);
    $query->run_query;
    if ( $query->response_code eq '204') {
        return 0;
    }
    if ( $query->err_msg ) {
        print Dumper ( "Query: " . $expiry_query);
        die $query->err_msg;
    }
    my $result = $query->resultset->[0]->{expiry_time};
    return &date_format($result);
}

sub find_orders_with_no_expiry {
    my $orders_rs = $schema->resultset('InformationOrder')->search(
        {
            expiry_date => undef,
            service_type => $service_type,
        },
        {
            columns => [qw/ composition_uid /],
        }
    );
    return $orders_rs;
}


sub date_format() {
    my $date = shift;
    if ($date eq 'R1') {
        $date = DateTime->now->datetime;
    }
        
    $date =~ s/T/ / if defined($date);
    $date =~ s/Z// if defined($date);
    return $date;
}

sub usage() {
    my $error_message = shift;
    print $error_message if $error_message;
    my $message = << "END_USAGE";
Usage: 
$0 -t [pathology | cancer | radiology]

You must provide an NHS Number (10 digits) or the keyword rand 
to place an order

OPTIONS

-t --type           Specify the Service Type for the order. 
                    Must be one of: 
                    [ pathology | cancer | radiology ]

END_USAGE

    print $message;
    exit 0;
}
