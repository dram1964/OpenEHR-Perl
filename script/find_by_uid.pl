use strict;
use warnings;
use Data::Dumper;

use OpenEHR::REST::Composition;

my $path_report1 = OpenEHR::REST::Composition->new();
my $uid = 'de7b024f-aba4-4401-ab73-4d18bb49d60d';
$path_report1->request_format('FLAT');
$path_report1->find_by_uid($uid);
print Dumper $path_report1->composition_response;


