use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Elements::LabTest::Professional;
diag( 'Testing OpenEHR::Composition::Elements::LabTest::Professional '
        . $OpenEHR::Composition::Elements::LabTest::Professional::VERSION );

note('Testing constuction with full parameters');
ok( my $professional1 = OpenEHR::Composition::Elements::LabTest::Professional->new(
        {   id       => 'AB01',
            assigner => 'Carecast',
            issuer   => 'UCLH',
            type     => 'local',
        }
    ),
    'Construct new professional object with full params'
);
is( $professional1->composition_format,
    'STRUCTURED', 'Default composition format inherited' );

is( $professional1->id,       'AB01',     'id set' );
is( $professional1->assigner, 'Carecast', 'assigner set' );
is( $professional1->issuer,   'UCLH',     'issuer set' );
is( $professional1->type,     'local',    'type set' );

note('Testing construction with minimum parameters');
ok( my $professional2 =
        OpenEHR::Composition::Elements::LabTest::Professional->new( { id => 'BF01', } ),
    'Construct new professional with id only'
);

is( $professional2->id,       'BF01',     'id set' );
is( $professional2->assigner, 'UCLH PAS', 'assigner set from default' );
is( $professional2->issuer,   'UCLH',     'issuer set from default' );
is( $professional2->type,     'local',    'type set from default' );

eval {
    my $professional3 = OpenEHR::Composition::Elements::LabTest::Professional->new();
};
ok( $@, 'Failed to construct professional with no parameters' );

ok( $professional1->composition_format('FLAT'),
    'Set composition format to FLAT' );
ok( my $flat = $professional1->compose, 'Called compose method' );
my $path =
    'laboratory_result_report/laboratory_test:__TEST__/test_request_details/requester/professional_identifier';

is( $flat->{ $path . '|issuer' },
    $professional1->issuer,
    'issuer set in FLAT format'
);
is( $flat->{ $path . '|type' },
    $professional1->type,
    'type set in FLAT format'
);
is( $flat->{ $path . '|assigner' },
    $professional1->assigner,
    'assigner set in FLAT format'
);
is( $flat->{$path}, $professional1->id, 'id set in FLAT format' );

ok( $professional1->composition_format('STRUCTURED'),
    'Set composition format to STRUCTURED'
);
ok( my $struct = $professional1->compose, 'Called compose method' );

is( $struct->{'|assigner'},
    $professional1->assigner, 'assigner set in STRUCTURED format' );
is( $struct->{'|issuer'}, $professional1->issuer,
    'issuer set in STRUCTURED format' );
is( $struct->{'|type'}, $professional1->type,
    'type set in STRUCTURED format' );
is( $struct->{'|id'}, $professional1->id, 'id set in STRUCTURED format' );

ok( $professional1->composition_format('RAW'),
    'Set composition format to RAW' );
ok( my $raw = $professional1->compose, 'Called compose method' );

is( $raw->{value}->{type}, $professional1->type, 'type set in RAW format' );
is( $raw->{value}->{id},   $professional1->id,   'id set in RAW format' );
is( $raw->{value}->{issuer},
    $professional1->issuer, 'issuer set in RAW format' );
is( $raw->{value}->{assigner},
    $professional1->assigner, 'assigner set in RAW format' );
is( $raw->{value}->{'@class'},
    'DV_IDENTIFIER', 'value class set in RAW format' );
is( $raw->{'@class'}, 'ELEMENT', 'class set in RAW format' );
is( $raw->{archetype_node_id},
    'at0011', 'archetype node id set in RAW format' );
is( $raw->{name}->{value},
    'Professional Identifier',
    'name value set in RAW format'
);
is( $raw->{name}->{'@class'}, 'DV_TEXT', 'name class set in RAW format' );

done_testing;
