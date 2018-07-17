use strict;
use warnings;
use Test::More;
use Data::Dumper;
use DateTime;
use OpenEHR::REST::EHR;
use OpenEHR::Composition::InformationOrder;

BEGIN { use_ok('OpenEHR::REST::Composition'); }

my $start_date = DateTime->new(
    year    => 2011,
    month   => 1,
    day     => 1,
);

my $end_date = DateTime->new(
    year    => 2017,
    month   => 12,
    day     => 31,
);

my $timing  = DateTime->new(
    year    => 2018,
    month   => 07,
    day     => 07,
);
my $expiry_time = DateTime->new(
    year    => 2019,
    month   => 11,
    day     => 30,
);

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

    my $request_id = int(rand(1000000000));
    my $planned_order =
      OpenEHR::Composition::InformationOrder->new( 
        current_state => 'planned',
        start_date    => $start_date,
        end_date      => $end_date,
        timing        => $timing,
        expiry_time   => $expiry_time,
        request_id    => $request_id,
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

