use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Template;

BEGIN { use_ok('OpenEHR::Composition::InformationOrder'); }

my $template_id = 'GEL - Data request Summary.v1';
my $template = OpenEHR::REST::Template->new();
$template->get_template_example($template_id, 'FLAT', 'INPUT');
print Dumper $template->data;

my $ehr1 = &get_new_random_subject();
$ehr1->get_new_ehr;
if ( $ehr1->err_msg ) {
    die $ehr1->err_msg;
}
diag( 'EhrId: ' . $ehr1->ehr_id );
diag( 'SubjectId: ' . $ehr1->subject_id );

ok(
    my $planned_order = OpenEHR::Composition::InformationOrder->new(
        current_state      => 'planned',
    )
);

is($planned_order->current_state, 'planned', 'Current State accessor');
is($planned_order->current_state_code, '526', 'Current State Code accessor');

ok($planned_order->current_state('scheduled'), 'Current State changed to scheduled');
is($planned_order->current_state_code, '529', 'Current State Code updated for scheduled');

ok($planned_order->current_state('aborted'), 'Current State changed to aborted');
is($planned_order->current_state_code, '531', 'Current State Code updated for aborted');

ok($planned_order->current_state('completed'), 'Current State changed to completed');
is($planned_order->current_state_code, '532', 'Current State Code updated for completed');

is( $planned_order->composition_format,
    'STRUCTURED', 'Default composition format is STRUCTURED' );

ok($planned_order->composition_format('FLAT'), 'Set composition to FLAT format');

ok(my $composition = $planned_order->compose, 'Called compose for FLAT composition');
print Dumper ($composition);


done_testing;

sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
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

