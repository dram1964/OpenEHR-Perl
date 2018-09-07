use strict;
use warnings;

use JSON;
use Data::Dumper;

my $json_text = '{"magnitude":70.0}';
my $perl_hash = from_json($json_text);

print Dumper $json_text;
print Dumper $perl_hash;
