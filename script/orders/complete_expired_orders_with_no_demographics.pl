use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use OpenEHR::REST::AQL;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use Genomes_100K::Model;

my ($offset, $help);

GetOptions (
    "offset=i" => \$offset,
    "help" => \$help,
    )
or &usage("Error in command line arguments\n");

&usage if $help;
&usage unless $offset;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $state = 'scheduled';

my $dtf            = $schema->storage->datetime_parser;
my $cut_off_date = DateTime->now()->subtract( days => $offset );
my $expired_orders = $schema->resultset('InformationOrder')->search(
    {
        expiry_date => { '<=', $dtf->format_datetime( $cut_off_date ) },
        order_state_code => '529',
    },
    {
        #rows => 100,
    },
);

if ( $expired_orders->count > 0 ) {
    while ( my $order = $expired_orders->next ) {
        next if defined($order->demographic);
        #print "No Demographics found for NHS Number: ", $order->subject_id, "\n";

        my $query = OpenEHR::REST::AQL->new();
        $query->find_orders_by_uid( $order->composition_uid );

        if ( $query->response_code eq '204' ) {
#            print "No $state orders found on OpenEHR for " . $order->composition_uid . "\n";
#            next;
        }
        if ( $query->err_msg ) {
            die $query->err_msg;
        }

        my $result = $query->resultset->[0];
        my $new_uid = &update_state( $result->{composition_uid} );
        &mark_completed($new_uid, $result);
    }
}
elsif ( $expired_orders->count == 1 ) {
    my $order = $expired_orders->first; 
    if (!defined($order->demographic)) {
        #print "No Demographics found for NHS Number: ", $order->subject_id, "\n";
        my $query = OpenEHR::REST::AQL->new();
        $query->find_orders_by_uid( $order->composition_uid );

        if ( $query->response_code eq '204' ) {
            #print "No $state orders found on OpenEHR for " . $order->composition_uid . "\n";
            next;
        }
        if ( $query->err_msg ) {
            die $query->err_msg;
        }

        my $result = $query->resultset->[0];
        my $new_uid = &update_state( $result->{composition_uid} );
        my $status = &mark_completed($new_uid, $result);
        die "Update to $new_uid failed" unless $status;
    }
}
else {
#    print "No expired orders older than cutoff date (", 
#        $cut_off_date, ") found in InformationOrders table\n";
}


sub mark_completed() {
    my ($new_uid, $result) = @_;
    my $order = $schema->resultset('InformationOrder')->find({
        requestor_id => $result->{requestor_id},
    });
    my $status = $order->update({
        composition_uid => $new_uid,
        order_state => 'complete',
        order_state_code => '532',
    });
    return $status;
}

sub update_state {
    my $uid         = shift;
    my $template_id = 'GEL - Data request Summary.v1';

    # Retrieve the composition
    my $retrieval = OpenEHR::REST::Composition->new();
    $retrieval->request_format('STRUCTURED');
    $retrieval->find_by_uid($uid);
    my $composition = $retrieval->composition_response;
    #print "Original order can be found at: " . $retrieval->href . "\n";

    # Recompose the composition with new state
    my $recompose = OpenEHR::Composition::InformationOrder->new();
    $recompose->decompose_structured($composition),
      $recompose->current_state('complete');
    $recompose->composition_format('STRUCTURED');

    #$recompose->compose;

    # Submit the update
    my $order_update = OpenEHR::REST::Composition->new();
    $order_update->composition($recompose);
    $order_update->template_id($template_id);
    $order_update->update_by_uid($uid);
    if ( $order_update->err_msg ) {
        die "Error occurred in submission: " . $order_update->err_msg;
    }
    #print "Update can be found at: " . $order_update->href . "\n";
    return $order_update->compositionUid;
}

=for removal
sub date_format() {
    my $date = shift;
    if ( $date eq 'R1' ) {
        $date = DateTime->now->datetime;
    }

    $date =~ s/T/ / if defined($date);
    $date =~ s/Z//  if defined($date);
    return $date;
}
=cut

sub date_format() {
    my $date = shift;
    return 0 unless $date;
    if ($date eq 'R1') {
        $date = DateTime->now->datetime;
    }
        
    $date =~ s/\+\d{2,2}:\d{2,2}//;
    $date =~ s/T/ / if defined($date);
    $date =~ s/Z// if defined($date);
    return $date;
}

sub usage() {
    my $error_message = shift;
    print $error_message if $error_message;
    my $message = << "END_USAGE";
Usage: 
$0 -o offset

This script will expire all scheduled orders whose expiry 
date is more than 'offset' days older than today's date if 
the subject of the order is not found in the Demographics
table on the datasource system.
A numeric offset (positive integer) must be provided. 

OPTIONS

-o --offset     [REQUIRED] Number of days prior to today. 
                Scheduled orders with an expiry date before this
                date will be marked as 'complete'

-h --help       [OPTIONAL] Prints this message and terminates

END_USAGE

    print $message;
    exit 0;
}
