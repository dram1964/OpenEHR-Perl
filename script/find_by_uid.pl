use strict;
use warnings;
use Data::Dumper;

=head1  find_by_UID composition_uid composition_format

Use this script to dump a composition in the format specified
find_by_uid.pl \
0405d5d0-63be-44d8-86eb-d6e50d881dad::default::1 \
[ FLAT | STRUCTURED | RAW ]

=cut

use OpenEHR::REST::Composition;

my $path_report1 = OpenEHR::REST::Composition->new();
#my $uid = '0405d5d0-63be-44d8-86eb-d6e50d881dad::default::1';
# $uid = '0405d5d0-63be-44d8-86eb-d6e50d881dad';
my $uid = $ARGV[0];
print "$uid\n";
my $format = $ARGV[1] || 'FLAT';
$path_report1->request_format($format);
$path_report1->find_by_uid($uid);
print Dumper $path_report1->composition_response;


