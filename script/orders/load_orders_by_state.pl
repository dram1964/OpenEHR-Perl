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

my $status = $ARGV[0];
die &usage unless $status;

my $aql_info_orders = << "END_AQL";
    select 
 e/ehr_id/value as subject_ehr_id,
 e/ehr_status/subject/external_ref/namespace as subject_id_type,
 e/ehr_status/subject/external_ref/id/value as subject_id,
 c/uid/value as composition_uid,
 i/narrative/value as narrative,
 c/name/value as order_type,
 c/composer/name as ordered_by,
 i/uid/value as order_id,
 i/protocol[at0008]/items[at0010]/value/value as unique_message_id,
 i/activities[at0001]/timing/value as start_date,
 i/expiry_time/value as end_date,
 c/context/start_time/value as data_start_date,
 c/context/end_time/value as data_end_date,
 i/activities[at0001]/description[at0009]/items[at0148]/value/value as service_type,
 a/ism_transition/current_state/value as current_state,
 a/ism_transition/current_state/defining_code/code_string as current_state_code
    from EHR e
    contains COMPOSITION c[openEHR-EHR-COMPOSITION.report.v1]
    contains (INSTRUCTION i[openEHR-EHR-INSTRUCTION.request.v0]
    and ACTION a[openEHR-EHR-ACTION.service.v0])
    where i/activities[at0001]/description[at0009]/items[at0121]/value = 'GEL Information data request'
    and i/activities[at0001]/description[at0009]/items[at0148]/value/value = 'pathology'
    and a/ism_transition/current_state/value = '$status'
END_AQL

my $query = OpenEHR::REST::AQL->new();
$query->statement($aql_info_orders);
$query->run_query;
if ( $query->response_code eq '204') {
    print "No $status orders found\n";
    exit 1;
}
if ( $query->err_msg ) {
    print Dumper ( "Query: " . $aql_info_orders );
    die $query->err_msg;
}

#print Dumper $query->resultset->[0];
#
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

    # Recompose the composition with new status
    my $recompose = OpenEHR::Composition::InformationOrder->new();
    $recompose->decompose_structured($composition),
    $recompose->current_state('scheduled');
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
            order_state       => $result->{order_state},
            order_state_code  => $result->{order_state_code},
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

sub usage() {
    my $message = << "END_USAGE";
Usage: 
$0 [ planned | scheduled | completed | aborted ]

You must provide a status value

END_USAGE

    print $message;
}
