use strict;
use warnings;
use Test::More;
use Data::Dumper;
use OpenEHR::REST::Template;

BEGIN { use_ok('OpenEHR::Composition::CancerReport'); }
#my $template_id = 'GEL Cancer diagnosis input.v0';
#my $template    = OpenEHR::REST::Template->new();
#$template->get_template_example( $template_id, 'TDD', 'INPUT' );
#print Dumper $template->data;

my $cancer_data = {};

ok(my $cancer_report = OpenEHR::Composition::CancerReport->new($cancer_data), 'Create New Cancer Report Object');

done_testing;
