use strict;
use warnings;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $exclusions = &get_unsubmitted_ids;
my $inclusions = &get_submitted_ids;

&update_expiry_date();

=head2 &update_expiry_date($exclustions)

Sets an expiry date for orders that have all compositions submitted

=cut 

sub update_expiry_date {
    my $update_rs = $schema->resultset('InformationOrder')->search(
        {
            expiry_date  => undef,
            service_type => 'cancer',
            order_state  => 'scheduled',
        },
        {
            columns  => [qw/ subject_id /],
            distinct => 1,
        }
    );
    if ( $update_rs->count > 0 ) {
        if ( $update_rs->count > 1 ) {
            while ( my $update = $update_rs->next ) {
                &set_expiry_date($update);
            }
        }
        else {
            my $update     = $update_rs->first;
            &set_expiry_date($update);
        }
    }
}

sub set_expiry_date {
    my $update     = shift;
    my $nhs_number = $update->subject_id;
    if ( grep { /$nhs_number/ } @{$exclusions} ) {
        #print "Subject ID: "
        #  . $nhs_number
        #  . ", found in exclusion list. Skipping\n";
    }
    elsif ( grep { /$nhs_number/ } @{$inclusions} ) {
        #print "Subject ID: "
        #  . $nhs_number
        #  . ", found in inclusion list. Updating\n";
        my $order_rs = $schema->resultset('InformationOrder')->search(
            {
                service_type => 'cancer',
                subject_id   => $nhs_number,
            }
        );
        if ( $order_rs->count > 1 ) {
            while ( my $order = $order_rs->next ) {
                my $end_date = $order->data_end_date;
                $order->update( { expiry_date => $end_date } );
            }
        }
        else {
            my $order    = $order_rs->first;
            my $end_date = $order->data_end_date;
            $order->update( { expiry_date => $end_date } );
        }
    }
    else {
        #print "Subject ID: "
        #  . $nhs_number
        #  . " has no submitted compositions. Skipping\n";
    }
}

=head2 &get_submitted_ids() 

returns an arrayref of patient_ids for all
cancer reports that have one or more submitted compostions

=cut 

sub get_submitted_ids {
    my @ids;
    my $submitted_rs = $schema->resultset('InfoflexCancer')->search(
        {
            composition_id => { -not => undef },
        },
        {
            columns  => [qw/ nhs_number /],
            distinct => 1,
        }
    );
    while ( my $id = $submitted_rs->next ) {
        push @ids, $id->nhs_number;
    }
    return \@ids;
}

=head2 &get_unsubmitted_ids() 

returns an arrayref of patient_ids for all
cancer reports that have no submitted compostions

=cut 

sub get_unsubmitted_ids {
    my @ids;
    my $unsubmitted_rs = $schema->resultset('InfoflexCancer')->search(
        {
            composition_id => undef,
        },
        {
            columns  => [qw/ nhs_number /],
            distinct => 1,
        }
    );
    while ( my $id = $unsubmitted_rs->next ) {
        push @ids, $id->nhs_number;
    }
    return \@ids;
}
