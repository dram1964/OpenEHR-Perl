use strict;
use warnings;
use DateTime::Format::DateParse;
use JSON;
use DBI;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;
use Data::Dumper;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $scheduled_requests_rs = &get_scheduled_data_requests;

while ( my $request = $scheduled_requests_rs->next ) {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = (
        $request->subject_ehr_id,  $request->subject_id,
        $request->data_start_date, $request->data_end_date
    );
    print join( ":", $nhs_number, $start_date, $end_date ), "\n";

    my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
    );

    my $receiver_id1  = 'RIS123123';
    my $receiver1 = $imaging_exam->element('Receiver')->new(
        id => $receiver_id1,
    );
    my $request_id1   = 'TQ00112233';
    my $requester1 = $imaging_exam->element('Requester')->new(
        id => $request_id1,
    );
    my $report_id1    = $receiver_id1 . 'REP';
    my $report_reference1 = $imaging_exam->element('ReportReference')->new(
        id => $report_id1,
    );
    my $dicom_url1    = 'http://uclh.dicom.store/image_1';
    my $exam_request1 = [ 'Request1', 'Request2' ];
    my $request_detail1 = $imaging_exam->element('RequestDetail')->new(
        requester        => $requester1,
        receiver         => $receiver1,
        report_reference => $report_reference1,
        dicom_url        => $dicom_url1,
        exam_request     => $exam_request1,
    );

    $imaging_exam->request_details( [$request_detail1] ); 

    my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
        report_id => &get_report_id,
        imaging_exam => [$imaging_exam],
    );

    print Dumper $radiology_report->compose;

}

sub get_report_id {
    my $report_id = int( rand(1000000000000000) );
    $report_id .= '0000000000000000';
    if ( $report_id =~ /^([\d]{16,16}).*/ ) {
        $report_id = $1;
    }
    return $report_id;
}

=head2 get_scheduled_data_requests

Returns a ResultSet for Data Requests that are 
flagged with an order state of 'scheduled'

=cut 

sub get_scheduled_data_requests {
    my $planned_requests_rs = $schema->resultset('InformationOrder')->search(
        {
            order_state_code => 529,
            subject_id_type  => 'uk.nhs.nhs_number',
            service_type     => 'radiology',
            subject_id => '1111111111',
        },
        {
            columns => [
                qw/subject_ehr_id subject_id data_start_date data_end_date subject_id/
            ]
        },
    );
    return $planned_requests_rs;
}
