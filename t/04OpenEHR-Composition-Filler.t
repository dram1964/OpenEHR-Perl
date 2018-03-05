use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Filler;

note('Testing constuction with full parameters');
ok( my $filler1 = OpenEHR::Composition::Filler->new(
        {   order_number => '17V333999',
            assigner     => 'Winpath',
            issuer       => 'UCLH Pathology',
            type         => 'local',
        }
    ),
    'Construct new filler object with full params'
);
is( $filler1->composition_format,
    'STRUCTURED', 'Default composition format inherited' );
is( $filler1->order_number, '17V333999',      'id set' );
is( $filler1->assigner,     'Winpath',        'assigner set' );
is( $filler1->issuer,       'UCLH Pathology', 'issuer set' );
is( $filler1->type,         'local',          'type set' );

note('Testing construction with minimum parameters');
ok( my $filler2 =
        OpenEHR::Composition::Filler->new( { order_number => '17V444888', } ),
    'Construct new filler with id only'
);
is( $filler2->order_number, '17V444888',      'id set' );
is( $filler2->assigner,     'Winpath',        'assigner set from default' );
is( $filler2->issuer,       'UCLH Pathology', 'issuer set from default' );
is( $filler2->type,         'local',          'type set from default' );

note('Testing construction with no parameters');
eval { my $filler3 = OpenEHR::Composition::Filler->new(); };
ok( $@, 'Failed to construct filler with no parameters' );

note('Testing FLAT compostion');
ok( $filler1->composition_format('FLAT'), 'Set composition format to FLAT' );
is( $filler1->composition_format, 'FLAT', 'FLAT format set' );

ok( my $flat = $filler1->compose, 'Called compose method' );
my $path =
    'laboratory_result_report/laboratory_test:__TEST__/test_request_details/filler_order_number';

is( $flat->{ $path . '|issuer' },
    $filler1->issuer,
    'issuer set in FLAT format'
);
is( $flat->{ $path . '|type' }, $filler1->type, 'type set in FLAT format' );
is( $flat->{ $path . '|assigner' },
    $filler1->assigner,
    'assigner set in FLAT format'
);
is( $flat->{$path}, $filler1->order_number,
    'order_number set in FLAT format' );

note('Testing STRUCTURED compostion');
ok( $filler1->composition_format('STRUCTURED'),
    'Set composition format to STRUCTURED'
);
ok( my $struct = $filler1->compose, 'Called compose method' );

is( $struct->{'|assigner'},
    $filler1->assigner, 'assigner set in STRUCTURED format' );
is( $struct->{'|issuer'}, $filler1->issuer,
    'issuer set in STRUCTURED format' );
is( $struct->{'|type'}, $filler1->type, 'type set in STRUCTURED format' );
is( $struct->{'|id'}, $filler1->order_number,
    'order_number set in STRUCTURED format' );

note('Testing RAW compostion');
ok( $filler1->composition_format('RAW'), 'Set composition format to RAW' );
ok( my $raw = $filler1->compose, 'Called compose method' );

is( $raw->{value}->{type}, $filler1->type,         'type set in RAW format' );
is( $raw->{value}->{id},   $filler1->order_number, 'id set in RAW format' );
is( $raw->{value}->{issuer}, $filler1->issuer, 'issuer set in RAW format' );
is( $raw->{value}->{assigner},
    $filler1->assigner, 'assigner set in RAW format' );
is( $raw->{value}->{'@class'},
    'DV_IDENTIFIER', 'value class set in RAW format' );
is( $raw->{'@class'}, 'ELEMENT', 'class set in RAW format' );
is( $raw->{archetype_node_id},
    'at0063', 'archetype node id set in RAW format' );
is( $raw->{name}->{value},
    'Filler order number',
    'name value set in RAW format'
);
is( $raw->{name}->{'@class'}, 'DV_TEXT', 'name class set in RAW format' );

done_testing;
