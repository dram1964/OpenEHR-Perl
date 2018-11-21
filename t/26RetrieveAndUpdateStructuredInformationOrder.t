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
note( 'EhrId: ' . $ehr1->ehr_id );
note( 'SubjectId: ' . $ehr1->subject_id );

my $start_date  = DateTime::Format::Pg->parse_datetime('2011-01-01');
my $end_date    = DateTime::Format::Pg->parse_datetime('2018-01-01');
my $timing      = DateTime::Format::Pg->parse_datetime('2018-07-01');
my $expiry_time = DateTime::Format::Pg->parse_datetime('2018-12-31');
my $order_data  = {
    current_state => 'planned',
    start_date    => $start_date,
    end_date      => $end_date,
    timing        => $timing,
    expiry_time   => $expiry_time,
    request_id    => 'Dev-Sub-' . int( rand(100000) ),
    service_type  => 'cancer',
};

note('Testing Structured Composer/Decomposer');
{
    my $planned_order = OpenEHR::Composition::InformationOrder->new( $order_data, );
    $planned_order->composition_format('STRUCTURED');
    $planned_order->compose;

    my $template_id = 'GEL - Data request Summary.v1';
    my $order       = OpenEHR::REST::Composition->new();
    $order->composition($planned_order);
    $order->template_id($template_id);
    $order->submit_new( $ehr1->ehr_id );
    if ( $order->err_msg ) {
        diag( "Error occurred in submission of new order: " . $order->err_msg );
    }
    my $composition_uid = $order->compositionUid;
    note( "New order UID: " . $order->compositionUid );
    note( "New order HREF: " . $order->href );

    my $order_retrieval = OpenEHR::REST::Composition->new();
    $order_retrieval->request_format('STRUCTURED');
    ok( $order_retrieval->find_by_uid($composition_uid), 'Find Existing order' );
#print Dumper $order_retrieval;


    is( $order_retrieval->response_format,
        'STRUCTURED', 'Default response is in STRUCTURED format' );
    is(
        $order_retrieval->template_id,
        'GEL - Data request Summary.v1',
        'Information Order Template ID returned'
    );

    my $composition_format = $order_retrieval->response_format;
    my $composition        = $order_retrieval->composition_response;

#print Dumper $composition;
    ok( my $order_update = OpenEHR::Composition::InformationOrder->new(),
        'Create blank Information order' );
    ok( !$order_update->current_state, 'current_state not set before decompose' );
    ok( !$order_update->current_state_code,
        'current_state_code not set before decompose' );
    is(
        $order_update->service_name,
        'GEL Information data request',
        'service_name set before decompose'
    );
    is( $order_update->service_type,
        'pathology', 'service_type set to default before decompose' );
    ok( !$order_update->request_id,  'request_id not set before decompose' );
    ok( !$order_update->start_date,  'start_date not set before decompose' );
    ok( !$order_update->end_date,    'end_date not set before decompose' );
    ok( !$order_update->timing,      'timing not set before decompose' );
    ok( !$order_update->expiry_time, 'expiry_time not set before decompose' );

    note('Decomposing composition into InformationOrder object');

#print Dumper $composition;
    ok( $order_update->decompose_structured($composition),
        'Decompose the composition' );
    is( $order_update->current_state,
        'planned', 'current_state set after decompose' );
    is( $order_update->current_state_code,
        '526', 'current_state_code set after decompose' );
    is(
        $order_update->service_name,
        'GEL Information data request',
        'service_name set after decompose'
    );
    is( $order_update->service_type,
        'cancer', 'service_type set after decompose' );
    ok( $order_update->request_id, 'request_id set after decompose' );
    is( $order_update->start_date, $start_date, 'start_date set after decompose' );
    is( $order_update->end_date,   $end_date,   'end_date set after decompose' );
    is( $order_update->timing,     $timing,     'timing set after decompose' );
    is( $order_update->expiry_time,
        $expiry_time, 'expiry_time set after decompose' );

    note('Updating the composition attributes');
    ok(
        $order_update->current_state('scheduled'),
        'Update current state for retrieved composition'
    );
    ok(
        $order_update->composition_format('STRUCTURED'),
        'Change submission format to STRUCTURED'
    );
    ok( $order_update->compose, 'Compose the updated order' );

    note('Submitting the order update');
    ok( my $order_completion = OpenEHR::REST::Composition->new(),
        "Construct REST order" );
    ok( $order_completion->composition($order_update), "Add composition to new order" );
    ok( $order_completion->template_id($template_id),
        'Set the template id for STRUCTURED submission' );
    ok( $order_completion->update_by_uid($composition_uid), "Submit new information order" );
    ok( !$order_completion->err_msg, "No error message returned from REST call" );
    if ( $order_completion->err_msg ) {
        diag( "Error occurred in submission: " . $order_completion->err_msg );
    }
    is( $order_completion->action, "UPDATE", "Action is UPDATE" );
    note( $order_completion->compositionUid );
    note( $order_completion->href );
}

note('Testing RAW Composer/Decomposer');
{
    my $planned_order = OpenEHR::Composition::InformationOrder->new( $order_data, );
    $planned_order->composition_format('RAW');
    $planned_order->compose;

    my $template_id = 'GEL - Data request Summary.v1';
    my $order       = OpenEHR::REST::Composition->new();
    $order->composition($planned_order);
    $order->template_id($template_id);
    $order->submit_new( $ehr1->ehr_id );
    if ( $order->err_msg ) {
        diag( "Error occurred in submission of new order: " . $order->err_msg );
    }
    my $composition_uid = $order->compositionUid;
    note( "New order UID: " . $order->compositionUid );
    note( "New order HREF: " . $order->href );

    my $order_retrieval = OpenEHR::REST::Composition->new();
    $order_retrieval->request_format('RAW');
    ok( $order_retrieval->find_by_uid($composition_uid), 'Find Existing order' );
#print Dumper $order_retrieval;


    is( $order_retrieval->response_format,
        'RAW', 'Response is in RAW format' );
    is(
        $order_retrieval->template_id,
        'GEL - Data request Summary.v1',
        'Information Order Template ID returned'
    );

    my $composition_format = $order_retrieval->response_format;
    my $composition        = $order_retrieval->composition_response;

#print Dumper $composition;
    ok( my $order_update = OpenEHR::Composition::InformationOrder->new(),
        'Create blank Information order' );
    ok( !$order_update->current_state, 'current_state not set before decompose' );
    ok( !$order_update->current_state_code,
        'current_state_code not set before decompose' );
    is(
        $order_update->service_name,
        'GEL Information data request',
        'service_name set before decompose'
    );
    is( $order_update->service_type,
        'pathology', 'service_type set to default before decompose' );
    ok( !$order_update->request_id,  'request_id not set before decompose' );
    ok( !$order_update->start_date,  'start_date not set before decompose' );
    ok( !$order_update->end_date,    'end_date not set before decompose' );
    ok( !$order_update->timing,      'timing not set before decompose' );
    ok( !$order_update->expiry_time, 'expiry_time not set before decompose' );

    note('Decomposing composition into InformationOrder object');

#print Dumper $composition;
    ok( $order_update->decompose_raw($composition),
        'Decompose the composition' );
    is( $order_update->current_state,
        'planned', 'current_state set after decompose' );
    is( $order_update->current_state_code,
        '526', 'current_state_code set after decompose' );
    is(
        $order_update->service_name,
        'GEL Information data request',
        'service_name set after decompose'
    );
    is( $order_update->service_type,
        'cancer', 'service_type set after decompose' );
    ok( $order_update->request_id, 'request_id set after decompose' );
    is( $order_update->start_date, $start_date, 'start_date set after decompose' );
    is( $order_update->end_date,   $end_date,   'end_date set after decompose' );
    is( $order_update->timing,     $timing,     'timing set after decompose' );
    is( $order_update->expiry_time,
        $expiry_time, 'expiry_time set after decompose' );

    note('Updating the composition attributes');
    ok(
        $order_update->current_state('scheduled'),
        'Update current state for retrieved composition'
    );
    ok(
        $order_update->composition_format('RAW'),
        'Change submission format to RAW'
    );
    ok( $order_update->compose, 'Compose the updated order' );

    note('Submitting the order update');
    ok( my $order_completion = OpenEHR::REST::Composition->new(),
        "Construct REST order" );
    ok( $order_completion->composition($order_update), "Add composition to new order" );
    ok( $order_completion->template_id($template_id),
        'Set the template id for STRUCTURED submission' );
    ok( $order_completion->update_by_uid($composition_uid), "Submit new information order" );
    ok( !$order_completion->err_msg, "No error message returned from REST call" );
    if ( $order_completion->err_msg ) {
        diag( "Error occurred in submission: " . $order_completion->err_msg );
    }
    is( $order_completion->action, "UPDATE", "Action is UPDATE" );
    note( $order_completion->compositionUid );
    note( $order_completion->href );
}


sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
        $subject_id .= '0000000000';
        if ( $subject_id =~ /^(\d{10,10}).*/ ) {
            $subject_id = $1;
        }
        my $subject = {
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

