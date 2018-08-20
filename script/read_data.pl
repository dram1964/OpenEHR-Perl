use strict;
use warnings;
use utf8;

use Text::CSV;
use Data::Dumper;

my $start = $ARGV[0];
my $end = $ARGV[1];

my $data;

my $csv_in = Text::CSV->new( 
    { 
        binary => 1, 
        sep_char => "¦",
        quote_char => undef,
    } )
    or die "Cannot use CSV: " . Text::CSV->error_diag();

open my $fh, "data/result_dump.csv" or die "result_dump.csv: $!";
my $counter = 1;
while ( my $row = $csv_in->getline($fh) ) {
    if (($counter >= $start) && ($counter <= $end)) {
        for my $index (0..9) {
            chop($row->[$index]);
            $row->[$index] =~ s/\s*$//;
            if ($index == 2) {
                $row->[$index] =~ s/crlf/\n/g;
            }
            #print "Line $counter:$index (", ($row->[$index]), ")\n";
        }
        $data = {
            testcode => $row->[1],
            testname => $row->[1],
            result_value => $row->[2],
            unit => $row->[5],
            range_low => $row->[6],
            range_high => $row->[7],
        };
        print Dumper($data);
    }
    $counter++;
}
$csv_in->eof or $csv_in->error_diag();
close $fh;
