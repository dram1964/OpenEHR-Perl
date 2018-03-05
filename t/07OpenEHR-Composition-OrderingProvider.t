use strict;
use warnings;

use Test::More;
use Data::Dumper;
use OpenEHR::Composition::OrderingProvider;
diag('Testing OpenEHR::Composition::OrderingProvider '
    . $OpenEHR::Composition::OrderingProvider::VERSION);

ok( my $ordering = OpenEHR::Composition::OrderingProvider->new(
        given_name  => 'A&E',
        family_name => 'UCLH'
    ),
    'Constructor called with all parameters'
);

is( $ordering->given_name,  'A&E',  'Given name set' );
is( $ordering->family_name, 'UCLH', 'Family name set' );

is( $ordering->composition_format,
    'STRUCTURED', 'STRUCTURED composition format set by default' );
ok( $ordering->composition_format('FLAT'),
    'Request FLAT composition format' );
ok( my $flat = $ordering->compose, 'Request composition' );

my $path = 'laboratory_result_report/laboratory_test:__TEST__/' 
    . 'test_request_details/requester/ordering_provider/ordering_provider/';

is( $flat->{ $path . 'given_name' },
    $ordering->given_name,
    'Given name set in FLAT format'
);
is( $flat->{ $path . 'family_name' },
    $ordering->family_name,
    'Family name set in FLAT format'
);

ok( $ordering->composition_format('STRUCTURED'),
    'Request STRUCTURED composition format'
);
ok( my $struct = $ordering->compose, 'Request composition' );

is( $struct->{given_name}, $ordering->given_name,
    'Given name set in STRUCTURED format' );
is( $struct->{family_name},
    $ordering->family_name, 'Family name set in STRUCTURED format' );

ok( $ordering->composition_format('RAW'), 'Request RAW composition format' );
ok( my $raw = $ordering->compose, 'Request composition' );

is( $raw->{archetype_details}->{archetype_id}->{'@class'},
    'ARCHETYPE_ID', 'archetype_details class in RAW Format' );
is( $raw->{archetype_details}->{archetype_id}->{value},
    'openEHR-EHR-CLUSTER.person_name.v1',
    'archetype_details value in RAW Format'
);
is( $raw->{archetype_details}->{'@class'},
    'ARCHETYPED', 'archetype details class in RAW Format' );
is( $raw->{archetype_details}->{'rm_version'},
    '1.0.1', 'archetype details version in RAW Format' );
is( $raw->{'@class'}, 'CLUSTER', 'composition class in RAW Format' );
is( $raw->{name}->{'@class'},
    'DV_TEXT', 'composition name class in RAW Format' );
is( $raw->{name}->{'value'},
    'Ordering provider',
    'composition name value in RAW Format'
);
is( $raw->{'archetype_node_id'},
    'openEHR-EHR-CLUSTER.person_name.v1',
    'composition archetype node id in RAW Format'
);
is( $raw->{items}->[0]->{'archetype_node_id'},
    'at0002', 'item 0 archetype node id in RAW Format' );
is( $raw->{items}->[0]->{name}->{'@class'},
    'DV_TEXT', 'item 0 name class in RAW Format' );
is( $raw->{items}->[0]->{name}->{'value'},
    'Ordering provider',
    'item 0 name value in RAW Format'
);
is( $raw->{items}->[0]->{items}->[0]->{'@class'},
    'ELEMENT', 'given name node class in RAW Format' );
is( $raw->{items}->[0]->{items}->[0]->{'archetype_node_id'},
    'at0003', 'given name node id in RAW Format' );
is( $raw->{items}->[0]->{items}->[0]->{name}->{'@class'},
    'DV_TEXT', 'given name name class in RAW Format' );
is( $raw->{items}->[0]->{items}->[0]->{name}->{'value'},
    'Given name', 'given name name value in RAW Format' );
is( $raw->{items}->[0]->{items}->[0]->{value}->{'@class'},
    'DV_TEXT', 'given name value class in RAW Format' );
is( $raw->{items}->[0]->{items}->[0]->{value}->{'value'},
    $ordering->given_name, 'given name value value in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{'@class'},
    'ELEMENT', 'family name node class in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{'archetype_node_id'},
    'at0005', 'family name node id in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{name}->{'@class'},
    'DV_TEXT', 'family name name class in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{name}->{'value'},
    'Family name', 'family name name value in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{value}->{'@class'},
    'DV_TEXT', 'family name value class in RAW Format' );
is( $raw->{items}->[0]->{items}->[1]->{value}->{'value'},
    $ordering->family_name, 'family name value value in RAW Format' );

done_testing;
