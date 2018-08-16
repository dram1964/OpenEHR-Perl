use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::LabTest::Placer;
diag( 'Testing OpenEHR::Composition::LabTest::Placer '
        . $OpenEHR::Composition::LabTest::Placer::VERSION );

note('Testing constuction with full parameters');
ok( my $placer1 = OpenEHR::Composition::LabTest::Placer->new(
        {   order_number => 'TQ001113333',
            assigner     => 'TQuest',
            issuer       => 'UCLH',
            type         => 'local',
        }
    ),
    'Construct new placer object with full params'
);
is( $placer1->composition_format,
    'STRUCTURED', 'Default composition format inherited' );

is( $placer1->order_number, 'TQ001113333', 'id set' );
is( $placer1->assigner,     'TQuest',      'assigner set' );
is( $placer1->issuer,       'UCLH',        'issuer set' );
is( $placer1->type,         'local',       'type set' );

note('Testing construction with minimum parameters');
ok( my $placer2 = OpenEHR::Composition::LabTest::Placer->new(
        { order_number => 'TQ002222666', }
    ),
    'Construct new placer with id only'
);

is( $placer2->order_number, 'TQ002222666', 'id set' );
is( $placer2->assigner,     'TQuest',      'assigner set from default' );
is( $placer2->issuer,       'UCLH',        'issuer set from default' );
is( $placer2->type,         'local',       'type set from default' );

eval { my $placer3 = OpenEHR::Composition::LabTest::Placer->new(); };
ok( $@, 'Failed to construct placer with no parameters' );

ok( $placer1->composition_format('FLAT'), 'Set composition format to FLAT' );
is( $placer1->composition_format, 'FLAT', 'FLAT format set' );

ok( my $flat = $placer1->compose, 'Called compose method' );
my $path =
    'laboratory_result_report/laboratory_test:__TEST__/test_request_details/placer_order_number';

is( $flat->{ $path . '|issuer' },
    $placer1->issuer,
    'issuer set in FLAT format'
);
is( $flat->{ $path . '|type' }, $placer1->type, 'type set in FLAT format' );
is( $flat->{ $path . '|assigner' },
    $placer1->assigner,
    'assigner set in FLAT format'
);
is( $flat->{$path}, $placer1->order_number,
    'order_number set in FLAT format' );

ok( $placer1->composition_format('STRUCTURED'),
    'Set composition format to STRUCTURED'
);
ok( my $struct = $placer1->compose, 'Called compose method' );

is( $struct->{'|assigner'},
    $placer1->assigner, 'assigner set in STRUCTURED format' );
is( $struct->{'|issuer'}, $placer1->issuer,
    'issuer set in STRUCTURED format' );
is( $struct->{'|type'}, $placer1->type, 'type set in STRUCTURED format' );
is( $struct->{'|id'}, $placer1->order_number,
    'order_number set in STRUCTURED format' );

ok( $placer1->composition_format('RAW'), 'Set composition format to RAW' );
ok( my $raw = $placer1->compose, 'Called compose method' );

is( $raw->{value}->{type}, $placer1->type,         'type set in RAW format' );
is( $raw->{value}->{id},   $placer1->order_number, 'id set in RAW format' );
is( $raw->{value}->{issuer}, $placer1->issuer, 'issuer set in RAW format' );
is( $raw->{value}->{assigner},
    $placer1->assigner, 'assigner set in RAW format' );
is( $raw->{value}->{'@class'},
    'DV_IDENTIFIER', 'value class set in RAW format' );
is( $raw->{'@class'}, 'ELEMENT', 'class set in RAW format' );
is( $raw->{archetype_node_id},
    'at0062', 'archetype node id set in RAW format' );
is( $raw->{name}->{value},
    'Placer order number',
    'name value set in RAW format'
);
is( $raw->{name}->{'@class'}, 'DV_TEXT', 'name class set in RAW format' );

done_testing;
