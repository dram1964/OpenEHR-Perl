use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Professional;
use OpenEHR::Composition::OrderingProvider;
use OpenEHR::Composition::Requester;

ok( my $ordering_provider = OpenEHR::Composition::OrderingProvider->new(
        given_name  => 'A&E',
        family_name => 'UCLH'
    ),
    'Ordering Provider constructued'
);

ok( my $professional = OpenEHR::Composition::Professional->new(
        {   id       => 'AB01',
            assigner => 'Carecast',
            issuer   => 'UCLH',
            type     => 'local',
        }
    ),
    'Professional constructed'
);

ok( my $requester1 = OpenEHR::Composition::Requester->new(),
    'Constructor called with no parameters' );

ok( $requester1->ordering_provider($ordering_provider),
    'Ordering Provider added to requestor' );
is( $requester1->ordering_provider->given_name,
    $ordering_provider->given_name,
    'Given name accessible from requestor'
);
is( $requester1->ordering_provider->family_name,
    $ordering_provider->family_name,
    'Family name accessible from requestor'
);
ok( $requester1->professional($professional),
    'Professional added to requestor'
);
is( $requester1->professional->id,
    $professional->id, 'Professional id accessible from requester' );
is( $requester1->professional->assigner,
    $professional->assigner,
    'Professional assigner accessible from requester' );
is( $requester1->professional->issuer,
    $professional->issuer, 'Professional issuer accessible from requester' );
is( $requester1->professional->type,
    $professional->type, 'Professional type accessible from requester' );

ok( my $requester2 = OpenEHR::Composition::Requester->new(
        ordering_provider => $ordering_provider,
        professional      => $professional,
    ),
    'Constructor called with ordering and professional objects'
);

is( $requester2->ordering_provider->given_name,
    $ordering_provider->given_name,
    'Given name accessible from requestor'
);
is( $requester2->ordering_provider->family_name,
    $ordering_provider->family_name,
    'Family name accessible from requestor'
);
is( $requester2->professional->id,
    $professional->id, 'Professional id accessible from requester' );
is( $requester2->professional->assigner,
    $professional->assigner,
    'Professional assigner accessible from requester' );
is( $requester2->professional->issuer,
    $professional->issuer, 'Professional issuer accessible from requester' );
is( $requester2->professional->type,
    $professional->type, 'Professional type accessible from requester' );

ok( $requester1->composition_format('FLAT'), 'Request FLAT format' );
ok( my $requester_flat = $requester1->compose, 'Called compose' );

my $path = 'laboratory_result_report/laboratory_test:__TEST__/'
    . 'test_request_details/requester/';

is( $requester_flat->{ $path . 'professional_identifier' },
    'AB01', 'Flat path for professional id' );
is( $requester_flat->{ $path . 'professional_identifier|issuer' },
    'UCLH', 'Flat path for professional issuer' );
is( $requester_flat->{ $path . 'professional_identifier|type' },
    'local', 'Flat path for professional type' );
is( $requester_flat->{ $path . 'professional_identifier|assigner' },
    'Carecast', 'Flat path for professional assigner' );
is( $requester_flat->{ $path
            . 'ordering_provider/ordering_provider/family_name' },
    'UCLH',
    'Flat path for ordering provider family name'
);
is( $requester_flat->{ $path
            . 'ordering_provider/ordering_provider/given_name' },
    'A&E',
    'Flat path for ordering provider given name'
);

ok( $requester1->composition_format('STRUCTURED'),
    'Request STRUCTURED format' );
ok( my $requester_struct = $requester1->compose, 'Called compose' );

is( $requester_struct->[0]->{professional_identifier}->[0]->{'|id'},
    'AB01', 'Structured path for professional id' );
is( $requester_struct->[0]->{professional_identifier}->[0]->{'|issuer'},
    'UCLH', 'Structured path for professional issuer' );
is( $requester_struct->[0]->{professional_identifier}->[0]->{'|type'},
    'local', 'Structured path for professional type' );
is( $requester_struct->[0]->{professional_identifier}->[0]->{'|assigner'},
    'Carecast', 'Structured path for professional assigner' );
is( $requester_struct->[0]->{ordering_provider}->[0]->{ordering_provider}
        ->[0]->{'family_name'},
    'UCLH', 'Structured path for ordering provider family name'
);
is( $requester_struct->[0]->{ordering_provider}->[0]->{ordering_provider}
        ->[0]->{'given_name'},
    'A&E', 'Structured path for ordering provider given name'
);

ok( $requester1->composition_format('RAW'), 'Request RAW format' );
ok( my $requester_raw = $requester1->compose, 'Called compose' );

is( $requester_raw->{'@class'}, 'CLUSTER', 'RAW composition class' );
is( $requester_raw->{'archetype_node_id'},
    'openEHR-EHR-CLUSTER.individual_professional.v1',
    'RAW composition archetype node id'
);
is( $requester_raw->{name}->{value},
    'Requester', 'RAW composition name value' );
is( $requester_raw->{name}->{'@class'},
    'DV_TEXT', 'RAW composition name class' );
is( $requester_raw->{archetype_details}->{'@class'},
    'ARCHETYPED', 'RAW composition archetype_details class' );
is( $requester_raw->{archetype_details}->{'rm_version'},
    '1.0.1', 'RAW composition archetype_details class' );
is( $requester_raw->{archetype_details}->{archetype_id}->{'@class'},
    'ARCHETYPE_ID', 'RAW composition archetype_details archetype id class' );
is( $requester_raw->{archetype_details}->{archetype_id}->{'value'},
    'openEHR-EHR-CLUSTER.individual_professional.v1',
    'RAW composition archetype_details archetype id value'
);

for my $item ( @{ $requester_raw->{items} } ) {
    if ( $item->{archetype_node_id} eq 'at0011' ) {
        note('Testing Professional Item');
        is( $item->{'@class'}, 'ELEMENT', 'Professional identifer' );
        is( $item->{name}->{value},
            'Professional Identifier',
            'Professional name value'
        );
        is( $item->{name}->{'@class'}, 'DV_TEXT', 'Professional name class' );
        is( $item->{value}->{type},    'local',   'Professional value type' );
        is( $item->{value}->{'@class'},
            'DV_IDENTIFIER', 'Professional value class' );
        is( $item->{value}->{id},     'AB01', 'Professional value id' );
        is( $item->{value}->{issuer}, 'UCLH', 'Professional value issuer' );
        is( $item->{value}->{assigner},
            'Carecast', 'Professional value assigner' );
    }
    elsif (
        $item->{archetype_node_id} eq 'openEHR-EHR-CLUSTER.person_name.v1' )
    {
        note('Testing Ordering Provider element');
        is( $item->{'@class'}, 'CLUSTER', 'Ordering Provider class' );
        is( $item->{archetype_details}->{'@class'},
            'ARCHETYPED', 'Ordering archetype class' );
        is( $item->{archetype_details}->{'rm_version'},
            '1.0.1', 'Ordering archetype rm_version' );
        is( $item->{archetype_details}->{'archetype_id'}->{value},
            'openEHR-EHR-CLUSTER.person_name.v1',
            'Ordering archetype archetype_id value'
        );
        is( $item->{archetype_details}->{'archetype_id'}->{'@class'},
            'ARCHETYPE_ID', 'Ordering archetype archetype_id class' );
        is( $item->{name}->{'value'},
            'Ordering provider',
            'Ordering name value'
        );
        is( $item->{name}->{'@class'}, 'DV_TEXT', 'Ordering name class' );
        my $ordering = $item->{items}->[0];
        is( $ordering->{'@class'}, 'CLUSTER', 'Ordering items class' );
        is( $ordering->{name}->{value},
            'Ordering provider',
            'Ordering items name'
        );
        is( $ordering->{name}->{'@class'}, 'DV_TEXT',
            'Ordering items class' );
        is( $ordering->{archetype_node_id},
            'at0002', 'Ordering item node id' );

        for my $node ( @{ $ordering->{items} } ) {
            if ( $node->{archetype_node_id} eq 'at0003' ) {
                note('testing given name');
                is( $node->{'@class'}, 'ELEMENT', 'Given name class' );
                is( $node->{value}->{'@class'},
                    'DV_TEXT', 'Given name value class' );
                is( $node->{value}->{'value'},
                    'A&E', 'Given name value value' );
                is( $node->{name}->{'@class'},
                    'DV_TEXT', 'Given name value class' );
                is( $node->{name}->{'value'},
                    'Given name',
                    'Given name value value'
                );
            }
            elsif ( $node->{archetype_node_id} eq 'at0005' ) {
                note('testing family name');
                is( $node->{'@class'}, 'ELEMENT', 'Family name class' );
                is( $node->{value}->{'@class'},
                    'DV_TEXT', 'Family name value class' );
                is( $node->{value}->{'value'},
                    'UCLH', 'Family name value value' );
                is( $node->{name}->{'@class'},
                    'DV_TEXT', 'Family name value class' );
                is( $node->{name}->{'value'},
                    'Family name',
                    'Family name value value'
                );
            }
            else {
                diag( Dumper 'Unexpected node in ordering items', $node );
            }
        }
    }
    else {
        diag( Dumper 'Unexpected item: ', $item );
    }
}

done_testing;
