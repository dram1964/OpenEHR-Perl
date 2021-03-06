use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::EHR;
use DateTime::Format::Pg;

BEGIN { use_ok('OpenEHR::Composition::InformationOrder'); }

my $ehr1 = &get_new_random_subject();
$ehr1->get_new_ehr;
if ( $ehr1->err_msg ) {
    die $ehr1->err_msg;
}
note( 'EhrId: ' . $ehr1->ehr_id );
note( 'SubjectId: ' . $ehr1->subject_id );

my $start_date  = DateTime::Format::Pg->parse_datetime('2011-01-01');
my $end_date    = DateTime::Format::Pg->parse_datetime('2018-01-01');
my $expiry_time = DateTime::Format::Pg->parse_datetime('2018-12-31');

my $planned_order;

{
ok(
    $planned_order = OpenEHR::Composition::InformationOrder->new(
        current_state         => 'planned',
        start_date            => $start_date,
        end_date              => $end_date,
        expiry_time           => $expiry_time,
        requestor_id          => '834y5jkdk-ssxhs',
        narrative             => 'Narrative associated with request',
        service_name          => 'OpenEHR Perl Testing',
        service_type          => 'pathology',
    ),
    'Constructor called'
);

note("Testing explicit attributes");
is( $planned_order->current_state, 'planned',    'current_state accessor' );
is( $planned_order->start_date,    $start_date,  'start_date accessor' );
is( $planned_order->end_date,      $end_date,    'end_date accessor' );
is( $planned_order->expiry_time,   $expiry_time, 'expiry_time accessor' );
is( $planned_order->narrative, 'Narrative associated with request', 'narrative accessor');
is( $planned_order->service_type,  'pathology', 'service_type accessor' );
is(
    $planned_order->service_name,
    'OpenEHR Perl Testing',
    'service_name accessor'
);

note("Testing default attribute accessors");
isa_ok( $planned_order->timing, 'DateTime',      'timing defaults to DateTime object' );
is( $planned_order->composer_name, 'OpenEHR-Perl',      'composer_name accessor' );
is( $planned_order->facility_id,   'RRV',       'facility_id accessor' );
is(
    $planned_order->facility_name,
    'UCLH NHS Foundation Trust',
    'facility_name accessor'
);
is( $planned_order->id_scheme,     'UCLH-NS', 'id_scheme accessor' );
is( $planned_order->id_namespace,  'UCLH-NS',     'id_namespace accessor' );
is( $planned_order->language_code, 'en',          'language accessor' );
is( $planned_order->language_terminology,
    'ISO_639-1', 'language_code accessor' );
is( $planned_order->encoding_code, 'UTF-8',     'encoding_code accessor' );
is( $planned_order->encoding_terminology,
    'IANA_character-sets', 'encoding_terminology accessor' );
is( $planned_order->requestor_id, '834y5jkdk-ssxhs', 'requestor_id accessor' );
is( $planned_order->territory_code, 'GB', 'territory_code accessor' );
is( $planned_order->territory_terminology,
    'ISO_3166-1', 'territory_terminology accessor' );
}

{
ok(
    $planned_order = OpenEHR::Composition::InformationOrder->new(
        current_state         => 'planned',
        start_date            => $start_date,
        end_date              => $end_date,
        expiry_time           => $expiry_time,
        composer_name         => 'GENIE',
        facility_id           => 'GOSH',
        facility_name         => 'Great Ormond Street',
        id_scheme             => 'GOSH-SCHEME',
        id_namespace          => 'GOSH-NS',
        language_code         => 'es',
        language_terminology  => 'ISO_639-2',
        service_name          => 'GEL Information data request',
        service_type          => 'pathology',
        encoding_code         => 'UTF-9',
        encoding_terminology  => 'IANA_charsets',
        narrative             => 'GEL pathology data request',
        requestor_id          => '834y5jkdk-ssxhs',
        territory_code        => 'ES',
        territory_terminology => 'ISO_3166-2',
    ),
    'Constructor called'
);

note("Testing attribute accessors");
is( $planned_order->current_state, 'planned',    'current_state accessor' );
is( $planned_order->start_date,    $start_date,  'start_date accessor' );
is( $planned_order->end_date,      $end_date,    'end_date accessor' );
isa_ok( $planned_order->timing,        'DateTime',      'timing defaults to DateTime object' );
is( $planned_order->expiry_time,   $expiry_time, 'expiry_time accessor' );
is( $planned_order->composer_name, 'GENIE',      'composer_name accessor' );
is( $planned_order->facility_id,   'GOSH',       'facility_id accessor' );
is(
    $planned_order->facility_name,
    'Great Ormond Street',
    'facility_name accessor'
);
is( $planned_order->id_scheme,     'GOSH-SCHEME', 'id_scheme accessor' );
is( $planned_order->id_namespace,  'GOSH-NS',     'id_namespace accessor' );
is( $planned_order->language_code, 'es',          'language accessor' );
is( $planned_order->language_terminology,
    'ISO_639-2', 'language_code accessor' );
is(
    $planned_order->service_name,
    'GEL Information data request',
    'service_name accessor'
);
is( $planned_order->service_type,  'pathology', 'service_type accessor' );
is( $planned_order->encoding_code, 'UTF-9',     'encoding_code accessor' );
is( $planned_order->encoding_terminology,
    'IANA_charsets', 'encoding_terminology accessor' );
is(
    $planned_order->narrative,
    'GEL pathology data request',
    'narrative accessor'
);
is( $planned_order->requestor_id, '834y5jkdk-ssxhs', 'requestor_id accessor' );
is( $planned_order->territory_code, 'ES', 'territory_code accessor' );
is( $planned_order->territory_terminology,
    'ISO_3166-2', 'territory_terminology accessor' );
}

note('Testing composition format reflected in composer_name');
$planned_order->composer_name('OpenEHR-Perl');

ok( $planned_order->composition_format('FLAT'),
    'Set composition to FLAT format' );
ok(
    my $composition = $planned_order->compose,
    'Called compose for FLAT composition'
);
is( $planned_order->composer_name, 'OpenEHR-Perl-FLAT', 
    'Added "-FLAT" to composer_name');

ok(
    $planned_order->composition_format('STRUCTURED'),
    'Set composition to STRUCTURED format'
);
ok(
    $composition = $planned_order->compose,
    'Called compose for STRUCTURED composition'
);
is( $planned_order->composer_name, 'OpenEHR-Perl-STRUCTURED', 
    'Added "-STRUCTURED" to composer_name');


ok( $planned_order->composition_format('RAW'),
    'Set composition to RAW format' );
ok(
    $composition = $planned_order->compose,
    'Called compose for RAW composition'
);
is( $planned_order->composer_name, 'OpenEHR-Perl-RAW', 
    'Added "-RAW" to composer_name');



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

