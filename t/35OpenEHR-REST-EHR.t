use strict;
use warnings;
use Test::More;
use OpenEHR::REST::EHR;

BEGIN {
    use_ok('OpenEHR::REST::EHR');
}

diag("Testing OpenEHR::REST::EHR $OpenEHR::REST::EHR::VERSION");
ok( my $config = OpenEHR->new(),
    'Configuration available via OpenEHR module' );

my $test_ehrid     = $config->test_ehrid;
my $test_subjectid = $config->test_subjectid;

ok( my $ehr1 = OpenEHR::REST::EHR->new(),
    'Constructor called with no parameters'
);

( note 'Testing read-only properties' );
eval { $ehr1->ehr_id('2833483843'); };
ok( $@, 'Cannot set ehr_id property directly' );
eval { $ehr1->action('FAIL'); };
ok( $@, 'Cannot set action property directly' );
eval { $ehr1->err_msg('Something went wrong!'); };
ok( $@, 'Cannot set err_msg property directly' );
eval { $ehr1->ehr_status( { queryable => 1, modifiable => 0 } ); };
ok( $@, 'Cannot set ehr_status property directly' );

note('Testing find_or_new method');
eval { $ehr1->find_or_new(); };
ok( $@, 'find_or_new fails if no parameters are provided' );
my $ehr2 = OpenEHR::REST::EHR->new( subject_id => $test_subjectid );
eval { $ehr2->find_or_new(); };
ok( $@, "find_or_new fails if only subject_id is specified" );
my $ehr3 = OpenEHR::REST::EHR->new( subject_namespace => 'GEL' );
eval { $ehr3->find_or_new(); };
ok( $@, "find_or_new fails if only subject_namespace is specified" );
my $ehr4 = OpenEHR::REST::EHR->new( committer_name => 'Committer Name' );
eval { $ehr4->find_or_new(); };
ok( $@, "find_or_new fails if only committer_name specified" );

note('Testing find_or_new for existing record');
ok( my $ehr5 = OpenEHR::REST::EHR->new(
        {   subject_id        => $test_subjectid,
            subject_namespace => 'GEL',
        }
    ),
    'Constructor called with test_subject record details'
);
ok( $ehr5->find_or_new, 'find_or_new method called for existing record' );
ok( !$ehr5->err_msg, "Error Message not set" );
is( $ehr5->action, 'RETRIEVE', "action is RETRIEVE" );
is( $ehr5->ehr_id, $test_ehrid,
    'EhrId retrieved matches test subject ehrid' );
is( $ehr5->ehr_status->{subjectId}, $ehr5->subject_id,
    'Returned subject id matches submitted value');
is( $ehr5->ehr_status->{subjectNamespace}, $ehr5->subject_namespace,
    'Returned subject namespace matches submitted value');
note('EHR can be found at ' . $ehr5->href);



note('Testing find_or_new for probable non-existing record');
my $subjectId = int( rand(100000000) );
ok( my $ehr6 = OpenEHR::REST::EHR->new(
        {   subject_id        => $subjectId,
            subject_namespace => 'GEL',
            committer_name    => 'Committer Name',
        }
    ),
    'Constructor called with random subjectId'
);
ok( $ehr6->find_or_new,
    'find_or_new method called for probable non-existing record' );
is( $ehr6->action, 'CREATE', "action is CREATE" );
ok( $ehr6->ehr_id, "ehr_id accessor" );
ok( !$ehr6->ehr_status, 'EHR status not set after call to get new');
note('EHR can be found at ' . $ehr6->href);

note('Testing find_by_ehrid method');
my $ehr7 = OpenEHR::REST::EHR->new();
ok( !$ehr7->ehr_id,                    'Ehr_id not set at construction' );
ok( $ehr7->find_by_ehrid($test_ehrid), "Find existing EHR by ehr_id" );
is( $ehr7->action, 'RETRIEVE',  "Action is RETRIEVE" );
is( $ehr7->ehr_id, $test_ehrid, "Found record matches searched record" );
ok( $ehr7->ehr_status,               "response ehr_status accessor" );
ok( $ehr7->ehr_status->{queryable},  "Status queryable true" );
ok( $ehr7->ehr_status->{modifiable}, "Status modifiable true" );
ok( !$ehr7->err_msg,                 "Error Message not set" );
ok( $ehr7->ehr_status->{subjectId}, 'Subject id set');
ok( $ehr7->ehr_status->{subjectNamespace}, 'Subject namespace set');
note('EHR can be found at ' . $ehr7->href);

my $ehr8 = OpenEHR::REST::EHR->new();
ok( !$ehr8->find_by_ehrid('1232323'), "Failed to find non-existent EHR" );
ok( !$ehr8->ehr_id,                   "No ehr_id set" );
ok( !$ehr8->ehr_status,               "ehr_status not set" );
is( $ehr8->action, 'FAIL', "Action is FAIL" );
ok( $ehr8->err_msg, "Error Message Set" );

my $ehr9 = OpenEHR::REST::EHR->new();
ok( $ehr9->find_by_ehrid( $ehr6->ehr_id ), "Find new EHR by ehr_id" );
is( $ehr9->ehr_id, $ehr6->ehr_id, "Found record matches searched record" );
is( $ehr9->action, 'RETRIEVE',    "Action is RETRIEVE" );
ok( $ehr9->ehr_status,               "response ehr_status accessor" );
ok( $ehr9->ehr_status->{queryable},  "Status queryable true" );
ok( $ehr9->ehr_status->{modifiable}, "Status modifiable true" );
ok( !$ehr9->err_msg,                 "Error Message not set" );
ok( $ehr9->ehr_status->{subjectId}, 'Subject id set');
ok( $ehr9->ehr_status->{subjectNamespace}, 'Subject namespace set');
note('EHR can be found at ' . $ehr9->href);

note('Testing update_ehr_status method');
my $subject = {
    subjectNamespace => 'GEL V3',
    subjectId => '33232323',
    queryable => 0, 
    modifiable => 0,
};
ok( $ehr9->update_ehr_status($subject), 'Update status called');
if ($ehr9->action eq 'DUPLICATE') {
    diag( 'Duplicate error encountered: ' . $ehr9->err_msg);
}
elsif ($ehr9->action eq 'UPDATE') {
    note('EHR can be found at ' . $ehr9->href);
}
else {
    diag ( 'Unknown error encountered ' . $ehr9->err_msg );
}


done_testing;
