use strict;
use warnings;
use DateTime::Format::DateParse;
use JSON;
use DBI;

use OpenEHR::Composition::LabResultReport;
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

    if ($end_date =~ m/(\d{4,4}\-\d{2,2}\-\d{2,2})/ ) {
        $end_date = $1;
    }
    if ($start_date =~ m/(\d{4,4}\-\d{2,2}\-\d{2,2})/ ) {
        $start_date = $1;
    }
    #print join( ":", $nhs_number, $start_date, $end_date ), "\n";
    my $samples_rs =
      &select_samples_to_report( $ehrid, $nhs_number, $start_date, $end_date );

    my $order_item_number = 1;
    while ( my $sample = $samples_rs->next ) {
        my $labreport          = [];
        my $labnumber          = $sample->lab_number;
        my $report_id          = $labnumber;
        my $sample_report_date = $sample->last_authorised_date;
        my $orders_ref         = &get_sample_orders($labnumber);
        for my $order ( @{$orders_ref} ) {
            my $data =
              &get_order_data_hash( $sample, $order, $order_item_number,
                $start_date, $end_date );
            push @{$labreport}, $data;
        }
        if ( my $composition = &submit_report( $labreport, $ehrid, $report_id, $sample_report_date)) {
            &update_report_date( $labnumber, $composition );
        }
        $order_item_number++;
    }
}

=head2 get_order_data_hash

Creates the data hash for an order in a request for adding to the 
Laboratory Report
Need to add logic for test_status lookup and collect_method

=cut 

sub get_order_data_hash {
    my ( $sample, $order, $order_item_number, $start_date, $end_date ) = @_;
    my $labnumber = $sample->lab_number;
    print join( ":",
        "$order_item_number) ", $sample->nhs_number, $labnumber,
        $order->order_code,     $order->order_name,  $sample->sample_date,
        $start_date,            $end_date ),
      "\n";
    my $data = {};

    if ( $sample->order_number ) {
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
    $data->{report_date} =
      &get_report_date( $labnumber, $order->order_code );    # DateTime->now;

=head1 test_status

Need to replace this statement with test_status lookup
    $data->{test_status} = 'Final';

=cut

    $data->{test_status} = 'Final';

    my $sample_data = &get_sample_data($labnumber);
    if ( $sample_data->sample_type ) {
        $data->{spec_type} = $sample_data->sample_type;
    }
    if ( $sample_data->sample_date ) {
        $data->{collected} =
          DateTime::Format::DateParse->parse_datetime(
            $sample_data->sample_date . " " . $sample_data->sample_time );
    }

=head1 collect_method

Need to replace this statement with collect_method lookup
   $data->{collect_method} = 'Phlebotomy';

=cut

    if ( $sample_data->receive_date ) {
        $data->{received} = DateTime::Format::DateParse->parse_datetime(
            $sample_data->receive_date . " " . $sample_data->receive_time );
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
    my $order_mapping = &get_order_mappings( $order->order_code );
    if ($order_mapping) {
        $data->{order_mapping} = $order_mapping;
    }

    my $lab_results_ref = &get_labresults( $labnumber, $order->order_code );
    for my $lab_result ( @{$lab_results_ref} ) {
        my $results = &format_results($order->order_code, $lab_result);
        push @{ $data->{labresults} }, $results;
    }
    return $data;
}

=head2 format_results

Returns a hashref for a labresult 

=cut

sub format_results {
        my ($order_code, $lab_result) = @_;
        my $result          = $lab_result->result;
        my $test_code       = $lab_result->test_code;
        my $department_code = $lab_result->laboratory_department_code;
        my $results = {
            result_value  => $result,
            range_low     => $lab_result->range_low,
            range_high    => $lab_result->range_high,
            testcode      => $lab_result->test_code,
            testname      => $lab_result->test_name,
            result_status => 'Final',
            unit          => $lab_result->units,
        };
        my $result_mapping =
          &get_mappings( $order_code, $test_code, $department_code );
        if ($result_mapping) {
            $results->{result_mapping} = $result_mapping;
        }
        return $results;
}

=head2 get_order_mappings

Returns a hashref mapping local order coodes to 
GeL and LOINC codes

=cut

sub get_order_mappings {
    my $order_code = shift;
    my $mapping;
    my $gel_rs = $schema->resultset('GelLoincMapping')->search(
        {
            local_code => $order_code,
        },
        {
            rows => 1,
        }
    );
    while ( my $map = $gel_rs->next ) {
        if ( $map->gel_code ) {
            push @{$mapping},
              {
                code        => $map->gel_code,
                terminology => 'GEL',
              };
        }
        if ( $map->loinc_code ) {
            push @{$mapping},
              {
                code        => $map->loinc_code,
                terminology => 'LOINC',
              };
        }
    }
    return $mapping;
}

=head2 get_mappings

Returns a hashref mapping local test (analyte) codes
to LOINC codes

=cut

sub get_mappings {
    my ( $order_code, $test_code, $department_code ) = @_;
    if ( $department_code =~ /^M.*/ ) {
        $department_code = 'UCLH_MIC_DW';
    }
    else {
        $department_code = 'UCLH_BHI_DW';
    }
    my $mapping;
    my $loinc_rs = $schema->resultset('HslLoincMapping')->search(
        {
            profile_code => $order_code,
            test_code    => $test_code,
            origin       => { -like => 'UCLH_%' },
        },
        {
            rows => 1,
        },
    );
    my $loinc_code;
    if ( my $loinc = $loinc_rs->first ) {
        if ( $loinc->loinc_code ) {
            $loinc_code = $loinc->loinc_code;
            push @{$mapping},
              {
                code        => $loinc->loinc_code,
                terminology => 'LOINC',
              };
        }
    }
    if ( !$loinc_code ) {
        my $loinc_rs2 = $schema->resultset('HslLoincMapping')->search(
            {
                test_code => $test_code,
                origin    => $department_code,
            },
            {
                rows => 1,
            }
        );
        if ( my $loinc = $loinc_rs2->first ) {
            if ( $loinc->loinc_code ) {
                $loinc_code = $loinc->loinc_code;
                push @{$mapping},
                  {
                    code        => $loinc->loinc_code,
                    terminology => 'LOINC',
                  };
            }
        }
    }
    if ($loinc_code) {
        my $gel_rs = $schema->resultset('GelLoincMapping')->search(
            {
                loinc_code => $loinc_code,
            },
            {
                rows => 1,
            }
        );
        if ( my $gel = $gel_rs->first ) {
            if ( $gel->gel_code ) {
                push @{$mapping},
                  {
                    code        => $gel->gel_code,
                    terminology => 'GEL',
                  };
            }
        }
    }
    return $mapping;
}

sub get_report_date {
    my ( $labnumber, $order_code ) = @_;
    my $report_date;
    my $search_rs = $schema->resultset('PathologyResult')->search(
        {
            lab_number => $labnumber,
            order_code => $order_code,
        },
        {
            order_by => { -desc => 'authorisation_date' },
            rows     => 1,
        }
    );
    my $result = $search_rs->first;
    if ( $result->authorisation_date ) {
        $report_date =
          $result->authorisation_date . ' ' . $result->authorisation_time;
    }
    elsif ( $result->result_date ) {
        $report_date = $result->result_date . ' ' . $result->result_time;
    }
    else {
        $report_date = undef;
    }
    return DateTime::Format::DateParse->parse_datetime($report_date);
}

sub update_report_date() {
    my ( $labnumber, $composition ) = @_;
    my $search = $schema->resultset('PathologySample')->search(
        {
            lab_number => $labnumber,
        }
    );
    my $now = DateTime->now->datetime;
    $now =~ s/T/ /;
    $search->update(
        {
            composition_id => $composition,
            reported_date  => $now,
            reported_by    => $0,
        }
    );

}

sub submit_report() {
    my ( $labreport, $ehrid, $report_id, $sample_report_date ) = @_;
    my $report = OpenEHR::Composition::LabResultReport->new();
    $report->report_id($report_id);
    $report->report_date(
        DateTime::Format::DateParse->parse_datetime($sample_report_date) );

    for my $order ( @{$labreport} ) {
        $report->add_labtests($order);
    }
    my $path_report = OpenEHR::REST::Composition->new();

    $path_report->composition($report);
    $path_report->template_id('GEL - Generic Lab Report import.v0');
    $path_report->submit_new($ehrid);
    if ( $path_report->err_msg ) {
        die $path_report->err_msg;
    }
    if ( $path_report->action eq 'CREATE' ) {
        #print "Composition UID: ", $path_report->compositionUid, "\n";
        #print 'Composition can be found at: ' . $path_report->href, "\n";
        return $path_report->compositionUid;
    }
    else {
        return 0;
    }
}

=head1 get_labresults

Returns an ArrayRef of labresult data for each reportable test
for a specified sample_number:order_code combination

=cut

sub get_labresults() {
    my $sample_number   = shift;
    my $order_code      = shift;
    my $lab_results_ref = [
        $schema->resultset('PathologyResult')->search(
            {
                lab_number  => $sample_number,
                order_code  => $order_code,
                report      => { '<>' => 'X' },
                wp_function => {
                    -not_like => [
                        -and => ( '%I%', '%J%' )
                    ]
                },
                result => { -not_like => '.%' },
            },
            {
                columns => [
                    qw/ result clinical_details range_low range_high
                      test_code units test_name laboratory_department_code/
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

=head2 get_sample_orders

Returns an ArrayRef of ArrayRefs of Order Codes and Order Names for a given sample

=cut

sub get_sample_orders() {
    my $sample_number = shift;
    my $order_code_rs = $schema->resultset('PathologySample')->search(
        {
            lab_number => $sample_number,
        },
        {
            columns => [qw/ order_code order_name /],
        }
    );
    my $order_codes_ref = [ $order_code_rs->all ];
}

=head2 select_samples_to_report

Returns a ResultSet for all samples that 
have not yet been reported and fall within the start and end dete
period for a Data Request

=cut

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

=head2 get_scheduled_data_requests

Returns a ResultSet for Data Requests that are 
flagged with an order state of 'scheduled'

=cut 

sub get_scheduled_data_requests {
    my $planned_requests_rs = $schema->resultset('InformationOrder')->search(
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
    return $planned_requests_rs;
}

