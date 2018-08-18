use strict;
use warnings;
use utf8;

use Text::CSV;

my $start = $ARGV[0];
my $end = $ARGV[1];

my @rows;
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
            print "Line $counter:$index (", ($row->[$index]), ")\n";
        }
        push @rows, $row;
    }
    $counter++;
}
$csv_in->eof or $csv_in->error_diag();
close $fh;
