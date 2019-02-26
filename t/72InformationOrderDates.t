use strict;
use warnings;

use Test::More;
use Genomes_100K::Model;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

ok(
    my $scheduled_requests_rs = $schema->resultset('InformationOrder')->search(
        {
            order_state_code => 529,
            subject_id_type  => 'uk.nhs.nhs_number',
            subject_id       => '5555555555',
            service_type     => 'pathology',
        },
        {
            columns => [
                qw/subject_ehr_id subject_id data_start_date data_end_date subject_id/
            ],
        },
    ),
    "Select request dates from Information_Orders"
);

while ( my $request = $scheduled_requests_rs->next ) {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = (
        $request->subject_ehr_id,  $request->subject_id,
        $request->data_start_date, $request->data_end_date
    );

    if ($end_date =~ m/(\d{4,4}\-\d{2,2}\-\d{2,2})/ ) {
        $end_date = $1;
    }
    if ($start_date =~ m/(\d{4,4}\-\d{2,2}\-\d{2,2})/ ) {
        $start_date = $1;
    }
    diag $end_date;

    ok(my $samples_rs =
      &select_samples_to_report( $ehrid, $nhs_number, $start_date, $end_date ), 
      "Select samples by request start/end dates for $nhs_number ");
    while ( my $sample = $samples_rs->next ) {
        ok($sample->lab_number, " retrieve lab_number for $nhs_number ");
    }
}

done_testing;

sub get_scheduled_data_requests {
    my $scheduled_requests_rs = $schema->resultset('InformationOrder')->search(
        {
            order_state_code => 529,
            subject_id_type  => 'uk.nhs.nhs_number',
            service_type     => 'pathology'
        },
        {
            columns => [
                qw/subject_ehr_id subject_id data_start_date data_end_date subject_id/
            ]
        },
    );
    return $scheduled_requests_rs;
}

sub select_samples_to_report {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = @_;
    my $samples_rs = $schema->resultset('PathologySample')->search(
        {
            nhs_number    => $nhs_number,
            sample_date   => { '<=' => $end_date, '>=' => $start_date },
            reported_date => undef,
        },
        {
            columns => [
                qw/lab_number nhs_number sample_date last_authorised_date order_number /
            ],
            distinct => 1,
        },
    );
    return $samples_rs;
}
