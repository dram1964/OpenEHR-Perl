use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use DateTime::Format::Pg;

my $ehr1 = &get_new_random_subject();
$ehr1->get_new_ehr;
if ( $ehr1->err_msg ) {
    die $ehr1->err_msg;
}
diag( 'EhrId: ' . $ehr1->ehr_id );
diag( 'SubjectId: ' . $ehr1->subject_id );

my $start_date  = DateTime::Format::Pg->parse_datetime('2011-01-01');
my $end_date    = DateTime::Format::Pg->parse_datetime('2018-01-01');
my $timing      = DateTime::Format::Pg->parse_datetime('2018-07-01');
my $expiry_time = DateTime::Format::Pg->parse_datetime('2018-12-31');
my $order_data = {
    current_state      => 'scheduled',
        start_date    => $start_date,
        end_date      => $end_date,
        timing        => $timing,
        expiry_time   => $expiry_time,
        request_id    => 'Dev-Sub-' . int(rand(100000)), 
};

my $scheduled_order = OpenEHR::Composition::InformationOrder->new(
    $order_data,
);
$scheduled_order->composition_format('RAW');
$scheduled_order->compose;

my $order = OpenEHR::REST::Composition->new();
$order->composition($scheduled_order);
$order->submit_new($ehr1->ehr_id );
if ($order->err_msg) {
    diag("Error occurred in submission of new order: " . $order->err_msg);
}
my $composition_uid = $order->compositionUid;
diag("New order UID: " . $order->compositionUid); 
diag("New order HREF: " . $order->href);

my $order_retrieval = OpenEHR::REST::Composition->new();
ok($order_retrieval->request_format('RAW'), 'Set retrieveal format to RAW');
ok($order_retrieval->find_by_uid($composition_uid), 'Find Existing order');
is($order_retrieval->response_format, 'RAW', 'Default response is in RAW format'); 
print Dumper $order_retrieval;

    is($order_retrieval->template_id, 'GEL - Data request Summary.v1', 'Information Order Template ID returned');
    my $composition_format = $order_retrieval->response_format;
    my $template_id = $order_retrieval->template_id;
    my $composition = $order_retrieval->composition_response;

    ok(my $order_update = OpenEHR::Composition::InformationOrder->new(), 'Create blank Information order');
    ok(!$order_update->current_state, 'current_state not set before decompose');
    ok(!$order_update->current_state_code, 'current_state_code not set before decompose');
    is($order_update->service_name, 'GEL Information data request', 'service_name set before decompose');
    is($order_update->service_type, 'pathology', 'service_type set before decompose');
    ok(!$order_update->request_id, 'request_id not set before decompose');
    ok(!$order_update->start_date, 'start_date not set before decompose');
    ok(!$order_update->end_date, 'end_date not set before decompose');
    ok(!$order_update->timing, 'timing not set before decompose');
    ok(!$order_update->expiry_time, 'expiry_time not set before decompose');

    note('Decomposing composition into InformationOrder object');
    ok($order_update->decompose_raw($composition), 'Decompose the composition');
    is($order_update->current_state, 'scheduled', 'current_state set after decompose');

SKIP: {
    skip "Not implmenented yet", 1;

    is($order_update->current_state_code, '526', 'current_state_code set after decompose');
    is($order_update->service_name, 'GEL Information data request', 'service_name set after decompose');
    is($order_update->service_type, 'pathology', 'service_type set after decompose');
    ok($order_update->request_id, 'request_id set after decompose');
    is($order_update->start_date,  $start_date, 'start_date set after decompose');
    is($order_update->end_date, $end_date, 'end_date set after decompose');
    is($order_update->timing, $timing, 'timing set after decompose');
    is($order_update->expiry_time, $expiry_time, 'expiry_time set after decompose');

#print Dumper $composition;
    note('Updating the order');
    ok($order_update->current_state('completed'), 'Update current state for retrieved composition');
    ok($order_update->composition_format('RAW'), 'Change submission format to RAW');
    ok($order_update->compose, 'Compose the updated order');

    note('Submitting the order update');
    ok(my $order_completion = OpenEHR::REST::Composition->new(), "Construct REST order");
    ok($order->composition($order_update), "Add composition to new order");
    ok($order->update_by_uid($composition_uid), "Submit new information order");
    ok(!$order->err_msg, "No error message returned from REST call");
    if ($order->err_msg) {
        diag("Error occurred in submission: " . $order->err_msg);
    }
    is($order->action, "UPDATE", "Action is UPDATE");
    diag($order->compositionUid); 
    diag($order->href);

};

sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
        $subject_id .= '0000000000';
        if ($subject_id =~ /^(\d{10,10}).*/) {
            $subject_id = $1;
        }
        my $subject    = {
            subject_id        => $subject_id,
            subject_namespace => 'uk.nhs.nhs_number',
        };
        $ehr = OpenEHR::REST::EHR->new($subject);
        $ehr->find_by_subject_id;
        $action = $ehr->action;
    }
    return $ehr;
}

done_testing;

