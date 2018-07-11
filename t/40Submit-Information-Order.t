use strict;
use warnings;
use Test::More;
use OpenEHR::REST::EHR;

ok(my $ehr1 = OpenEHR::REST::EHR->new(
    {
        subject_id      => '9998887777',
        subject_namespace       => 'uk.nhs.nhs_number'
    }
), "Create new EHR query");

done_testing;
