use strict;
use warnings;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomesTest');

my $lab_results_rs = $schema->resultset('PathologyResult')->search(
    {lab_number => '11U004254'} 
);

while ( my $result = $lab_results_rs->next ) {
    print
      join( "\t", $result->order_code, $result->test_code, $result->result, $result->result_date, $result->authorisation_date, 
        $result->units, $result->range_low, $result->range_high, $result->report, $result->wp_function),
      "\n";
}
