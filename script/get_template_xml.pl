use strict;
use warnings;
use Data::Dumper;

use OpenEHR::REST::Template;

my $template = OpenEHR::REST::Template->new();

$template->get_template_xml( 'GEL Cancer diagnosis input.v0' );

print Dumper $template->xml;
