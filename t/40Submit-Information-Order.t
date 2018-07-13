use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::InformationOrder;

BEGIN { use_ok('OpenEHR::REST::InformationOrder'); }

my $ehr1 = &get_new_random_subject();
$ehr1->get_new_ehr;
if ( $ehr1->err_msg ) {
    die $ehr1->err_msg;
}
diag( 'EhrId: ' . $ehr1->ehr_id );
diag( 'SubjectId: ' . $ehr1->subject_id );

my $planned_order = OpenEHR::Composition::InformationOrder->new(
    current_state      => 'planned',
);
$planned_order->composition_format('RAW');
$planned_order->compose;

ok(my $order = OpenEHR::REST::InformationOrder->new(), "Construct REST order");
ok($order->composition($planned_order), "Add composition to new order");
ok($order->submit_new($ehr1->ehr_id), "Submit new information order");
ok(!$order->err_msg, "No error message returned from REST call");
if ($order->err_msg) {
    diag("Error occurred in submission: " . $order->err_msg);
}
is($order->action, "CREATE", "Action is CREATE");
diag($order->compositionUid); # the returned CompositionUid;
diag($order->href); # URL to view the submitted composition;

my $update_scheduled = OpenEHR::Composition::InformationOrder->new(
    current_state   => 'scheduled'
);
$update_scheduled->composition_format('RAW');
$update_scheduled->compose;

ok(my $order_update1 = OpenEHR::REST::InformationOrder->new(), 'Construct REST order update1');
ok($order_update1->composition($update_scheduled), 'Add scheduled composition');
ok($order_update1->update_by_uid($order->compositionUid), 'Call update_by_uid');
ok(!$order_update1->err_msg, 'No error message returned from REST call');
if ($order_update1->err_msg) {
    diag('Error occurred in submission: ' . $order_update1->err_msg);
}
is($order_update1->action, 'UPDATE', 'Action is UPDATE');
diag($order_update1->compositionUid); # the returned CompositionUid;
diag($order_update1->href); # URL to view the submitted composition;

my $update_completed = OpenEHR::Composition::InformationOrder->new(
    current_state   => 'completed'
);
$update_completed->composition_format('RAW');
$update_completed->compose;

ok(my $order_update2 = OpenEHR::REST::InformationOrder->new(), 'Construct REST order update2');
ok($order_update2->composition($update_completed), 'Add completed composition');
ok($order_update2->update_by_uid($order_update1->compositionUid), 'Call update by UID');
ok(!$order_update2->err_msg, 'No error message returned from REST call');
if ($order_update2->err_msg) {
    diag('Error occurred in submission: ' . $order_update2->err_msg);
}
is($order_update2->action, 'UPDATE', 'Action is UPDATE');
diag($order_update2->compositionUid); # the returned CompositionUid;
diag($order_update2->href); # URL to view the submitted composition;

my $update_aborted = OpenEHR::Composition::InformationOrder->new(
    current_state   => 'aborted'
);
$update_aborted->composition_format('RAW');
$update_aborted->compose;

ok(my $order_update3 = OpenEHR::REST::InformationOrder->new(), 'Construct REST order update3');
ok($order_update3->composition($update_aborted), 'Add aborted composition');
ok($order_update3->update_by_uid($order_update2->compositionUid), 'Call update by UID');
ok(!$order_update3->err_msg, 'No error message returned from REST call');
if ($order_update3->err_msg) {
    diag('Error occurred in submission: ' . $order_update3->err_msg);
}
is($order_update3->action, 'UPDATE', 'Action is UPDATE');
diag($order_update3->compositionUid); # the returned CompositionUid;
diag($order_update3->href); # URL to view the submitted composition;

#   my $order_diag = OpenEHR::REST::InformationOrder->new();
#   $order_diag->request_format('RAW');
#   $order_diag->find_by_uid($order->compositionUid);
#   print Dumper $order_diag->composition_response;

sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
        $subject_id += '0000000000';
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

