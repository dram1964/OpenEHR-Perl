use Test::More;

use OpenEHR;

note("testing OpenEHR base module version $OpenEHR::VERSION");
ok( my $open_ehr = OpenEHR->new(), "OpenEHR constructor" );
ok( ref($open_ehr) eq 'OpenEHR', "Object Type" );

note("Testing configuration file settings");
my $config_file = 'OpenEHR.conf';
ok( -f $config_file, "Config file exists" );
ok( open( my $fh, '<', $config_file ), "Config file is readable" );
my %config;

while ( my $line = <$fh> ) {
    next if $line =~ /^[#|\s]/;
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    note("Param($param) value($value)");
    $config{$param} = $value;
}

my $oe1 = OpenEHR->new();

is( $oe1->user, $config{user}, "Default User set from conf file" );
is( $oe1->password, $config{password},
    "Default Password set from conf file" );
is( $oe1->url, $config{url}, "Default URL for server set from conf file" );
is( $oe1->language_code, $config{language_code},
    "Default language code set from conf file" );
is( $oe1->language_terminology,
    $config{language_terminology},
    "Default language terminology set from conf file"
);
is( $oe1->territory_code, $config{territory_code},
    "Default territory code set from conf file" );
is( $oe1->territory_terminology,
    $config{territory_terminology},
    "Default territory terminology set from conf file"
);
is( $oe1->encoding_code, $config{encoding_code},
    "Default encoding code set from conf file" );
is( $oe1->encoding_terminology,
    $config{encoding_terminology},
    "Default encoding terminology set from conf file"
);
is( $oe1->base_path,  $config{base_path},  "Base path set from conf file" );
is( $oe1->test_ehrid, $config{test_ehrid}, "Test EHRID set from conf file" );
is( $oe1->test_uid,   $config{test_uid},   "Test UID set from conf file" );
is( $oe1->test_subjectid, $config{test_subjectid},
    "Test Subject ID set from conf file" );

my $oe2 = OpenEHR->new(
    user     => 'alfred',
    password => 'teaCake5',
    url      => 'http://www.example.com/'
);

is( $oe2->user,     'alfred',   "User set from constructor params" );
is( $oe2->password, 'teaCake5', "Password set from constructor params" );
is( $oe2->url, 'http://www.example.com/',
    "URL for server set from constructor params" );
is( $oe2->language_code, $config{language_code},
    "Default language code retained from conf file" );
is( $oe2->language_terminology,
    $config{language_terminology},
    "Default language terminology retained from conf file"
);
is( $oe2->territory_code, $config{territory_code},
    "Default territory code retained from conf file" );
is( $oe2->territory_terminology,
    $config{territory_terminology},
    "Default territory terminology retained from conf file"
);
is( $oe2->base_path, $config{base_path},
    "Base path retained from conf file" );

eval { my $oe3 = OpenEHR->new( url => 'http://localhost:8081' ); };
ok( $@, 'Failed to initialise object with faulty URL' );

done_testing;
