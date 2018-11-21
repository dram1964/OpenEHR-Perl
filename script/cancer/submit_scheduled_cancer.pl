use strict;
use warnings;
use DateTime::Format::DateParse;
use JSON;
use DBI;

use OpenEHR::Composition::CancerReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomesLiveTest');

my $orders_rs = $schema->resultset('InformationOrder')->search(
    {
        order_state_code => 529,
        subject_id_type  => 'uk.nhs.nhs_number',
        service_type     => 'cancer',
    },
    {
        columns => [
            qw/ subject_ehr_id subject_id data_start_date data_end_date subject_id/
        ]
    },
);

my $patient_number;
while ( my $order = $orders_rs->next ) {
    print join( ":",
        $order->subject_id, $order->data_start_date, $order->data_end_date, ),
      "\n";
    &report_cancer(
        $order->subject_ehr_id,  $order->subject_id,
        $order->data_start_date, $order->data_end_date
    );
}

sub report_cancer {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = @_;
    my $reports_rs = $schema->resultset('InfoflexCancerTest')->search(
        {
            nhs_number => $nhs_number,
            event_date_diagnosis => { '>=' => $start_date },
            event_date_diagnosis => { '<=' => $end_date },
            reported_date => undef,
        },
    );
    while ( my $report = $reports_rs->next ) {
        print Dumper $report;
    }
}
