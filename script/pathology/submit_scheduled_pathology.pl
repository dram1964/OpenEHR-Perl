use strict;
use warnings;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;
use DBI;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::Composition;
use Genomes_100K::Model;

my $schema = Genomes_100K::Model->connect('CRIUGenomesTest');

my $resulted =
  DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');

my $orders_rs = $schema->resultset('InformationOrder')->search(
    {
        order_state_code => 529,
        subject_id_type  => 'uk.nhs.nhs_number',
        service_type     => 'pathology'
    },
    { columns => [qw/subject_ehr_id subject_id data_start_date data_end_date subject_id/] },
);

my $patient_number;
while ( my $order = $orders_rs->next ) {
    print join( ":",
        $order->subject_id, $order->data_start_date, $order->data_end_date ),
      "\n";
    &select_samples_to_report( $order->subject_ehr_id, $order->subject_id, $order->data_start_date,
        $order->data_end_date );
}

sub select_samples_to_report {
    my ( $ehrid, $nhs_number, $start_date, $end_date ) = @_;
    my $samples_rs = $schema->resultset('PathologySample')->search(
        {
            nhs_number  => $nhs_number,
            sample_date => { '>=' => $start_date },
            sample_date => { '<=' => $end_date },
            reported_date => undef,
        },
        {
            columns => [ qw/laboratory_sample_number nhs_number sample_date order_number / ],
            distinct => 1,
        },
    );
    my $row = 1;
    while ( my $sample = $samples_rs->next ) {
        my $labreport       = [];
        my $labnumber       = $sample->laboratory_sample_number;
        my $order_codes_ref = &get_order_codes($labnumber);

        for my $order ( @{$order_codes_ref} ) {
            print join( ":",
                "$row) ",                          $sample->nhs_number,
                $sample->laboratory_sample_number, $order->order_code,
                $order->order_name,                $sample->sample_date,
                $start_date,                       $end_date ),
              "\n";
            my $data = {};

            if ($sample->order_number) {
                $data->{order_number} = {
                    id       => $sample->order_number,
                    assigner => 'TQuest',
                    issuer   => 'UCLH',
                };
            }
            $data->{labnumber} = {
                id       => $labnumber,
                assigner => 'Winpath',
                issuer   => 'UCLH Pathology',
            };
            $data->{report_date} = &get_report_date($labnumber,$order->order_code); # DateTime->now;
=head1 test_status

need to replace this statement with test_status lookup

=cut
            $data->{test_status} = 'Final';

            my $sample_data = &get_sample_data($labnumber);
            if ( $sample_data->sample_type ) {
                $data->{spec_type} = $sample_data->sample_type;
            }
            if ( $sample_data->sample_date ) {
                $data->{collected} =
                  DateTime::Format::DateParse->parse_datetime(
                        $sample_data->sample_date . " "
                      . $sample_data->sample_time );
            }
=head1 collect_method

Need to replace this statement with collect_method lookup

=cut
            $data->{collect_method} = 'Phlebotomy';
            if ( $sample_data->receive_date ) {
                $data->{received} = DateTime::Format::DateParse->parse_datetime(
                        $sample_data->receive_date . " "
                      . $sample_data->receive_time );
            }
            if ( $sample_data->clinician_code ) {
                $data->{clinician} = {
                    id       => $sample_data->clinician_code,
                    assigner => 'Winpath',
                    issuer   => 'UCLH',
                };
            }
            if ( $sample_data->location_name ) {
                $data->{location} = {
                    id     => $sample_data->location_name,
                    parent => 'UCLH',
                };
            }
            if ( $sample_data->clinical_details ) {
                $data->{clinical_info} = $sample_data->clinical_details;
            }
            $data->{ordercode} = $order->order_code;
            $data->{ordername} = $order->order_name;
            
            my $lab_results_ref =
              &get_labresults( $labnumber, $order->order_code );
            for my $lab_result ( @{$lab_results_ref} ) {
                my $result    = $lab_result->result;
                my ($magnitude, $magnitude_status, $unit);
                my $comment   = '';
                my $test_code = $lab_result->test_code;
                my $ref_range;
                my $regex = qr/^(.*)\n([\W|\w|\n]*)/;
                if ( $result =~ $regex ) {
                    ( $result, $comment ) = ( $1, $2 );
                    #print Dumper $test_code, $comment;
                }
                if ( $lab_result->units ) {
                    if ( !( $lab_result->units eq '.' ) ) {
                        if ($result =~ /^([\<|\>]){1,1}(.*)/ ) {
                            ($magnitude_status, $result) = ( $1, $2);
                        }
                        if ($result =~ /^\d*\.{1,1}\d$/) {
                            $magnitude = $result;
                            $unit = $lab_result->units;
                            $result = $result . ' ' . $lab_result->units;
                        }
                    }
                }
                if ( $lab_result->range_high ) {
                    if ( $lab_result->range_low ) {
                        $ref_range = $lab_result->range_low . '-'
                          . $lab_result->range_high;
                    }
                    else {
                        $ref_range = '0-' . $lab_result->range_high;
                    }
                }
                else {
                    $ref_range = '';
                }
                if ( $magnitude ) {
                    push @{ $data->{labresults} }, {
                        magnitude    => $magnitude,       #'88.9 mmol/l',
                        unit        => $unit,
                        comment   => $comment,      #'This is the sodium comment',
                        ref_range => $ref_range,    #'80-90',
                        testcode      => $lab_result->test_code,   #'NA',
                        testname      => $lab_result->test_name,          #'Sodium',
                        result_status => 'Final',
                        magnitude_status => $magnitude_status,
                    };
                }
                else {
                    push @{ $data->{labresults} }, {
                        result    => $result,       #'88.9 mmol/l',
                        comment   => $comment,      #'This is the sodium comment',
                        ref_range => $ref_range,    #'80-90',
                        testcode      => $lab_result->test_code,   #'NA',
                        testname      => $lab_result->test_name,          #'Sodium',
                        result_status => 'Final',
                        magnitude_status => $magnitude_status,
                    };
                }
            }
            push @{$labreport}, $data;
        }
        if (my $composition = &submit_report($labreport, $ehrid)) {
            &update_report_date($labnumber, $composition);
        }
        $row++;
    }
}

sub get_report_date {
    my ( $labnumber, $order_code ) = @_;
    my $report_date;
    my $search_rs = $schema->resultset('PathologyResult')->search(
        {
            lab_number => $labnumber,
            order_code  => $order_code,
        },
        {
            order_by => 'authorisation_date',
            rows    => 1,
        }
    );
    my $result = $search_rs->first;
    if ($result->authorisation_date) {
        $report_date = $result->authorisation_date . ' ' . $result->authorisation_time;
    }
    elsif ($result->result_date) {
        $report_date = $result->result_date . ' ' . $result->result_time;
    }
    else {
        $report_date = undef;
    }
    return DateTime::Format::DateParse->parse_datetime($report_date);
}




sub update_report_date() {
    my ($labnumber, $composition) = @_;
    my $search = $schema->resultset('PathologySample')->search( 
        {
            laboratory_sample_number => $labnumber, 
        }
    );
    my $now = DateTime->now->datetime;
    $now =~ s/T/ /;
    $search->update(
        {
            composition_id => $composition,
            reported_date => $now,
            reported_by => $0,
        }
    );

}

sub submit_report() {
    my ( $labreport, $ehrid ) = @_;
    my $report    = OpenEHR::Composition::LabResultReport->new();
=head1 report_id

need to generate a report_id for each labresultreport

=cut
    $report->report_id('1112233322233');

=head1 patient_comment

need to use a patient_comment lookup here

=cut
    $report->patient_comment('Hello EHR');
    for my $order ( @{$labreport} ) {
        $report->add_labtests($order);
    }
=head1 composer_name

need to generate a suitable value for composer name

=cut
    $report->composer_name('David Ramlakhan');
    #print "Composition Format: ", $report->composition_format, "\n";
    my $path_report = OpenEHR::REST::Composition->new();

    $path_report->composition($report);
    $path_report->template_id('GEL - Generic Lab Report import.v0');
    $path_report->submit_new( $ehrid );
    if ( $path_report->err_msg ) {
        die $path_report->err_msg;
    }
    if ( $path_report->action eq 'CREATE' ) {
        print "Composition UID: ", $path_report->compositionUid, "\n";
        print 'Composition can be found at: ' . $path_report->href, "\n";
        return $path_report->compositionUid;
    }
    else {
        return 0;
    }
}

sub get_labresults() {
    my $sample_number   = shift;
    my $order_code      = shift;
    my $lab_results_ref = [
        $schema->resultset('PathologyResult')->search(
            {
                lab_number        => $sample_number,
                order_code => $order_code,
                report  => { '<>' => 'X'},
                wp_function => {
                    -not_like => [
                        -and => ('%I%', '%J%')
                        ]
                },
                result => { -not_like => '.%' },
            },
            {
                columns => [
                    qw/ result clinical_details range_low range_high
                      test_code units test_name /
                ],
            }
        )->all
    ];

=head1 add_extra_filters
    my $statement = << 'END_STMT';
select
t1.result
, clinical_details
, t1.range_low
, t1.range_high 
, t1.test_format_code testcode
, t1.units
, t2.test_name testname
from Winpath.Results t1
join Winpath.TFCLibrary t2 on (t1.test_format_code = t2.test_code and t1.winpath_database = SUBSTRING(t2.laboratory_department_code, 1,1))
where lab_number = ?
and test_library_code = ?
and t2.report <> 'X'
and t2.wp_function not like '%I%'
and t2.wp_function not like '%J%'
and t1.result not like '.%'
order by t2.line_number
END_STMT
=cut

    return $lab_results_ref;
}

sub get_sample_data() {
    my $sample_number   = shift;
    my $sample_data_ref = $schema->resultset('PathologyResult')->search(
        {
            lab_number => $sample_number,
        },
        {
            columns => [
                qw/ sample_date sample_time receive_date receive_time sample_type
                  sample_description clinician_code location_code location_name clinical_details /
            ],
        },
    )->first;
    return $sample_data_ref;
}

sub get_order_codes() {
    my $sample_number = shift;
    my $order_code_rs = $schema->resultset('PathologySample')->search(
        {
            laboratory_sample_number => $sample_number,
        },
        {
            columns => [qw/ order_code order_name /],
        }
    );
    my $order_codes_ref = [ $order_code_rs->all ];
}
