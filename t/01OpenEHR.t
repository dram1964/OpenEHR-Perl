use Test::More;

use OpenEHR;

note("testing OpenEHR base module version $OpenEHR::VERSION");
ok( my $open_ehr = OpenEHR->new(), 'OpenEHR constructor' );
ok( ref($open_ehr) eq 'OpenEHR', 'Object Type' );

note('Testing Local Configuration file settings');
my $local_config_file = 'OpenEHR.conf';
ok( -f $local_config_file, 'Local Configuration file exists' );
ok(
    open( my $fh, '<', $local_config_file ),
    'Local Configuration file is readable'
);
my %local_config;

while ( my $line = <$fh> ) {
    next if $line =~ /^[#|\s]/;
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    note("Param($param) value($value)");
    $local_config{$param} = $value;
}

my $oe1 = OpenEHR->new();

if ( $ENV{OPENEHR_USER} ) {
    is( $oe1->user, $ENV{OPENEHR_USER}, 'Default User set from environment' );
}
else {
    is( $oe1->user, $local_config{user}, 'Default User set from conf file' );
}

if ( $ENV{OPENEHR_PASSWORD} ) {
    is( $oe1->password, $ENV{OPENEHR_PASSWORD},
        'Default Password set from environment' );
}
else {
    is( $oe1->password, $local_config{password},
        'Default Password set from conf file' );
}

if ( $ENV{OPENEHR_URL} ) {
    is( $oe1->url, $ENV{OPENEHR_URL},
        'Default URL for server set from environment' );
}
else {
    is( $oe1->url, $local_config{url},
        'Default URL for server set from conf file' );
}

if ( $ENV{OPENEHR_BASE_PATH} ) {
    is( $oe1->base_path, $ENV{OPENEHR_BASE_PATH}, 'Base Path set from environment' );
}
else {
    is( $oe1->base_path, $local_config{base_path}, 'Base Path set from conf file' );
}

if ( $ENV{OPENEHR_TEST_EHRID} ) {
    is( $oe1->test_ehrid, $ENV{OPENEHR_TEST_EHRID}, 'Test EHRID set from environment' );
}
else {
    is(
        $oe1->test_ehrid,
        $local_config{test_ehrid},
        'Test EHRID set from conf file'
    );
}

if ( $ENV{OPENEHR_TEST_UID} ) {
    is( $oe1->test_uid, $ENV{OPENEHR_TEST_UID}, 'Test UID set from environment' );
}
else {
    is( $oe1->test_uid, $local_config{test_uid}, 'Test UID set from conf file' );
}

if ( $ENV{OPENEHR_TEST_SUBJECT_ID} ) {
    is(
        $oe1->test_subject_id,
        $ENV{OPENEHR_TEST_SUBJECT_ID},
        'Test Subject ID set from conf file'
    );
}
else {
    is(
        $oe1->test_subject_id,
        $local_config{test_subject_id},
        'Test Subject ID set from conf file'
    );
}

note('Overriding config file values at construction');
my $oe2 = OpenEHR->new(
    user     => 'alfred',
    password => 'teaCake5',
    url      => 'http://www.example.com/'
);

is( $oe2->user,     'alfred',   'User set from constructor params' );
is( $oe2->password, 'teaCake5', 'Password set from constructor params' );
is( $oe2->url, 'http://www.example.com/',
    'URL for server set from constructor params' );
is(
    $oe2->base_path,
    $local_config{base_path},
    'Base path retained from conf file'
);

eval { my $oe3 = OpenEHR->new( url => 'http://localhost:8081' ); };
ok( $@, 'Failed to initialise object with faulty URL' );

done_testing;
