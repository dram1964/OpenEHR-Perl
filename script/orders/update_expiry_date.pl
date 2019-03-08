use strict;
use warnings;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $exclusion_list = &get_unsubmitted_ids;

print "Exclusion List: ", join( ":", @{ $exclusion_list } ), "\n";

&update_expiry_date($exclusion_list);

=head2 &update_expiry_date($exclustions)

Sets an expiry date for orders that have all compositions submitted

=cut 

sub update_expiry_date {
    my $exclusions = shift;

    my $update_rs = $schema->resultset('InfoflexCancer')->search(
        {
            composition_id => { -not => undef }
        },
        {
            columns => [ qw/ nhs_number / ],
            distinct => 1,
        }
    );
    while ( my $update = $update_rs->next ) {
        my $nhs_number = $update->nhs_number;
        my $match = grep { /$nhs_number/ }  @{ $exclusions } ; 
        print "Matches: $match\n";
        if ($match) {
            print "Subject ID: " . $update->nhs_number . ", found in exclusion list. Skipping\n";
        }
        else {
            print "Subject ID: " . $update->nhs_number . ", not found in exclusion list. Updating\n";
        }
    }
}


=head2 &get_unsubmitted_ids() 

returns an arrayref of patient_ids for all
cancer reports that have no submitted compostions

=cut 

sub get_unsubmitted_ids {
    my @ids;
    my $unsubmitted_rs = $schema->resultset('InfoflexCancer')->search(
        {
            composition_id =>  undef ,
        },
        {
            columns => [ qw/ nhs_number / ],
            distinct => 1,
        }
    );
    while ( my $id = $unsubmitted_rs->next ) {
        push @ids, $id->nhs_number;
    }
    return \@ids;
}
