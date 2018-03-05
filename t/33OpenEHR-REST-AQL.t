use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('OpenEHR::REST::AQL');
}

diag("Testing OpenEHR::REST::AQL $OpenEHR::REST::AQL::VERSION");

my $query4 = OpenEHR::REST::AQL->new();

my $ehrId           = $query4->test_ehrid;
my $composition_uid = $query4->test_uid;

my $aql = "select e from Ehr e where e/ehr_id/value = '$ehrId'";
$query4->statement($aql);
ok( $query4->run_query, "running query from a single line query string" );
is( $query4->resultset->[0]->{'#0'}->{ehr_id}->{value},
    $ehrId, "Correct EHR returned" );

my $query5 = OpenEHR::REST::AQL->new();
$aql = "select e 
from Ehr e 
where e/ehr_id/value = '$ehrId'
";
$query5->statement($aql);
ok( $query5->run_query, "running query from a multi line query string" );
is( $query5->resultset->[0]->{'#0'}->{ehr_id}->{value},
    $ehrId, "Correct EHR returned" );

my $query6 = OpenEHR::REST::AQL->new();
$aql = << "AQL1";
select e from Ehr e where e/ehr_id/value = '$ehrId'
AQL1
$query6->statement($aql);
ok( $query6->run_query,
    "running query from a single line HEREDOC query string" );
note( $query6->err_msg ) if $query6->err_msg;

my $query7 = OpenEHR::REST::AQL->new();
$aql = << "AQL2";
select e from Ehr e 
where e/ehr_id/value = '$ehrId'
AQL2
$query7->statement($aql);
ok( $query7->run_query,
    "running query from a multi-line HEREDOC query string" );
note( $query7->err_msg ) if $query7->err_msg;

note("Select UIDs from Compositions");
ok( my $query2 = OpenEHR::REST::AQL->new(
        statement => "select c/uid/value as uid from Composition c"
    ),
    "Initialised object with statement parameter"
);
ok( $query2->run_query, "Submitted Query" );
diag( "Error Message: " . $query2->err_msg ) if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset, 'ARRAY', "Resultset is an ArrayRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );
ok( defined( $query2->resultset->[0]->{uid} ),
    "UID accessible from resultset" );

note("Select EhrIDs from Ehrs");
$aql = "select e/ehr_id/value as ehrId from Ehr e";
ok( $query2->statement($aql), "Add new statement to aql object" );
is( $query2->statement, $aql, "Statement updated to new value" );
ok( $query2->run_query, "Submitted Query" );
diag $query2->err_msg if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset, 'ARRAY', "Resultset is an ArrayRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );
ok( $ehrId = $query2->resultset->[0]->{ehrId},
    "Access EhrId from first Result" );

note("Select an Ehr by EhrID");
$aql = "select e from Ehr e where e/ehr_id/value = '$ehrId'";
ok( $query2->statement($aql), "Prepare search by ehrId" );
ok( $query2->run_query,       "Submitted Query" );
diag $query2->err_msg if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset, 'ARRAY', "Resultset is an ArrayRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );
is( $query2->resultset->[0]->{'#0'}->{ehr_id}->{value},
    $ehrId, "Retrieved correct EhrId" );

note("Select PtNumber and EHRID from Ehrs");
$aql = "select e/ehr_status/subject/external_ref/id/value as ptnumber, 
e/ehr_id/value as ehrid from Ehr e";
ok( $query2->statement($aql), "Prepare search for all subject ids" );
ok( $query2->run_query,       "Submitted Query" );
diag $query2->err_msg if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset, 'ARRAY', "Resultset is an ArrayRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );
ok( scalar( @{ $query2->resultset } ) >= 1, "One or more results retrieved" );
ok( defined( $query2->resultset->[0]->{ehrid} ),
    "Ehrid accessible from resultset"
);
ok( defined( $query2->resultset->[0]->{ptnumber} ),
    "PtNumber accessible from resultset"
);

$ehrId = $query2->test_ehrid;

note("Select all compositions for a specified EhrID");
$aql = "SELECT c as compos FROM EHR[ehr_id/value = '$ehrId']";
$aql .= " CONTAINS COMPOSITION c ORDER BY c/context/start_time DESC";
ok( $query2->statement($aql), "Prepare search for compositions by ehrid" );
ok( $query2->run_query,       "Submitted Query" );
diag $query2->err_msg if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset,      'ARRAY', "Resultset is an ArrayRef" );
isa_ok( $query2->resultset->[0], 'HASH',  "First Result is a HashRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );

note("Select all ehrs for a specified subject id");
my $subject_id = $query2->test_subjectid;
$aql =
    "select e as ehrId from Ehr e where e/ehr_status/subject/external_ref/id/value = '$subject_id'";
ok( $query2->statement($aql), "Prepare search for ehrs by subject id" );
ok( $query2->run_query,       "Submitted Query" );
diag $query2->err_msg if $query2->err_msg;
ok( !$query2->err_msg, "No Error Message set" );
isa_ok( $query2->resultset,      'ARRAY', "Resultset is an ArrayRef" );
isa_ok( $query2->resultset->[0], 'HASH',  "First Result is a HashRef" );
is( $query2->aql, $query2->statement, "AQL matches Query String" );

done_testing;

