use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::InformationOrder;
use DateTime::Format::Pg;

BEGIN { use_ok('OpenEHR::REST::Composition'); }

my $ehr1 = &get_new_random_subject();
$ehr1->get_new_ehr;
if ( $ehr1->err_msg ) {
    die $ehr1->err_msg;
}
note( 'EhrId: ' . $ehr1->ehr_id );
note( 'SubjectId: ' . $ehr1->subject_id );

my $template_id = 'GEL - Data request Summary.v1';

for my $format ( ('RAW') ) {
    my $start_date  = DateTime::Format::Pg->parse_datetime('2011-01-01');
    my $end_date    = DateTime::Format::Pg->parse_datetime('2018-01-01');
    my $timing      = DateTime::Format::Pg->parse_datetime('2018-07-01');
    my $expiry_time = DateTime::Format::Pg->parse_datetime('2018-12-31');
    my $order_data  = {
        current_state  => 'planned',
        start_date     => $start_date,
        end_date       => $end_date,
        timing         => $timing,
        expiry_time    => $expiry_time,
        composer_name  => 'GENIE',
        facility_id    => 'GOSH',
        facility_name  => 'Great Ormond Street',
        id_scheme      => 'GOSH-SCHEME',
        id_namespace   => 'GOSH-NS',
        language_code  => 'en',
        service_name   => 'GEL Information data request',
        service_type   => 'pathology',
        narrative      => 'GEL pathology data request',
        requestor_id   => '834y5jkdk-ssxhs',
        territory_code => 'ES',
    };

=for removal 
        language_terminology  => 'ISO_639-2',
        encoding_code         => 'UTF-9',
        encoding_terminology  => 'IANA_charsets',
        territory_terminology => 'ISO_3166-2',
    is( $order_update->language_terminology,
        $planned_order->language_terminology, 'language_terminology for update matches planned_order' );
    is( $order_update->encoding_code,
        $planned_order->encoding_code, 'encoding_code for update matches planned_order' );
    is( $order_update->encoding_terminology,
        $planned_order->encoding_terminology, 'encoding_terminology for update matches planned_order' );
    is( $order_update->territory_terminology,
        $planned_order->territory_terminology, 'territory_terminology for update matches planned_order' );
=cut

    my $planned_order =
      OpenEHR::Composition::InformationOrder->new( $order_data, );
    $planned_order->composition_format($format);

    ok( my $order = OpenEHR::REST::Composition->new(), "Construct REST order" );
    ok( $order->composition($planned_order), "Add composition to new order" );
    ok( $order->template_id($template_id),   "Add composition to new order" );
    ok( $order->submit_new( $ehr1->ehr_id ), "Submit new information order" );
    ok( !$order->err_msg, "No error message returned from REST call" );
    if ( $order->err_msg ) {
        diag( "Error occurred in submission: " . $order->err_msg );
    }
    is( $order->action, "CREATE", "Action is CREATE" );
    note( $order->compositionUid );    # the returned CompositionUid;
    note( $order->href );              # URL to view the submitted composition;

    my $order_retrieval = OpenEHR::REST::Composition->new();
    $order_retrieval->request_format($format);
    ok( $order_retrieval->find_by_uid( $order->compositionUid ),
        'Find Existing order' );

    is( $order_retrieval->response_format,
        $format, "Default response is in $format format" );
    is( $order_retrieval->template_id,
        $template_id, 'Information Order Template ID returned' );

    my $composition_format = $order_retrieval->response_format;
    my $composition        = $order_retrieval->composition_response;

    ok( my $order_update = OpenEHR::Composition::InformationOrder->new(),
        'Create blank Information order' );
    ok(
        $order_update->composition_format($format),
        "Set update composition format to $format"
    );
    ok( !$order_update->current_state,
        'current_state not set before decompose' );
    ok( !$order_update->current_state_code,
        'current_state_code not set before decompose' );
    is(
        $order_update->service_name,
        'GEL Information data request',
        'service_name set to default before decompose'
    );
    is( $order_update->service_type,
        'pathology', 'service_type set to default before decompose' );
    ok( !$order_update->requestor_id,  'requestor_id not set before decompose' );
    ok( !$order_update->start_date,  'start_date not set before decompose' );
    ok( !$order_update->end_date,    'end_date not set before decompose' );
    ok( !$order_update->timing,      'timing not set before decompose' );
    ok( !$order_update->expiry_time, 'expiry_time not set before decompose' );

    note('Decomposing composition into InformationOrder object');
    ok( $order_update->decompose($composition), 'Decompose the composition' );
    is( $order_update->composition_uid,
        $order->compositionUid,
        'UID for update matches UID returned by order' );
    is(
        $order_update->current_state,
        $planned_order->current_state,
        'current_state for update matches planned_order'
    );
    is(
        $order_update->current_state_code,
        $planned_order->current_state_code,
        'current_state_code for update matches planned_order'
    );
    is(
        $order_update->start_date,
        $planned_order->start_date,
        'start_date for update matches planned_order'
    );
    is( $order_update->end_date,
        $planned_order->end_date, 'end_date for update matches planned_order' );
    is( $order_update->timing,
        $planned_order->timing, 'timing for update matches planned_order' );
    is(
        $order_update->expiry_time,
        $planned_order->expiry_time,
        'expiry_time for update matches planned_order'
    );
    is(
        $order_update->composer_name,
        $planned_order->composer_name,
        'composer_name for update matches planned_order'
    );
    is(
        $order_update->facility_id,
        $planned_order->facility_id,
        'facility_id for update matches planned_order'
    );
    is(
        $order_update->facility_name,
        $planned_order->facility_name,
        'facility_name for update matches planned_order'
    );
    is( $order_update->id_scheme,
        $planned_order->id_scheme,
        'id_scheme for update matches planned_order' );
    is(
        $order_update->id_namespace,
        $planned_order->id_namespace,
        'id_namespace for update matches planned_order'
    );
    is(
        $order_update->language_code,
        $planned_order->language_code,
        'language_code for update matches planned_order'
    );
    is(
        $order_update->service_name,
        $planned_order->service_name,
        'service_name for update matches planned_order'
    );
    is(
        $order_update->service_type,
        $planned_order->service_type,
        'service_type for update matches planned_order'
    );
    is( $order_update->narrative,
        $planned_order->narrative,
        'narrative for update matches planned_order' );
    is(
        $order_update->territory_code,
        $planned_order->territory_code,
        'territory_code for update matches planned_order'
    );

    ok(
        $order_update->current_state('scheduled'),
        'Update the current_state to "scheduled"'
    );
    is( $order_update->current_state_code,
        '529', 'current_state_code updated to "529"' );
    ok( $order_update->composer_name('OpenEHR-Perl-' . $format), 'Update the composer name');

    ok( my $update_submission = OpenEHR::REST::Composition->new(),
        'Construct REST order update' );
    ok( $update_submission->template_id($template_id),
        'Set template_id for update' );
    ok( $update_submission->composition($order_update),
        'Add updated composition' );
    ok( $update_submission->update_by_uid( $order_update->composition_uid ),
        'Call update_by_uid' );
    ok( !$update_submission->err_msg,
        'No error message returned from REST call' );

    if ( $update_submission->err_msg ) {
        diag( 'Error occurred in submission: ' . $update_submission->err_msg );
    }
    is( $update_submission->action, 'UPDATE', 'Action is UPDATE' );
    note( $update_submission->compositionUid );   # the returned CompositionUid;
    note( $update_submission->href );   # URL to view the submitted composition;

}

done_testing;

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
