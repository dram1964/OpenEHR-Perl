use strict;
use warnings;
use Genomes_100K::Model;
use Test::More;
use OpenEHR::Composition::Elements::LabTest;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomesTest');

my $lab_results_rs = $schema->resultset('PathologyResult')->search(
    {lab_number => '98U900001'} 
);

while ( my $result = $lab_results_rs->next ) {
    if ( $result->test_code eq 'GFR' ) {

        my $data = {
                  'testcode' => $result->test_code,
                  'testname' => $result->test_code,
                  'range_high' => $result->range_high,
                  'unit' => $result->units,
                  'range_low' => $result->range_low,
                  'result_value' => $result->result,
        };
        print Dumper $data;

        ok( my $labtest = OpenEHR::Composition::Elements::LabTest::LabResult->new( $data, ),
            'construct new lab test object with numeric GFR result'
        );
        is( $labtest->magnitude, '25', 'magnitude set properly');
        is( $labtest->comment, 'Units: mL/min/1.73sqm
Multiply eGFR by 1.21 for people of African
Caribbean origin. Interpret with regard to UK CKD
guidelines: www.renal.org/information-resources
Use with caution for adjusting drug dosages -
contact clinical pharmacist for advice.', 'comment set properly');
        is( $labtest->testcode,   'GFR', 'test code set by constructor param' );
        is( $labtest->testname,   'GFR', 'test name set by constructor param' );
        is( $labtest->range_low,  '',    'range low set by constructor param' );
        is( $labtest->range_high, '',    'range high set by constructor param' );
        is( $labtest->ref_range,  '',    'ref range derived from ranges' );
        is( $labtest->unit, 'mL/min/1.73sqm', 'unit set by constructor param' );
        ok( !( defined( $labtest->magnitude_status ) ), 'no magnitude status text set' );
        ok( !( defined( $labtest->result_text ) ), 'no result text set' );
    }

};

done_testing;
