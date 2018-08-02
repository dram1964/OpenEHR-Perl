use strict;
use warnings;
use DateTime::Format::DateParse;
use Data::Dumper;
use JSON;
use DBI;

use OpenEHR::Composition::LabResultReport;
use OpenEHR::REST::Composition;

my $resulted =
    DateTime::Format::DateParse->parse_datetime('2017-12-01T01:30:00');

my $labreport = [];

my $patient_hospital_id = 'TTTTTT17';
print "Processing patient: $patient_hospital_id\n";

my $samples_ref = &get_patient_samples($patient_hospital_id);
my $labnumber = $samples_ref->[0];
print "Processing sample $labnumber\n";
my $order_data = &get_order_codes($labnumber);
for my $order (@{$order_data}) {
    my $data = {}; 
    $data->{order_number} = {
        id       => 'TQ00112233',
        assigner => 'TQuest',
        issuer   => 'UCLH',
    };
    $data->{labnumber} = {
            id => $labnumber,
            assigner => 'Winpath',
            issuer   => 'UCLH Pathology',
    };
    $data->{report_date} = $resulted;
    $data->{test_status} = 'Final';

    my $sample_data = &get_sample_data($labnumber);
    if (defined($sample_data->{spec_type})) {
        $data->{spec_type} = $sample_data->{spec_type};
    }
    if ($sample_data->{collected}) {
        $data->{collected} = DateTime::Format::DateParse->parse_datetime($sample_data->{collected});
    }
    if ($sample_data->{collect_method}) {
        $data->{collect_method} = $sample_data->{collect_method};
    }
    else {
        $data->{collect_method} = 'Phlebotomy';
    }
    if ($sample_data->{received}) {
        $data->{received} = DateTime::Format::DateParse->parse_datetime($sample_data->{received});
    }
    if ($sample_data->{clinician}) {
        $data->{clinician} = {
            id       => $sample_data->{clinician},
            assigner => 'Winpath',
            issuer   => 'UCLH',
        };
    }
    if ($sample_data->{location}) {
        $data->{location} = {
            id     => $sample_data->{location},
            parent => 'UCLH',
        };
    }
    if ($sample_data->{clinical_info}) {
        $data->{clinical_info} = $sample_data->{clinical_info};
    }

    my $order_code = $order->{order_code};
    print "Processing $labnumber:$order_code\n";
    my $order_name = $order->{order_name};
    $order_name =~ s/%//;
    $order_name =~ s/:/-/;
    $data->{ordercode} = $order_code;
    $data->{ordername} = $order_name;

    my $lab_results_ref = &get_labresults($labnumber, $order_code);

    for my $lab_result (@{$lab_results_ref}) {
        my $result = $lab_result->{result}; 
        my $comment = '';
        my $test_code = $lab_result->{testcode};
        my $ref_range; 
        my $regex = qr/^(.*)\n([\W|\w|\n]*)/;
        if ($result =~ $regex) {
            ($result, $comment) = ($1, $2);
            #print "$test_code has linefeeds in result:\n";
            #print "First Line: ", $1, "\n";
            #print "Remainder: ", $2, "\n";
            #print "Result: ", $result, "\n";
        }
        if ($lab_result->{units}) {
            if (!($lab_result->{units} eq '.')) {
                $result = $result . ' ' . $lab_result->{units};
            }
        } 
        if ($lab_result->{range_high}) {
            if ($lab_result->{range_low}) {
                $ref_range = $lab_result->{range_low} . '-' . $lab_result->{range_high};
            }
            else {
                $ref_range = '0-' . $lab_result->{range_high};
            }
        }
        else {
            $ref_range = '';
        }
        push @{$data->{labresults}}, 
            {   result        => $result, #'88.9 mmol/l',
                comment       => $comment, #'This is the sodium comment',
                ref_range     => $ref_range, #'80-90',
                testcode      => $lab_result->{testcode}, #'NA',
                testname      => $lab_result->{testname}, #'Sodium',
                result_status => 'Final',
            };
    }
    push @{$labreport}, $data;
    #print Dumper $data;
}
# print Dumper $labreport;
if (my $composition = &submit_report()) {
    &update_report_date($labnumber, $composition);
}

sub update_report_date() {
    my ($labnumber, $composition) = @_;
    my $user = 'dr00';
    my $password = 'letmein';
    my $dsn = "dbi:ODBC:DSN=CRIUGenomesTest";

    my $dbh = DBI->connect($dsn, $user, $password, {LongReadLen => 5000, LongTruncOk => 1}) or die "Unable to connect to $dsn: 
        $DBI::errstr";
    #$dbh->trace(1);
    my $statement = << 'END_STMT';
update dbo.Pathology_Samples
set reported_date = GETDATE(),
reported_by = ?, 
composition_id = ?
where laboratory_sample_number = ?
END_STMT

    my $sth = $dbh->prepare($statement) or die "Could not prepare statement: " . $dbh->errstr;
    $sth->execute($0, $composition, $labnumber) or die "Could not execute statement: " . $dbh->errstr;
}

sub get_labresults() {
    my $sample_number = shift;
    my $order_code = shift;
    my $lab_results_ref;
    my $user = 'dr00';
    my $password = 'letmein';
    my $dsn = "dbi:ODBC:DSN=CRIUPathologyTest";

    my $dbh = DBI->connect($dsn, $user, $password, {LongReadLen => 5000, LongTruncOk => 1}) or die "Unable to connect to $dsn: 
        $DBI::errstr";
    #$dbh->trace(1);
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

    my $sth = $dbh->prepare($statement) or die "Could not prepare statement: " . $dbh->errstr;
    $sth->execute($sample_number, $order_code) or die "Could not execute statement: " . $dbh->errstr;
    while (my $result = $sth->fetchrow_hashref) {
        push @{$lab_results_ref}, $result;
    }

    $sth->finish;
    $dbh->disconnect;
    return $lab_results_ref;
}

sub get_order_codes() {
    my $sample_number = shift;
    my $order_code_ref; 
    my $user = 'dr00';
    my $password = 'letmein';
    my $dsn = "dbi:ODBC:DSN=CRIUGenomesTest";

    my $dbh = DBI->connect($dsn, $user, $password, {LongReadLen => 80, LongTruncOk => 1}) or die "Unable to connect to $dsn: 
        $DBI::errstr";
    #$dbh->trace(1);
    my $statement = << 'END_STMT';
SELECT order_code, order_name
FROM Pathology_Samples
WHERE laboratory_sample_number = ?
AND reported_date IS NULL
END_STMT

    my $sth = $dbh->prepare($statement) or die "Could not prepare statement: " . $dbh->errstr;
    $sth->execute($sample_number) or die "Could not execute statement: " . $dbh->errstr;
    while (my $order = $sth->fetchrow_hashref) {
        push @{$order_code_ref}, $order; 
    }

    $sth->finish;
    $dbh->disconnect;
    return $order_code_ref;
}

sub get_sample_data() {
    my $sample_number = shift;
    my $sample_data_ref;
    my $user = 'dr00';
    my $password = 'letmein';
    my $dsn = "dbi:ODBC:DSN=CRIUPathologyTest";

    my $dbh = DBI->connect($dsn, $user, $password, {LongReadLen => 80, LongTruncOk => 1}) or die "Unable to connect to $dsn: 
        $DBI::errstr";
    #$dbh->trace(1);
    my $statement = << 'END_STMT';
select top 1  
CAST(sample_date AS DATETIME) + CAST(sample_time AS DATETIME) collected
, CAST(receive_date AS DATETIME) + CAST(receive_time AS DATETIME) received
, sample_type spec_type
, sample_description
, clinician_code clinician
, source_code location
,clinical_details clinical_info
from Winpath.Results
where lab_number = ?
END_STMT

    my $sth = $dbh->prepare($statement) or die "Could not prepare statement: " . $dbh->errstr;
    $sth->execute($sample_number) or die "Could not execute statement: " . $dbh->errstr;
    $sample_data_ref = $sth->fetchrow_hashref;
    $sth->finish;
    $dbh->disconnect;
    return $sample_data_ref;
}


sub get_patient_samples() {
    my $hospital_id = shift;
    my @lab_numbers;
    my $user = 'dr00';
    my $password = 'letmein';
    my $dsn = "dbi:ODBC:DSN=CRIUGenomesTest";

    my $dbh = DBI->connect($dsn, $user, $password, {LongReadLen => 80, LongTruncOk => 1}) or die "Unable to connect to $dsn: 
        $DBI::errstr";

    my $statement = 'SELECT top 1 laboratory_sample_number 
        from dbo.Pathology_Samples 
        where patient_hospital_number = ?
        and reported_date IS NULL';

    my $sth = $dbh->prepare($statement) or die "Could not prepare statement: " . $dbh->errstr;

    my $rv = $sth->execute($hospital_id) or die "Could not execute statement: " . $dbh->errstr;

    while (my $row = $sth->fetchrow_hashref()) {
        push @lab_numbers, $row->{laboratory_sample_number}; 
    }
    die "No rows found" unless (scalar @lab_numbers);
    $sth->finish;
    $dbh->disconnect;
    return \@lab_numbers;
}
    

sub submit_report() {
    my $report = OpenEHR::Composition::LabResultReport->new();
    $report->report_id('1112233322233');
    $report->patient_comment('Hello EHR');
    for my $order (@{$labreport}) {
        $report->add_labtests($order);
    }
    $report->composer_name('David Ramlakhan');
    print "Composition Format: ", $report->composition_format, "\n";
    my $path_report = OpenEHR::REST::Composition->new();

    $path_report->composition( $report );
    $path_report->template_id('GEL - Generic Lab Report import.v0');
    $path_report->submit_new($report->test_ehrid);
    if ($path_report->err_msg) {
        warn $path_report->err_msg ;
    }
    if ($path_report->action eq 'CREATE') {
        print "Composition UID: " , $path_report->compositionUid, "\n";
        print 'Composition can be found at: ' . $path_report->href, "\n"; 
        return $path_report->compositionUid;
    }
    else {
        return 0;
    }
}
