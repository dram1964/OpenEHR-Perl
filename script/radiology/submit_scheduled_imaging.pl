use strict;
use warnings;
use DateTime::Format::DateParse;
use Data::Dumper;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;

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
        #next unless $visit->visitid eq '7121596';
        # Get a list of examinations for the visit
        my $study_rs = &get_visit_studies($visit->visitid);
        while ( my $study = $study_rs->next) {
            my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
                report_id => $study->studyid,
                imaging_exam => [],
            );
            $radiology_report->composition_format('FLAT');
            #next unless $study->studyid eq '31190272';
            my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
                reports => [],
                request_details => [],
            );
            # Get the latest report issued for the examination
            my $report_rs = &get_latest_study_report($study->studyid);
            my $report = $report_rs->first;
            next unless $report;

            # Build ImagingExam ImagingReport Object
            #my $result_status = $report_count++ == 1 ? 'at0011' : 'at0010';
            my $result_status = 'at0011';
            printf("VisitID: %s, StudyId: %s, ReportId: %s\n", 
                $visit->visitid, $study->studyid, $report->reportid);
            my $report_text = $report->reporttextparsed;
                #my $new_line_char = '\n';
                #$report_text =~ s/\r?\n/\n/g;
            my ( $imaging_code, $imaging_name, $imaging_terminology ) = 
                &get_primary_exam_code($report);
            my $imaging_report = $imaging_exam->element('ImagingReport')->new(
                imaging_code => $imaging_code,
                imaging_name => $imaging_name,
                imaging_terminology => $imaging_terminology,
                report_text => $report_text,
                modality => $report->modality,
                result_status => $result_status,
                result_date => DateTime::Format::DateParse->parse_datetime($report->reportauthoriseddatealt),
                code_mappings => [],
            );
            $imaging_report->add_mappings($report);

            push @{ $imaging_exam->reports }, $imaging_report;

            if ($report->nicip_map) {
                printf("ExamCode: %s, Nicip: %s\n", 
                    $report->examcode, $report->nicip_map->nicip_code);
            }
            else {
                printf("No NICIP code for %s\n", 
                    $report->examcode);
            }

                # Build RequestDetails Requester
                #my $requester = OpenEHR::Composition::Elements::ImagingExam::Requester->new();

                # Build RequestDetails Receiver
                #my $receiver = OpenEHR::Composition::Elements::ImagingExam::Receiver->new( id => $report->studyid,);

                # Build RequestDetails dicom_url
                #my dicom_url = '';

            # Build RequestDetails ReportReference
            my $report_reference = $imaging_exam->element('ReportReference')->new(
                id => $report->reportid,
            );

            # Build ImagingExam RequestDetails Object
            my $request_details = $imaging_exam->element('RequestDetail')->new(
                report_reference => $report_reference,
                exam_request => [$report->examname],
            );
            push @{ $imaging_exam->request_details }, $request_details;
            
            # Add the ImagingExam object to the RadiologyReport for this visit
            push @{ $radiology_report->imaging_exam }, $imaging_exam;
            #print Dumper $radiology_report->compose;

            # Submit the composition
            if ( my $compositionUid = &submit_composition( $radiology_report, $ehrid ) ) {
                #&update_datawarehouse($compositionUid, $visit->visitid);
            }
        }
    }
}

=head2 update_datawarehouse( $composition_uid, $visit_id )

Adds compostion_id, date_reported and reported_by fields to RadiologyReports
table for the given visit_id

=cut

sub update_datawarehouse {
    my ( $composition_uid, $visit_id ) = @_;
    my $search = $schema->resultset('RadiologyReport')->search(
        {
            visitid => $visit_id
        }
    );
    my $now = DateTime->now->datetime;
    $now =~ s/T/ /;
    $search->update(
        {
            composition_id => $composition_uid,
            reported_date  => $now,
            reported_by    => $0,
        }
    );
}

=head2 submit_composition($compostion_object)

Submit a composition object to OpenEHR server

=cut 

sub submit_composition {
        my ( $radiology_report, $ehrid ) = @_; 
        my $query = OpenEHR::REST::Composition->new();
        $query->composition($radiology_report);
        
        $query->template_id('GEL Generic radiology report import.v0');
        $query->submit_new($ehrid);
        if ( $query->err_msg ) {
            print 'Error occurred in submission: ' . $query->err_msg;
            return 0;
        }
        else {
            print 'Action is: ',                   $query->action,         "\n";
            print 'Composition UID: ',             $query->compositionUid, "\n";
            print 'Composition can be found at: ', $query->href,           "\n";
            return $query->compositionUid
        }
}

=head1 get_primary_exam_code 

Returns NICIP coding based on local codes for Study Exam

=cut 

sub get_primary_exam_code {
    my $report = shift;
    my ( $imaging_code, $imaging_name, $imaging_terminology );
    if ($report->nicip_map) {
        $imaging_code = $report->nicip_map->nicip_code;
        $imaging_name = $report->nicip_map->nicip_code;
        $imaging_terminology = 'NICIP';
    }
    else {
        $imaging_code = $report->examcode;
        $imaging_name = $report->examname;
        $imaging_terminology = 'local';
    }
    return  $imaging_code, $imaging_name, $imaging_terminology;
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
    my $visit_rs = $schema->resultset('RadiologyReport')->search(
        {
            nhsnumber => $nhs_number, 
            reported_date => undef,
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
    my $study_rs = $schema->resultset('RadiologyReport')->search(
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

=head2 get_latest_study_report

Returns latest report for a given study 

=cut

sub get_latest_study_report {
    my $study_id = shift;
    my $report_rs = $schema->resultset('RadiologyReport')->search(
        {
            studyid => $study_id, 
            studystatus => 'Authorised',
        },
        {
            order_by => { -desc => 'reportid' },
            rows => 1,
        },
    );
    return $report_rs;
}
