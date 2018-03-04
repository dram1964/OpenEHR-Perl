use strict;
use warnings;

use Test::More;
use DateTime;

use OpenEHR::Composition::Specimen;


ok(my $specimen = OpenEHR::Composition::Specimen->new(
    specimen_type => 'Blood',
    datetime_collected => DateTime->new(year => 2017, month => 11, day => 20, hour => 14, minute => 31),
    collection_method   => 'Phlebotomy',
    datetime_received   => DateTime->new(year => 2017, month => 11, day => 20, hour => 15, minute => 21),
    spec_id             => 'bld',
), 'Specimen constructor');


is($specimen->specimen_type, 'Blood', 'Specimen Type accessor');
is($specimen->datetime_collected->ymd, '2017-11-20', 'Specimen collect date');
is($specimen->datetime_collected->hms, '14:31:00', 'Specimen collect time');
is($specimen->collection_method, 'Phlebotomy', 'Specimen collection method');
is($specimen->datetime_received->ymd, '2017-11-20', 'Specimen receive date');
is($specimen->datetime_received->hms, '15:21:00', 'Specimen receive time');
is($specimen->spec_id, 'bld', 'Specimen id');
is($specimen->spec_issuer, 'UCLH Pathology', 'Default specimen id issuer');
is($specimen->spec_assigner, 'Winpath', 'Default specimen id assigner');
is($specimen->spec_type, 'local', 'Default specimen id type');

ok($specimen->composition_format('FLAT'), 'Set composition format to FLAT');
ok(my $flat = $specimen->compose, 'Called compose');
my $path = 'laboratory_result_report/laboratory_test:__TEST__/specimen:__SPEC__/';
is($flat->{$path . 'specimen_type'}, $specimen->specimen_type, 'specimen_type in FLAT format');
is($flat->{$path . 'datetime_collected'}, $specimen->datetime_collected, 'datetime_collected in FLAT format');
is($flat->{$path . 'collection_method'}, $specimen->collection_method, 'collection_method in FLAT format');
is($flat->{$path . 'processing/datetime_received'}, $specimen->datetime_received, 'processing/datetime_received in FLAT format');
is($flat->{$path . 'processing/laboratory_specimen_identifier'}, $specimen->spec_id, 'laboratory_specimen_identifier in FLAT format');
is($flat->{$path . 'processing/laboratory_specimen_identifier|issuer'}, $specimen->spec_issuer, 'laboratory_specimen_identifier|issuer in FLAT format');
is($flat->{$path . 'processing/laboratory_specimen_identifier|assigner'}, $specimen->spec_assigner, 'laboratory_specimen_identifier|assigner in FLAT format');
is($flat->{$path . 'processing/laboratory_specimen_identifier|type'}, $specimen->spec_type, 'laboratory_specimen_identifier|type in FLAT format');

ok($specimen->composition_format('STRUCTURED'), 'Set composition format to STRUCTURED');
ok(my $struct = $specimen->compose, 'Called compose');

is($struct->{collection_method}->[0], $specimen->collection_method, 'collection_method in STRUCTURED format');
is($struct->{datetime_collected}->[0], $specimen->datetime_collected, 'datetime_collected in STRUCTURED format');
is($struct->{specimen_type}->[0], $specimen->specimen_type, 'specimen_type in STRUCTURED format');
is($struct->{processing}->[0]->{datetime_received}->[0], $specimen->datetime_received, 'datetime_received in STRUCTURED format');
is($struct->{processing}->[0]->{laboratory_specimen_identifier}->[0]->{'|id'}, $specimen->spec_id, 'spec id in STRUCTURED format');
is($struct->{processing}->[0]->{laboratory_specimen_identifier}->[0]->{'|issuer'}, $specimen->spec_issuer, 'spec id issuer in STRUCTURED format');
is($struct->{processing}->[0]->{laboratory_specimen_identifier}->[0]->{'|assigner'}, $specimen->spec_assigner, 'spec id assigner in STRUCTURED format');
is($struct->{processing}->[0]->{laboratory_specimen_identifier}->[0]->{'|type'}, $specimen->spec_type, 'spec id type in STRUCTURED format');

ok($specimen->composition_format('RAW'), 'Set composition format to RAW');
ok(my $raw = $specimen->compose, 'Called compose');
is($raw->{archetype_node_id}, 'openEHR-EHR-CLUSTER.specimen.v0', 'archetype_node_id RAW format');
is($raw->{'@class'}, 'CLUSTER', 'composition class RAW format');
is($raw->{name}->{value}, 'Specimen', 'name value RAW format');
is($raw->{name}->{'@class'}, 'DV_TEXT', 'name class RAW format');
is($raw->{archetype_details}->{rm_version}, '1.0.1', 'archetype details rm version RAW format');
is($raw->{archetype_details}->{'@class'}, 'ARCHETYPED', 'archetype details class RAW format');
is($raw->{archetype_details}->{archetype_id}->{value}, 'openEHR-EHR-CLUSTER.specimen.v0', 'archetype details archetype id value RAW format');
is($raw->{archetype_details}->{archetype_id}->{'@class'}, 'ARCHETYPE_ID', 'archetype details archetype id class RAW format');

my @items = @{$raw->{items}};

for my $item (@items) {
    if ($item->{archetype_node_id} eq 'at0029') {
        note('Processing Specimen Type item');
        is($item->{'@class'}, 'ELEMENT', 'Specimen type class');
        is($item->{name}->{value}, 'Specimen type', 'Specimen type name value');
        is($item->{name}->{'@class'}, 'DV_TEXT', 'Specimen type name class');
        is($item->{value}->{value}, $specimen->specimen_type, 'Specimen type value value');
        is($item->{value}->{'@class'}, 'DV_TEXT', 'Specimen type value class');
    }
    elsif ($item->{archetype_node_id} eq 'at0015') {
        note('Processing DateTime Collected item');
        is($item->{'@class'}, 'ELEMENT', 'Datetime collected class');
        is($item->{name}->{value}, 'Datetime collected', 'Datetime collected name value');
        is($item->{name}->{'@class'}, 'DV_TEXT', 'Datetime collected name class');
        is($item->{value}->{value}, $specimen->datetime_collected->datetime, 'Datetime collected value value');
        is($item->{value}->{'@class'}, 'DV_DATE_TIME', 'Datetime collected value class');
    }
    elsif ($item->{archetype_node_id} eq 'at0007') {
        note('Processing Collection Method item');
        is($item->{'@class'}, 'ELEMENT', 'Collection method class');
        is($item->{name}->{value}, 'Collection method', 'Collection method name value');
        is($item->{name}->{'@class'}, 'DV_TEXT', 'Collection method name class');
        is($item->{value}->{value}, $specimen->collection_method, 'Collection method value value');
        is($item->{value}->{'@class'}, 'DV_TEXT', 'Collection method value class');
    }
    elsif ($item->{archetype_node_id} eq 'at0046') {
        note('Processing Processing items');
        is($item->{'@class'}, 'CLUSTER', 'Collection method class');
        is($item->{name}->{value}, 'Processing', 'Collection method name value');
        is($item->{name}->{'@class'}, 'DV_TEXT', 'Collection method name class');
        for my $processing_item (@{$item->{items}}) {
            if ($processing_item->{archetype_node_id} eq 'at0034') {
                note('Processing Datetime Received item');
                my $dt = $processing_item;
                is($dt->{'@class'}, 'ELEMENT', 'Receive Date class');
                is($dt->{name}->{value}, 'Datetime received', 'Receive Date name value');
                is($dt->{name}->{'@class'}, 'DV_TEXT', 'Receive Date name class');
                is($dt->{value}->{value}, $specimen->datetime_received->datetime, 'Receive Date value value');
                is($dt->{value}->{'@class'}, 'DV_DATE_TIME', 'Receive Date value class');
            }
            elsif ($processing_item->{archetype_node_id} eq 'at0001') {
                note('Processing Specimen Identifier item');
                my $si = $processing_item;
                is($si->{'@class'}, 'ELEMENT', 'Specimen Id class');
                is($si->{name}->{value}, 'Laboratory specimen identifier', 'Specimen Id name value');
                is($si->{name}->{'@class'}, 'DV_TEXT', 'Specimen Id name class');
                is($si->{value}->{'@class'}, 'DV_IDENTIFIER', 'Specimen Id value class');
                is($si->{value}->{id}, $specimen->spec_id, 'Specimen Id value id');
                is($si->{value}->{assigner}, $specimen->spec_assigner, 'Specimen Id value assigner');
                is($si->{value}->{issuer}, $specimen->spec_issuer, 'Specimen Id value issuer');
                is($si->{value}->{type}, $specimen->spec_type, 'Specimen Id value type');
            }
        }
    }
}


done_testing;
