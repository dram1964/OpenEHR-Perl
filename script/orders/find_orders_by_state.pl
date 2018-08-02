use strict;
use warnings;
use OpenEHR::REST::AQL;
use Data::Dumper;

my $status = $ARGV[0];
die &usage unless $status;


my $aql_info_orders = << "END_AQL";
    select 
    e/ehr_id/value as ehrid, 
    e/ehr_status/subject/external_ref/namespace as subject_id_type,
    e/ehr_status/subject/external_ref/id/value as subject_id,
    c/uid/value as composition_uid, 
    i/narrative/value as narrative,
    c/name/value as order_type, 
    c/composer/name as order_submitted_by,
    i/uid/value as request_id, 
    i/protocol[at0008]/items[at0010]/value/value as unique_message_id,
    i/activities[at0001]/timing/value as request_start_date, 
    i/expiry_time/value as request_end_date,
    c/context/start_time/value as data_start_time, 
    c/context/end_time/value as data_end_time,
    i/activities[at0001]/description[at0009]/items[at0148]/value/value as service_type,
    a/ism_transition/current_state/value as current_state,
    a/ism_transition/current_state/defining_code/code_string as current_state_code,
    ehr_status/subject/external_ref/id/value as nhsnumber
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
if ($query->err_msg) {
    print Dumper ("Query: " . $aql_info_orders);
    die $query->err_msg;
}

print Dumper $query->resultset;

sub usage() {
    my $message = << "END_USAGE";
Usage: 
$0 [ planned | scheduled | completed | aborted ]

You must provide a status value

END_USAGE

    print $message;
}
