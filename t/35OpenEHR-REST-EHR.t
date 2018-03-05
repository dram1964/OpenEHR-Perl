use strict;
use warnings;
use Test::More;
use OpenEHR::REST::EHR;

BEGIN {
    use_ok('OpenEHR::REST::EHR');
}

diag("Testing OpenEHR::REST::EHR $OpenEHR::REST::EHR::VERSION");
my $config         = OpenEHR::REST->new();
my $test_ehrid     = $config->test_ehrid;
my $test_subjectid = $config->test_subjectid;

ok( my $ehr1 = OpenEHR::REST::EHR->new(),
    'Constructor called with no parameters'
);
note('Testing find_or_new method');
eval { $ehr1->find_or_new(); };
ok( $@, 'find_or_new fails if no parameters are provided' );

my $ehr2 = OpenEHR::REST::EHR->new( subjectId => $test_subjectid );
eval { $ehr2->find_or_new(); };
ok( $@, "find_or_new fails if only subjectId is specified" );

my $ehr3 = OpenEHR::REST::EHR->new( subjectNamespace => 'GEL' );
eval { $ehr3->find_or_new(); };
ok( $@, "find_or_new fails if only subjectNamespace is specified" );

my $ehr4 = OpenEHR::REST::EHR->new( committerName => 'Committer Name' );
eval { $ehr4->find_or_new(); };
ok( $@, "find_or_new fails if only committerName specified" );

ok( my $ehr5 = OpenEHR::REST::EHR->new(
        subjectId        => $test_subjectid,
        subjectNamespace => 'GEL',
        committerName    => 'David Ramlakhan',
    ),
    'Constructor called with test_subject record details'
);

ok( $ehr5->find_or_new, 'find_or_new method called for existing record' );
is( $ehr5->action, 'RETRIEVE', "action is RETRIEVE" );
ok( $ehr5->ehrId, "ehrId accessor" );
is( $ehr5->ehrId, $test_ehrid, 'EhrId retrieved matches test subject ehrid' );
ok( !$ehr5->err_msg, "Error Message not set" );

my $subjectId = int( rand(100000000) );
ok( my $ehr6 = OpenEHR::REST::EHR->new(
        {   subjectId        => $subjectId,
            subjectNamespace => 'GEL',
            committerName    => 'Committer Name',
        }
    ),
    'Constructor called with random subjectId'
);
ok( $ehr6->find_or_new,
    'find_or_new method called for probable non-existing record' );
is( $ehr6->action, 'CREATE', "action is CREATE" );
ok( $ehr6->ehrId, "ehrId accessor" );

note('Testing find_by_ehrid method');
my $ehr7 = OpenEHR::REST::EHR->new();
ok( !$ehr7->ehrId,                     'EhrId not set at construction' );
ok( $ehr7->find_by_ehrid($test_ehrid), "Find existing EHR by ehrId" );
is( $ehr7->ehrId,  $test_ehrid, "Found record matches searched record" );
is( $ehr7->action, 'RETRIEVE',  "Action is RETRIEVE" );
ok( $ehr7->ehrStatus,               "response ehrStatus accessor" );
ok( $ehr7->ehrStatus->{queryable},  "Status queryable true" );
ok( $ehr7->ehrStatus->{modifiable}, "Status modifiable true" );
ok( !$ehr7->err_msg,                "Error Message not set" );

my $ehr8 = OpenEHR::REST::EHR->new();
ok( !$ehr8->find_by_ehrid('1232323'), "Failed to find non-existent EHR" );
ok( !$ehr8->ehrId,                    "No ehrId set" );
ok( !$ehr8->ehrStatus,                "ehrStatus not set" );
is( $ehr8->action, 'FAIL', "Action is FAIL" );
ok( $ehr8->err_msg, "Error Message Set" );

my $ehr9 = OpenEHR::REST::EHR->new();
ok( !$ehr9->ehrId,                        'EhrId not set at construction' );
ok( $ehr9->find_by_ehrid( $ehr6->ehrId ), "Find new EHR by ehrId" );
is( $ehr9->ehrId,  $ehr6->ehrId, "Found record matches searched record" );
is( $ehr9->action, 'RETRIEVE',   "Action is RETRIEVE" );
ok( $ehr9->ehrStatus,               "response ehrStatus accessor" );
ok( $ehr9->ehrStatus->{queryable},  "Status queryable true" );
ok( $ehr9->ehrStatus->{modifiable}, "Status modifiable true" );
ok( !$ehr9->err_msg,                "Error Message not set" );

done_testing;
