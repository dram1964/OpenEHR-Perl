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

my $state = 'planned';

my $query = OpenEHR::REST::AQL->new();
$query->find_orders_by_state($state);

if ( $query->response_code eq '204') {
    print "No $state orders found\n";
    exit 1;
}
if ( $query->err_msg ) {
    die $query->err_msg;
}

for my $result ( @{ $query->resultset } ) {
    &insert_order($result);
    &update_state($result->{composition_uid});
}

sub update_state {
    my $uid = shift;
    my $template_id = 'GEL - Data request Summary.v1';
    # Retrieve the composition
    my $retrieval = OpenEHR::REST::Composition->new();
    $retrieval->request_format('STRUCTURED');
    $retrieval->find_by_uid($uid);
    my $composition = $retrieval->composition_response;
    print "Original order can be found at: " . $retrieval->href . "\n";

    print Dumper $composition;

    # Recompose the composition with new state
    my $recompose = OpenEHR::Composition::InformationOrder->new();
    $recompose->decompose_structured($composition),
    $recompose->current_state('scheduled');
    $recompose->composition_format('STRUCTURED');
    $recompose->compose;
    
    # Submit the update
    my $order_update = OpenEHR::REST::Composition->new();
    $order_update->composition($recompose);
    $order_update->template_id($template_id);
    $order_update->update_by_uid($uid);
    if ($order_update->err_msg) {
        die "Error occurred in submission: " . $order_update->err_msg;
    }
    print "Update can be found at: " . $order_update->href . "\n";

}

sub insert_order() {
    my $result = shift;
    my $order = $schema->resultset('InformationOrder')->update_or_create(
        {
            order_id          => $result->{order_id},
            start_date        => &date_format($result->{start_date}),
            end_date          => &date_format($result->{end_date}),
            composition_uid   => $result->{composition_uid},
            ordered_by        => $result->{ordered_by},
            order_type        => $result->{order_type},
            order_state       => $result->{current_state},
            order_state_code  => $result->{current_state_code},
            subject_id        => $result->{subject_id},
            subject_id_type   => $result->{subject_id_type},
            subject_ehr_id    => $result->{subject_ehr_id},
            service_type      => $result->{service_type},
            data_start_date   => &date_format($result->{data_start_date}),
            data_end_date     => &date_format($result->{data_end_date}),
            unique_message_id => $result->{unique_message_id},
        }
    );
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
