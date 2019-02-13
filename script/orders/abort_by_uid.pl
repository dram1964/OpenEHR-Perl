use strict;
use warnings;
use Data::Dumper;
use OpenEHR::REST::AQL;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use Genomes_100K::Schema;

my $dbi_dsn    = 'dbi:ODBC:DSN=CRIUGenomesTest';
my $user       = 'dr00';
my $pass       = 'letmein';
my $dbi_params = { LongReadLen => 80, LongTruncOk => 1 };
my $schema =
  Genomes_100K::Schema->connect( $dbi_dsn, $user, $pass, $dbi_params );

my $composition_uid = $ARGV[0];
die &usage unless $composition_uid;

my ($new_uid, $requestor_id) = &abort_order($composition_uid);
if ($requestor_id) {
	print "Updating requestor_id $requestor_id to aborted\n";
	&update_information_order( $new_uid, $requestor_id );
}

sub update_information_order() {
    my ($new_uid, $requestor_id) = @_;
    
    my $order = $schema->resultset('InformationOrder')->find( 
	{
		requestor_id => $requestor_id
	} 
    ); 
    $order->update( {
		order_state_code => 531,
		order_state => 'aborted',
		composition_uid => $new_uid,
    });
}

sub abort_order {
    my $uid = shift;
    my $template_id = 'GEL - Data request Summary.v1';
    # Retrieve the composition
    my $retrieval = OpenEHR::REST::Composition->new();
    $retrieval->request_format('STRUCTURED');
    $retrieval->find_by_uid($uid);
    my $composition = $retrieval->composition_response;
    print "Original order can be found at: " . $retrieval->href . "\n";

    #print Dumper $composition;

    # Recompose the composition with new status
    my $recompose = OpenEHR::Composition::InformationOrder->new();
    $recompose->decompose_structured($composition),
    $recompose->current_state('aborted');
    $recompose->composition_format('STRUCTURED');
    $recompose->compose;
    #print Dumper $recompose;
    
    # Submit the update
    my $order_update = OpenEHR::REST::Composition->new();
    $order_update->composition($recompose);
    $order_update->template_id($template_id);
    $order_update->update_by_uid($uid);
    if ($order_update->err_msg) {
        die "Error occurred in submission: " . $order_update->err_msg;
    }
    print "Update can be found at: " . $order_update->href . "\n";
    return $order_update->compositionUid, $recompose->requestor_id;

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
    my $message = << "END_USAGE";
Updates a composition status to aborted on both
OpenEHR and Information_Orders table

Usage: 
$0 <composition_uid>

END_USAGE

    print $message;
}
