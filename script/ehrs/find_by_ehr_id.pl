use strict;
use warnings;
use Data::Dumper;

use OpenEHR::REST::EHR;

my $ehr_id = '9085f25b-d81a-4fa0-8210-481b6b87f9f5';

my $ehr = OpenEHR::REST::EHR->new();

$ehr->find_by_ehrid($ehr_id);
print Dumper $ehr;
