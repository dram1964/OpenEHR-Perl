use strict;
use warnings;
use Data::Dumper;

=head1  find_by_UID composition_uid composition_format

Use this script to delete a composition from OpenEHR

=cut

use OpenEHR::REST::Composition;

my $query = OpenEHR::REST::Composition->new();
my $uid = $ARGV[0];
if (! $uid ) {
    die "Error: no UID specified. Nothing to delete\n";
}
if (! $query->find_by_uid($uid) ) {
    die "Error: $uid not found on OpenEHR server\n";
}

if ($query->delete_by_uid($uid)) {
    print "Action is " . $query->action . "\n";
    print "Deleted composition can be found at: " . $query->href . "\n";
}
