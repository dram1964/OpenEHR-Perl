use strict;
use warnings;

use Data::Dumper;
use JSON;
use Getopt::Long;
use DateTime;
use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;
use Carecast::Model;
use Genomes_100K::Model;

my ( $help );

GetOptions (
    "help" => \$help,
    )
or &usage("Error in command line arguments\n");

&usage if $help;

my $carecast_schema = Carecast::Model->connect('CRIUCarecast');
my $genomes_schema  = Genomes_100K::Model->connect('CRIUGenomes');

my $subject_namespace = 'uk.nhs.nhs_number';

my $patient_list_rs = $genomes_schema->resultset('InformationOrder')->search(
    {
        order_state => 'scheduled'
    },
    {
        join       => 'demographic',
        '+columns' => [ 'demographic.nhs_number' ],
        where      => {
            -or => {
                'demographic.demographic_status' => undef,
                'demographic.inserted'           => { '<' => \'order_date' },
            }
        },
    }
);

while ( my $patient = $patient_list_rs->next ) {
    my $patient_number = $patient->subject_id;
    #print "Processing $patient_number\n";

    my $carecast_demographics_rs =
      $carecast_schema->resultset('Patient')->search(
        {
            nhs_number => $patient_number,
        },
        {
            columns => [
                qw/nhs_number hospital_patient_id surname fname1 fname2 date_of_birth sex death_flag date_of_death/
            ]
        },
      );
    if ( $carecast_demographics_rs == 0 ) {
#        print "No Carecast Demographics found for: $patient_number\n";
        next;
    }
    my $carecast_demographics = $carecast_demographics_rs->first;

    my $order_rs = $genomes_schema->resultset('InformationOrder')->search(
        {
            subject_id      => $patient_number,
            subject_id_type => $subject_namespace,
        }
    );
    if ( $order_rs->count > 0 ) {
        my $order = $order_rs->first;

        my $ehr = OpenEHR::REST::EHR->new(
            {
                subject_id        => $patient_number,
                subject_namespace => 'uk.nhs.nhs_number',
                committer_name    => 'Committer Name',
            }
        );
        $ehr->find_or_new;

        my $update_status = &update_party( $carecast_demographics, $ehr );
        if ( $ehr->action eq 'CREATE' ) {
            #print 'EHR can be found at ', $ehr->href, "\n";
            &add_demographics( $carecast_demographics, $ehr, $update_status );
        }
        elsif ( $ehr->action eq 'RETRIEVE' ) {
            #print "EHR already exists for this subject (", $ehr->subject_id, ")\n";
            #print 'EHR can be found at ',                  $ehr->href,       "\n";
            &add_demographics( $carecast_demographics, $ehr, $update_status );
        }
        else {
            print "Error in submission:\n";
            print $ehr->err_msg;
        }
    }
}

sub add_demographics() {
    my ( $carecast_demographics, $ehr, $update_status ) = @_;
    $genomes_schema->resultset('Demographic')->update_or_create(
        {
            nhs_number          => $carecast_demographics->nhs_number,
            hospital_patient_id => $carecast_demographics->hospital_patient_id,
            surname             => $carecast_demographics->surname,
            fname1              => $carecast_demographics->fname1,
            fname2              => $carecast_demographics->fname2,
            date_of_birth       => $carecast_demographics->date_of_birth,
            sex                 => $carecast_demographics->sex,
            death_flag          => $carecast_demographics->death_flag,
            date_of_death       => $carecast_demographics->date_of_death,
            subject_ehr_id      => $ehr->ehr_id,
            demographic_status  => $update_status,
            inserted            => DateTime->now->ymd,
        }
    );
}

sub update_party() {
    my ( $carecast_demographics, $ehr ) = @_;

    my $gender_code = $carecast_demographics->sex;
    my $gender;
    if ( $gender_code eq 'F' ) {
        $gender = 'FEMALE';
    }
    elsif ( $gender_code eq 'M' ) {
        $gender = 'MALE';
    }
    else {
        $gender = 'UNKNOWN';
    }

    my $date_of_birth = $carecast_demographics->date_of_birth;
    if ( $date_of_birth =~ /(\d{4,4}-\d{2,2}-\d{2,2})/ ) {
        $date_of_birth = $1;
    }

    my $first_names = $carecast_demographics->fname1;
    if ( $carecast_demographics->fname2 ) {
        $first_names = $first_names . ' ' . $carecast_demographics->fname2;
    }

    my $party = {
        firstNames          => $first_names,
        lastNames           => $carecast_demographics->surname,
        gender              => $gender,
        dateOfBirth         => $date_of_birth,
        partyAdditionalInfo => [
            { key => "ehrId", value => $ehr->ehr_id, },
            {
                key   => "uk.nhs.nhs_number",
                value => $carecast_demographics->nhs_number,
            },
        ]
    };
    my $openehr_demographics = OpenEHR::REST::Demographics->new(
        {
            party => $party
        }
    );
    $openehr_demographics->update_or_new( $ehr->ehr_id );
    if ( $openehr_demographics->err_msg ) {
        print $openehr_demographics->err_msg;
        return 0;
    }
    #print "Party info at: " . $openehr_demographics->href . "\n";
    return 1;
}

sub usage() {
    my $error_message = shift;
    print $error_message if $error_message;
    my $message = << "END_USAGE";
Usage: 
$0

This script will search the InformationOrders table 
in the data source system for all scheduled orders
with no matching Demographics entry or for orders that
were placed after the current demographics where loaded. 
Demographics will then be pulled from the Demographics 
master database into the Datasource system and a corresponding
EHR and Party Record will be added to the OpenEHR system

OPTIONS

-h --help       [OPTIONAL] Prints this message and terminates

END_USAGE

    print $message;
    exit 0;
}
