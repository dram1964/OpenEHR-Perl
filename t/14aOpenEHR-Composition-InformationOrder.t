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
        composer_name      => 'GENIE',
        facility_id   => 'GOSH',
        facility_name => 'Great Ormond Street',
        id_scheme => 'GOSH-SCHEME',
        id_namespace => 'GOSH-NS',
        language_code => 'es',
        language_terminology => 'ISO_639-2',
        service_name => 'GEL Information data request',
        service_type => 'pathology',
        encoding_code => 'UTF-9',
        encoding_terminology => 'IANA_charsets',
        narrative => 'GEL pathology data request',
        requestor_id => '834y5jkdk-ssxhs',
        territory_code => 'ES',
        territory_terminology => 'ISO_3166-2',
    ), 'Constructor called'
);

diag("Testing attribute accessors");
is( $planned_order->current_state, 'planned', 'current_state accessor' );
is( $planned_order->start_date, $start_date, 'start_date accessor' );
is( $planned_order->end_date, $end_date, 'end_date accessor' );
is( $planned_order->timing, $timing, 'timing accessor' );
is( $planned_order->expiry_time, $expiry_time, 'expiry_time accessor' );
is( $planned_order->composer_name, 'GENIE', 'composer accessor' );
is( $planned_order->facility_id, 'GOSH', 'facility_id accessor' );
is( $planned_order->facility_name, 'Great Ormond Street', 'facility_name accessor' );
is( $planned_order->id_scheme, 'GOSH-SCHEME', 'id_scheme accessor' );
is( $planned_order->id_namespace, 'GOSH-NS', 'id_namespace accessor' );
is( $planned_order->language_code, 'es', 'language accessor' );
is( $planned_order->language_terminology, 'ISO_639-2', 'language_code accessor' );
is( $planned_order->service_name, 'GEL Information data request', 'service_name accessor' );
is( $planned_order->service_type, 'pathology', 'service_type accessor' );
is( $planned_order->encoding_code, 'UTF-9', 'encoding_code accessor' );
is( $planned_order->encoding_terminology, 'IANA_charsets', 'encoding_terminology accessor' );
is( $planned_order->narrative, 'GEL pathology data request', 'narrative accessor' );
is( $planned_order->requestor_id, '834y5jkdk-ssxhs', 'requestor_id accessor' );
is( $planned_order->territory_code, 'ES', 'territory_code accessor' );
is( $planned_order->territory_terminology, 'ISO_3166-2', 'territory_terminology accessor' );


TODO: {
    local $TODO = "Not yet implemented";
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

    ok( $planned_order->composition_format('RAW'),
        'Set composition to RAW format' );
    ok(
        $composition = $planned_order->compose,
        'Called compose for RAW composition'
    );

};

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

