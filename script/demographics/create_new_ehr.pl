use strict;
use warnings;

use OpenEHR::REST::EHR;
use OpenEHR::REST::Demographics;
use Carecast::Model;
use Genomes_100K::Model;
use Data::Dumper;
use JSON;

my $patient_number = $ARGV[0];
die "Please specify an nhs_number to update" unless $patient_number;
my $subject_namespace = 'uk.nhs.nhs_number';

my $carecast_schema          = Carecast::Model->connect('CRIUCarecastTest');
my $carecast_demographics_rs = $carecast_schema->resultset('Patient')->search(
    {
        nhs_number => $patient_number,
    },
    {
        columns => [
            qw/nhs_number hospital_patient_id surname fname1 fname2 date_of_birth sex death_flag date_of_death/
        ]
    },
);
my $carecast_demographics = $carecast_demographics_rs->first;
die "No Carecast Demographics found for: $patient_number\n"
  unless $carecast_demographics->hospital_patient_id;

my $genomes_schema = Genomes_100K::Model->connect('CRIUGenomesTest');
my $order_rs       = $genomes_schema->resultset('InformationOrder')->search(
    {
        subject_id      => $patient_number,
        subject_id_type => $subject_namespace,
    }
);
my $order = $order_rs->first;
die "No orders found for $patient_number\n" unless defined($order);

my $ehr = OpenEHR::REST::EHR->new(
    {
        subject_id        => $patient_number,
        subject_namespace => 'uk.nhs.nhs_number',
        committer_name    => 'Committer Name',
    }
);
$ehr->find_or_new;

if ( $ehr->action eq 'CREATE' ) {
    print 'EHR can be found at ', $ehr->href, "\n";
    &add_demographics( $carecast_demographics, $ehr );
}
elsif ( $ehr->action eq 'RETRIEVE' ) {
    print "EHR already exists for this subject (", $ehr->subject_id, ")\n";
    print 'EHR can be found at ',                  $ehr->href,       "\n";
    &update_demographics( $carecast_demographics, $ehr );
}
else {
    print "Error in submission:\n";
    print $ehr->err_msg;
}

sub add_demographics() {
    my ( $carecast_demographics, $ehr ) = @_;
    $genomes_schema->resultset('Demographic')->create(
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
            subject_ehr_id      => $ehr->subject_id,
        }
    );

    my $party = {
        "firstNames"          => $carecast_demographics->fname1,
        "lastNames"           => $carecast_demographics->surname,
        "gender"              => $carecast_demographics->sex,
        "dateOfBirth"         => $carecast_demographics->date_of_birth,
        "partyAdditionalInfo" => [
            { "key" => "ehrId", "value" => $ehr->subject_id, },
            {
                "key"   => "uk.nhs.nhs_number",
                "value" => $carecast_demographics->nhs_number
            },
        ]
    };
    my $party_json = to_json($party);

    my $demographics = OpenEHR::REST::Demographics->new();
    $demographics->add_party($party_json);
    if ( $demographics->action eq 'CREATE' ) {
        print "Party information added\n";
    }
    else {
        print $demographics->err_msg;
    }
}

sub update_demographics() {
    my ( $carecast_demographics, $ehr ) = @_;
    my $genomes_demographics = $genomes_schema->resultset('Demographic')->find(
        {
            nhs_number => $carecast_demographics->nhs_number,
        }
    );

    $genomes_demographics->update(
        {
            hospital_patient_id => $carecast_demographics->hospital_patient_id,
            surname             => $carecast_demographics->surname,
            fname1              => $carecast_demographics->fname1,
            fname2              => $carecast_demographics->fname2,
            date_of_birth       => $carecast_demographics->date_of_birth,
            sex                 => $carecast_demographics->sex,
            death_flag          => $carecast_demographics->death_flag,
            date_of_death       => $carecast_demographics->date_of_death,
            subject_ehr_id      => $ehr->subject_id
        }
    );

    my $party = {
        "firstNames"          => $carecast_demographics->fname1,
        "lastNames"           => $carecast_demographics->surname,
        "gender"              => $carecast_demographics->sex,
        "dateOfBirth"         => $carecast_demographics->date_of_birth,
        "partyAdditionalInfo" => [
            { "key" => "ehrId", "value" => $ehr->subject_id, },
            {
                "key"   => "uk.nhs.nhs_number",
                "value" => $carecast_demographics->nhs_number,
            },
        ]
    };
    my $party_json = to_json($party);
    my $openehr_demographics = OpenEHR::REST::Demographics->new();
    if ( $openehr_demographics->get_by_ehrid( $ehr->ehr_id ) ) {
        $openehr_demographics->update_party($party_json);

        if ( $openehr_demographics->action eq 'UPDATE' ) {
            print "Party information added\n";
        }
        else {
            print $openehr_demographics->action,  "\n";
            print $openehr_demographics->err_msg, "\n";
        }
    }
    else {
        $openehr_demographics->add_party($party);
        if ( $openehr_demographics->action eq 'CREATE' ) {
            print "Party information added\n";
        }
        else {
            print "Unable to update party information \n";
            print $openehr_demographics->err_msg;
        }
    }
}
