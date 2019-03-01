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

    # Get a list of visits for the patient
    my $visit_rs = &get_patient_visits($nhs_number);
    while ( my $visit = $visit_rs->next ) {
        next unless $visit->visitid eq '3897538';
        my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
            report_id => $visit->visitid,
            imaging_exam => [],
        );
        $radiology_report->composition_format('STRUCTURED');
        # Get a list of examinations for the visit
        my $study_rs = &get_visit_studies($visit->visitid);
        while ( my $study = $study_rs->next) {
            next unless $study->studyid eq '31190272';
            my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
                reports => [],
                request_details => [],
            );
            # Get a list of reports issued for the examination
            my $report_rs = &get_study_reports($study->studyid);
            while ( my $report = $report_rs->next ) {
                next unless $report->reportid;
                printf("VisitID: %s, StudyId: %s, ReportId: %s\n", 
                    $visit->visitid, $study->studyid, $report->reportid);
                # Build ImagingExam ImagingReport Object
                my $imaging_report = OpenEHR::Composition::Elements::ImagingExam::ImagingReport->new(
                    imaging_code => $report->examcode,
                    report_text => $report->reporttextparsed,
                    modality => $report->modality,
                    result_status => 'at0011',
                    result_date => DateTime::Format::DateParse->parse_datetime($report->reportauthoriseddatealt),
                    anatomical_side => 'at0006',
                );
                push @{ $imaging_exam->reports }, $imaging_report;

                # Build RequestDetails Requester
                #my $requester = OpenEHR::Composition::Elements::ImagingExam::Requester->new();

                # Build RequestDetails Receiver
                #my $receiver = OpenEHR::Composition::Elements::ImagingExam::Receiver->new( id => $report->studyid,);

                # Build RequestDetails dicom_url
                #my dicom_url = '';

                # Build RequestDetails ReportReference
                my $report_reference = OpenEHR::Composition::Elements::ImagingExam::ReportReference->new(
                    id => $report->studyid,
                );

                # Build ImagingExam RequestDetails Object
                my $request_details = OpenEHR::Composition::Elements::ImagingExam::RequestDetail->new(
                    report_reference => $report_reference,
                    exam_request => [$report->examname],
                );
                push @{ $imaging_exam->request_details }, $request_details;
            }
            push @{ $radiology_report->imaging_exam }, $imaging_exam;
        }
        print Dumper $radiology_report->compose;
        my $query = OpenEHR::REST::Composition->new();
        $query->composition($radiology_report);
        
        $query->template_id('GEL Generic radiology report import.v0');
        $query->submit_new($ehrid);
        if ( $query->err_msg ) {
            print 'Error occurred in submission: ' . $query->err_msg;
        }
        else {
            print 'Action is: ',                   $query->action,         "\n";
            print 'Composition UID: ',             $query->compositionUid, "\n";
            print 'Composition can be found at: ', $query->href,           "\n";
        }
    }
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

=head2 get_patient_visits

Returns unique visit IDs for a specified patient

=cut

sub get_patient_visits {
    my $nhs_number = shift;
    my $visit_rs = $schema->resultset('StagingRadiologyReport')->search(
        {
            nhsnumber => $nhs_number,
        },
        {
            columns => [ qw/ visitid /],
            distinct => 1,
        }
    );
    return $visit_rs;
}

=head2 get_visit_studies

Returns all the studies (examinations) performed on a visit

=cut

sub get_visit_studies {
    my $visit_id = shift;
    my $study_rs = $schema->resultset('StagingRadiologyReport')->search(
        {
            visitid => $visit_id,
        },
        {
            columns => [ qw/ studyid / ],
            distinct => 1,
        }
    );
    return $study_rs;
}

=head2 get_study_reports

Returns all report IDs for a given study 

=cut

sub get_study_reports {
    my $study_id = shift;
    my $report_rs = $schema->resultset('StagingRadiologyReport')->search(
        {
            studyid => $study_id, 
        },
    );
    return $report_rs;
}
