use strict;
use warnings;
use Data::Dumper;
use OpenEHR::REST::AQL;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomesTest');

my $state = 'planned';

my $dtf            = $schema->storage->datetime_parser;
my $expired_orders = $schema->resultset('InformationOrder')->search(
    {
        end_date => { '<=', $dtf->format_datetime( DateTime->now() ) },
        order_state_code => '529',
    },
);

while ( my $order = $expired_orders->next ) {

    my $query = OpenEHR::REST::AQL->new();
    $query->find_orders_by_uid( $order->composition_uid );

    if ( $query->response_code eq '204' ) {
        print "No $state orders found on OpenEHR for " . $order->composition_uid . "\n";
        next;
    }
    if ( $query->err_msg ) {
        die $query->err_msg;
    }

    my $result = $query->resultset->[0];
    my $new_uid = &update_state( $result->{composition_uid} );
    &mark_completed($new_uid, $result);
}

sub mark_completed() {
    my ($new_uid, $result) = @_;
    my $order  = $schema->resultset('InformationOrder')->update_or_create(
        {
            request_uid          => $result->{request_uid},
            order_date        => &date_format($result->{order_date}),
            expiry_date          => &date_format($result->{expiry_date}),
            composition_uid   => $new_uid, #$result->{composition_uid},
            ordered_by        => $result->{ordered_by},
            order_type        => $result->{order_type},
            order_state       => 'scheduled', #$result->{current_state},
            order_state_code  => 529, #$result->{current_state_code},
            subject_id        => $result->{subject_id},
            subject_id_type   => $result->{subject_id_type},
            subject_ehr_id    => $result->{subject_ehr_id},
            service_type      => $result->{service_type},
            data_start_date   => &date_format($result->{data_start_date}),
            data_end_date     => &date_format($result->{data_end_date}),
            requestor_id => $result->{requestor_id},
        }
    );
}

sub update_state {
    my $uid         = shift;
    my $template_id = 'GEL - Data request Summary.v1';

    # Retrieve the composition
    my $retrieval = OpenEHR::REST::Composition->new();
    $retrieval->request_format('STRUCTURED');
    $retrieval->find_by_uid($uid);
    my $composition = $retrieval->composition_response;
    print "Original order can be found at: " . $retrieval->href . "\n";

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
    print "Update can be found at: " . $order_update->href . "\n";
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
    if ($date eq 'R1') {
        $date = DateTime->now->datetime;
    }
        
    $date =~ s/\+\d{2,2}:\d{2,2}//;
    $date =~ s/T/ / if defined($date);
    $date =~ s/Z// if defined($date);
    return $date;
}
