use strict;
use warnings;

use Test::More;
use Data::Dumper;

use OpenEHR::Composition::Elements::LabTest::LabResult;
diag( 'Testing OpenEHR::Composition::Elements::LabTest::LabResult '
      . $OpenEHR::Composition::Elements::LabTest::LabResult::VERSION );

note('Testing constructor with result value text');
ok(
    my $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new(
        result_value => '59
See http://biochem.org for interpretation guidelines',
        range_low     => '50',
        range_high    => '60',
        testname      => 'ALB',
        testcode      => 'ALB',
        unit          => 'g/L',
        result_status => 'Final',
        result_mapping       => [
            {
                code        => '14569-8',
                terminology => 'LOINC',
            },
            {
                code        => '35338',
                terminology => 'GEL',
            }
        ],

    ),
    'Construct new lab test object'
);

is( $labtest->composition_format,
    'STRUCTURED', 'STRUCTURED composition format inherited' );
is( $labtest->magnitude, 59, 'Result Value' );
is(
    $labtest->comment,
    'See http://biochem.org for interpretation guidelines',
    'Result comment'
);
is( $labtest->ref_range,       '50 - 60', 'Ref Range' );
is( $labtest->status->{code},  'at0009',  'Status Code' );
is( $labtest->status->{value}, 'Final',   'Status Value' );

note('Testing FLAT composition');
my $path = 'laboratory_result_report/laboratory_test:__TEST__/'
  . 'laboratory_test_panel:__PANEL__/laboratory_result:__RESULT__/';
ok( $labtest->composition_format('FLAT'), 'Request Structured format' );
ok( my $flat = $labtest->compose(), 'Compose called' );
if ( $labtest->magnitude ) {
    is( $flat->{ $path . 'result_value/quantity_value|magnitude' },
        $labtest->magnitude, 'result_value magnitude Flat format' );
    is(
        $flat->{ $path . 'result_value/quantity_value|magnitude_status' },
        $labtest->magnitude_status,
        'result_value magnitude status Flat format'
    );
    is( $flat->{ $path . 'result_value/quantity_value|unit' },
        $labtest->unit, 'result_value unit Flat format' );
}
elsif ( $labtest->result_text ) {
    is( $flat->{ $path . 'result_value/value' },
        $labtest->result_text, 'result_value Flat format' );
}
is( $flat->{ $path . 'reference_range_guidance' },
    $labtest->ref_range, 'ref range flat format' );
is( $flat->{ $path . 'comment' }, $labtest->comment, 'comment Flat format' );
is( $flat->{ $path . 'result_value/_name|value' },
    $labtest->testname, 'testname in flat format' );
is( $flat->{ $path . 'result_value/_name|code' },
    $labtest->testcode, 'testcode in flat format' );
is(
    $flat->{ $path . 'result_value/_name|terminology' },
    $labtest->testcode_terminology,
    'testcode terminology in flat format'
);
is( $flat->{ $path . 'result_value/_name/_mapping:0/target|code' },
    '14569-8', 'first mapping code' );
is( $flat->{ $path . 'result_value/_name/_mapping:0/target|terminology' },
    'LOINC', 'first mapping terminology' );
is( $flat->{ $path . 'result_value/_name/_mapping:0|match' },
    '=', 'first mapping match' );
is( $flat->{ $path . 'result_value/_name/_mapping:1/target|code' },
    '35338', 'second mapping code' );
is( $flat->{ $path . 'result_value/_name/_mapping:1/target|terminology' },
    'GEL', 'second mapping terminology' );
is( $flat->{ $path . 'result_value/_name/_mapping:1|match' },
    '=', 'second mapping match' );
is( $flat->{ $path . 'result_value/quantity_value|unit' },
    'g/L', 'unit in flat format' );
is(
    $flat->{ $path
          . 'result_value/quantity_value/_normal_range/lower|magnitude' },
    '50',
    'range_low in flat format'
);
is( $flat->{ $path . 'result_value/quantity_value/_normal_range/lower|unit' },
    'g/L', 'range_low unit in flat format' );
is(
    $flat->{ $path
          . 'result_value/quantity_value/_normal_range/upper|magnitude' },
    '60',
    'range_high in flat format'
);
is( $flat->{ $path . 'result_value/quantity_value/_normal_range/upper|unit' },
    'g/L', 'range_high unit in flat format' );

note('Testing STRUCTURED composition');
ok( $labtest->composition_format('STRUCTURED'), 'Request Structured format' );
ok( my $struct = $labtest->compose(), 'Compose called' );
is( $struct->{reference_range_guidance}->[0],
    $labtest->ref_range, 'ref_range in structured format' );
is( $struct->{comment}->[0],
    $labtest->comment, 'comment in structured format' );
is( $struct->{result_value}->[0]->{'_name'}->[0]->{'|code'},
    $labtest->testcode, 'testcode in structured format' );
is( $struct->{result_value}->[0]->{'_name'}->[0]->{'|value'},
    $labtest->testname, 'testname in structured format' );
is(
    $struct->{result_value}->[0]->{'_name'}->[0]->{'|terminology'},
    $labtest->testcode_terminology,
    'testcode terminology in structured format'
);

if ( $labtest->result_text ) {
    is( $struct->{result_value}->[0]->{'text_value'}->[0],
        $labtest->result_text, 'result value in structured format' );
}
elsif ( $labtest->magnitude ) {
    my $value2 = $struct->{result_value}->[0]->{'quantity_value'};
    is( $value2->[0]->{'magnitude'},
        $labtest->magnitude, 'result magnitude in structured format' );
    is(
        $value2->[0]->{'magnitude_status'},
        $labtest->magnitude_status,
        'result qualifier in structured format'
    );
    is( $value2->[0]->{'unit'},
        $labtest->unit, 'result units in structured format' );
    is( $value2->[0]->{'normal_status'},
        $labtest->normal_flag, 'result flag in structured format' );
}
is(
    $struct->{result_status}->[0]->{'|value'},
    $labtest->status->{value},
    'result status value in structured format'
);
is(
    $struct->{result_status}->[0]->{'|code'},
    $labtest->status->{code},
    'result status code in structured format'
);
is(
    $struct->{result_status}->[0]->{'|terminology'},
    $labtest->status->{terminology},
    'result status code in structured format'
);

note('Testing RAW composition');
ok( $labtest->composition_format('RAW'), 'Request Structured format' );
ok( my $raw = $labtest->compose(), 'Compose called' );
is( $raw->{'@class'}, 'CLUSTER', 'RAW result composition class' );
is( $raw->{name}->{value}, 'Laboratory result', 'RAW result composition name' );
is( $raw->{archetype_node_id}, 'at0002', 'RAW result archetype node id' );
my $items = $raw->{items};

for my $item ( @{$items} ) {
    if ( $item->{archetype_node_id} eq 'at0001' ) {
        note('Processing result');
        is( $item->{value}->{value},
            $labtest->result_text, 'RAW result value' );
        is( $item->{name}->{value}, $labtest->testname, 'RAW testname' );
        is( $item->{name}->{defining_code}->{code_string},
            $labtest->testcode, 'RAW testcode' );
        my $mappings = $item->{name}->{mappings};
        is( $mappings->[0]->{target}->{code_string},
            '14569-8', 'RAW testcode mapping' );
        is( $mappings->[0]->{target}->{terminology_id}->{value},
            'LOINC', 'RAW testcode mapping terminology' );
        is( $mappings->[0]->{match}, '=', 'RAW testcode mapping operator' );
        is( $mappings->[1]->{target}->{code_string},
            '35338', 'RAW testcode mapping' );
        is( $mappings->[1]->{target}->{terminology_id}->{value},
            'GEL', 'RAW testcode mapping terminology' );
        is( $mappings->[1]->{match}, '=', 'RAW testcode mapping operator' );
    }
    elsif ( $item->{archetype_node_id} eq 'at0003' ) {
        note('Processing result comment');
        is( $item->{name}->{value}, 'Comment', 'RAW result comment name' );
        is( $item->{value}->{value},
            $labtest->comment, 'RAW result comment value' );
    }
    elsif ( $item->{archetype_node_id} eq 'at0004' ) {
        note('Processing result ref range');
        is(
            $item->{name}->{value},
            'Reference range guidance',
            'RAW result ref_range name'
        );
        is( $item->{value}->{value},
            $labtest->ref_range, 'RAW result ref_range value' );
    }
    elsif ( $item->{archetype_node_id} eq 'at0005' ) {
        note('Processing result status');
        is( $item->{name}->{value}, 'Result status', 'RAW result status name' );
        is(
            $item->{value}->{value},
            $labtest->status->{value},
            'RAW result status value'
        );
        is(
            $item->{value}->{defining_code}->{code_string},
            $labtest->status->{code},
            'RAW result status code'
        );
    }
}

done_testing;
