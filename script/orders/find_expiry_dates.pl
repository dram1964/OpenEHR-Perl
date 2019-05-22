use strict;
use warnings;

use Data::Dumper;

use Genomes_100K::Model;
use OpenEHR::REST::Composition;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $orders_rs = $schema->resultset('InformationOrder')->search(
    {
        order_state => 'scheduled',
    }
);

while (my $order = $orders_rs->next) {
    my $uid = $order->composition_uid;
    $uid =~ s/\d{1,1}$/1/;
    my $retrieval = OpenEHR::REST::Composition->new();
    if ( $retrieval->find_by_uid($uid) ) {
        my $composition = $retrieval->composition_response;
        my $expiry_time = $composition->{gel_data_request_summary}->{service_request}->[0]->{expiry_time}->[0];
        if ($expiry_time) {
            printf("UID: %s: Expiry: %s\n", $uid, $expiry_time);
        }
    }
}
