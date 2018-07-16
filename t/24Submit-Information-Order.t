use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::InformationOrder;

BEGIN { use_ok('OpenEHR::REST::Composition'); }

my @formats = qw(FLAT STRUCTURED RAW);

for my $format (@formats) {
    note("Testing $format information order format");
    my $ehr1 = &get_new_random_subject();
    $ehr1->get_new_ehr;
    if ( $ehr1->err_msg ) {
        die $ehr1->err_msg;
    }
    diag( 'EhrId: ' . $ehr1->ehr_id );
    diag( 'SubjectId: ' . $ehr1->subject_id );

    my $planned_order =
      OpenEHR::Composition::InformationOrder->new( current_state => 'planned',
      );
    $planned_order->composition_format($format);
    $planned_order->compose;

    ok( my $order = OpenEHR::REST::Composition->new(), "Construct REST order" );
    ok( $order->composition($planned_order), "Add composition to new order" );
    unless ( $format eq 'RAW' ) {
        ok(
            $order->template_id('GEL - Data request Summary.v1'),
            "Added template for $format format order"
        );
    }
    ok( $order->submit_new( $ehr1->ehr_id ), "Submit new information order" );
    ok( !$order->err_msg, "No error message returned from REST call" );
    if ( $order->err_msg ) {
        diag( "Error occurred in submission: " . $order->err_msg );
    }
    is( $order->action, "CREATE", "Action is CREATE" );
    diag( $order->compositionUid );    # the returned CompositionUid;
    diag( $order->href );              # URL to view the submitted composition;
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

