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
$planned_order->composition_format('FLAT');
my $composition = $planned_order->compose;

my $query = OpenEHR::REST::InformationOrder->new();


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
