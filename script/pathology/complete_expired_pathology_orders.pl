use strict;
use warnings;
use Genomes_100K::Model;
use OpenEHR::REST::Composition;
use OpenEHR::Composition::InformationOrder;
use DateTime;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');
my $dtf            = $schema->storage->datetime_parser;
my $exclusions = &get_unsubmitted_ids;
my $inclusions = &get_submitted_ids;

&find_expired_orders();

sub find_expired_orders {
    my $expired_orders_rs = $schema->resultset('InformationOrder')->search(
        {
            expiry_date => { '<=', $dtf->format_datetime( DateTime->now() ) },
            order_state_code => '529',
            service_type => 'pathology',
        },
        {
            columns => [qw/ composition_uid subject_id /],
            rows => 10,
        },
    );

    if ( $expired_orders_rs->count > 0 ) {
        if ( $expired_orders_rs->count > 1 ) {
            while ( my $update = $expired_orders_rs->next ) {
                my $nhs_number = $update->subject_id;
                if ( grep { /$nhs_number/ } @{$exclusions} ) {
                    print "Subject ID: "
                      . $nhs_number
                      . ", found in exclusion list. Skipping\n";
                }
                elsif ( grep { /$nhs_number/ } @{$inclusions} ) {
                    print "Subject ID: "
                      . $nhs_number
                      . ", found in inclusion list. Updating\n";
                    my $new_uid = &update_state($update->composition_uid);
                    if ( $new_uid ) {
                        my $status = &complete_order($new_uid, $update);
                    }
                }
                else {
                    print "$nhs_number not in exclusions or inclusions list\n";
                }
            }
        }
        else {
            my $update     = $expired_orders_rs->first;
            my $nhs_number = $update->subject_id;
            if ( grep { /$nhs_number/ } @{$exclusions} ) {
                print "Subject ID: "
                  . $nhs_number
                  . ", found in exclusion list. Skipping\n";
            }
            elsif ( grep { /$nhs_number/ } @{$inclusions} ) {
                print "Subject ID: "
                  . $nhs_number
                  . ", found in inclusion list. Updating\n";
                my $new_uid = &update_state($update->composition_uid);
                if ( $new_uid ) {
                    my $status = &complete_order($new_uid, $update);
                }
            }
            else {
                print "$nhs_number not in exclusions or inclusions list\n";
            }
        }
    }
    else {
        print "No expired pathology orders found\n";
    }
}

sub update_state {
    my $uid = shift;
    my $template_id = 'GEL - Data request Summary.v1';
    # Retrieve the composition
    my $retrieval = OpenEHR::REST::Composition->new();
    $retrieval->request_format('STRUCTURED');
    $retrieval->find_by_uid($uid);
    my $composition = $retrieval->composition_response;
    #print "Original order can be found at: " . $retrieval->href . "\n";

    # Recompose the composition with new state
    my $recompose = OpenEHR::Composition::InformationOrder->new();
    $recompose->decompose_structured($composition),
    $recompose->current_state('complete');
    $recompose->composition_format('STRUCTURED');
    #$recompose->compose;
    
    # Submit the update
    my $order_update = OpenEHR::REST::Composition->new();
    $order_update->composition($recompose);
    $order_update->template_id($template_id);
    $order_update->update_by_uid($uid);
    if ($order_update->err_msg) {
        die "Error occurred in submission: " . $order_update->err_msg;
    }
    #print "Update can be found at: " . $order_update->href . "\n";
    return $order_update->compositionUid;

}

sub complete_order {
    my ($uid, $update)     = @_;
    my $nhs_number = $update->subject_id;
    my $order_rs = $schema->resultset('InformationOrder')->search(
        {
            composition_uid => $update->composition_uid,
        },
    );
    my $result = $order_rs->update( 
        { 
            order_state => 'complete',
            order_state_code => '532',
            composition_uid => $uid,
        
        } 
    );
    return $result;
}

=head2 &get_submitted_ids() 

returns an arrayref of patient_ids for all
pathology reports that have one or more submitted compostions

=cut 

sub get_submitted_ids {
    my @ids;
    my $submitted_rs = $schema->resultset('PathologySample')->search(
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
pathology reports that have no submitted compostions

=cut 

sub get_unsubmitted_ids {
    my @ids;
    my $unsubmitted_rs = $schema->resultset('PathologySample')->search(
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