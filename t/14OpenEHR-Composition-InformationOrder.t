use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Template;
use DateTime::Format::Pg;

BEGIN { use_ok('OpenEHR::Composition::InformationOrder'); }
my $template_id = 'GEL - Data request Summary.v1';
my $template    = OpenEHR::REST::Template->new();
$template->get_template_example( $template_id, 'RAW', 'INPUT' );

#print Dumper $template->data;

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

ok(
    my $planned_order = OpenEHR::Composition::InformationOrder->new(
        current_state => 'planned',
        start_date    => $start_date,
        end_date      => $end_date,
        timing        => $timing,
        expiry_time   => $expiry_time,
    ), 'Constructor called'
);

is( $planned_order->service_type, 'pathology', 'Service Type Defaulted' );
ok( $planned_order->service_type('radiology'), 'Service Type mutator' );
is( $planned_order->service_type,
    'radiology', 'Service Type changed by mutator' );

is( $planned_order->current_state, 'planned', 'Current State accessor' );
is( $planned_order->current_state_code, '526', 'Current State Code accessor' );

ok(
    $planned_order->current_state('scheduled'),
    'Current State changed to scheduled'
);
is( $planned_order->current_state_code,
    '529', 'Current State Code updated for scheduled' );

ok(
    $planned_order->current_state('aborted'),
    'Current State changed to aborted'
);
is( $planned_order->current_state_code,
    '531', 'Current State Code updated for aborted' );

ok(
    $planned_order->current_state('complete'),
    'Current State changed to complete'
);
is( $planned_order->current_state_code,
    '532', 'Current State Code updated for complete' );

ok(
    $planned_order->current_state('planned'),
    'Current State changed to planned'
);
is( $planned_order->current_state_code,
    '526', 'Current State Code updated for planned' );

is( $planned_order->composition_format,
    'STRUCTURED', 'Default composition format is STRUCTURED' );

ok( $planned_order->composition_format('FLAT'),
    'Set composition to FLAT format' );
ok(
    my $composition = $planned_order->compose,
    'Called compose for FLAT composition'
);

ok(
    $planned_order->composition_format('STRUCTURED'),
    'Set composition to STRUCTURED format'
);
ok(
    $composition = $planned_order->compose,
    'Called compose for STRUCTURED composition'
);

#print Dumper ($composition);

#TODO: {
#    local $TODO = "Not yet implemented";
ok( $planned_order->composition_format('RAW'),
    'Set composition to RAW format' );
ok(
    $composition = $planned_order->compose,
    'Called compose for RAW composition'
);

#}

done_testing;

sub get_new_random_subject {
    my $action = 'RETRIEVE';
    my $ehr;
    while ( $action eq 'RETRIEVE' ) {
        my $subject_id = int( rand(10000000000) );
        $subject_id .= '0000000000';
        if ( $subject_id =~ /^([\d]{10,10}).*/ ) {
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

