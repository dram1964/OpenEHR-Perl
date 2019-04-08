use strict;
use warnings;
use DateTime::Format::DateParse;
use Data::Dumper;

use OpenEHR::Composition::RadiologyReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomes');

my $uid = $ARGV[0];
die "No composition_id specified\n" unless $uid;

my $study_id = &get_study_id($uid);
die "No study found for uid\n" unless $study_id;

my $nhs_number = &get_subject_id($uid); #'9467484064';
die "Aborting: Unable to find nhs_number from UID\n" unless $nhs_number;

my ($ehrid, $data_start_date, $data_end_date) = &get_order_data($nhs_number);
#my $data_start_date = '2001-03-07';
#my $data_end_date = '2019-03-19';
die "Aborting: Unable to find order start_date for nhs_number\n" unless $data_start_date;
die "Aborting: Unable to find order end_date for nhs_number\n" unless $data_end_date;


print join ("#", $uid, $study_id, $nhs_number, $data_start_date, $data_end_date), "\n";

# Get the latest report issued for the examination
my $report_rs = &get_latest_study_report($study_id);
my $report = $report_rs->first;
die "No reports found for $study_id\n" unless $report;

my $radiology_report = OpenEHR::Composition::RadiologyReport->new(
    report_id => $study_id,
    imaging_exam => [],
    #report_date => DateTime::Format::DateParse->parse_datetime( $report->get_column( 'lastreporteddate') ),
    report_date => DateTime::Format::DateParse->parse_datetime( $report->lastreporteddate),
);
$radiology_report->composition_format('FLAT');
my $imaging_exam = OpenEHR::Composition::Elements::ImagingExam->new(
    reports => [],
    request_details => [],
);

my $result_status = 'at0011';
my $report_text = $report->reporttextparsed;

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

# Add the ImagingExam object to the RadiologyReport for this visit
push @{ $radiology_report->imaging_exam }, $imaging_exam;
#print Dumper $radiology_report->compose;

# Submit the composition
if ( my $compositionUid = &submit_update( $radiology_report, $ehrid ) ) {
    &update_datawarehouse($compositionUid, $report->studyid, $report->reportid);
}
die "Finished Testing\n";

=for implementation

            # Build ImagingExam ImagingReport Object
            #my $result_status = $report_count++ == 1 ? 'at0011' : 'at0010';
            printf("VisitID: %s, StudyId: %s, ReportId: %s\n", 
                $visit->visitid, $study->studyid, $report->reportid);

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
            
        }
    }
}
=cut

=head2 update_datawarehouse( $composition_uid, $visit_id )

Adds compostion_id, date_reported and reported_by fields to RadiologyReports
table for the given visit_id

=cut

sub update_datawarehouse {
    my ( $composition_uid, $study_id, $report_id ) = @_;
    my $search = $schema->resultset('RadiologyReport')->search(
        {
            studyid => $study_id,
            reportid => $report_id,
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

sub get_order_data {
    my $subject_id = shift;
    my $order_rs = $schema->resultset('InformationOrder')->search(
        {
            subject_id => $subject_id,
            service_type => 'radiology',
        },
        {
            order_by => { -desc => 'order_date'},
            columns => [ qw(subject_ehr_id data_start_date data_end_date) ],
            rows => 1,
        }
    );
    if ( $order_rs == 1 ) {
        my $order = $order_rs->first;
        return $order->subject_ehr_id, $order->data_start_date, $order->data_end_date;
    }
    else {
        return 0;
    }
}

sub get_subject_id {
    my $uid = shift;
    my $composition_rs = $schema->resultset('RadiologyReport')->search(
        {
            composition_id => $uid,
        },
        {
            columns => 'nhsnumber',
            distinct => 1,
        }
    );
    if ( $composition_rs->count == 1 ) {
        return $composition_rs->first->nhsnumber;
    }
    else {
        return 0;
    }
}

sub get_study_id {
    my $composition_uid = shift;

    my $study_rs = $schema->resultset('RadiologyReport')->search(
        {
            composition_id => $composition_uid,
        },
        {
            columns => 'studyid',
            rows => 1,
        }
    );

    if ($study_rs->count == 1) {
        return $study_rs->first->studyid;
    }
    else {
        return 0;
    }
}

sub submit_update {
    my ( $radiology_report, $ehrid ) = @_;
    my $query = OpenEHR::REST::Composition->new();
    $query->composition($radiology_report);
    $query->template_id('GEL Generic radiology report import.v0');
    $query->update_by_uid($uid);
    if ( $query->err_msg ) {
        print 'Error occurred in submission: ' . $query->err_msg;
        return 0;
    }
    else {
        print 'Action is: ',                   $query->action,         "\n";
        print 'Composition UID: ',             $query->compositionUid, "\n";
        print 'Composition can be found at: ', $query->href,           "\n";
        return $query->compositionUid;
    }
}

