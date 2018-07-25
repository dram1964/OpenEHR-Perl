use Test::More;

use OpenEHR;

note('testing OpenEHR base module version $OpenEHR::VERSION');
ok( my $open_ehr = OpenEHR->new(), 'OpenEHR constructor' );
ok( ref($open_ehr) eq 'OpenEHR', 'Object Type' );

note('Testing Local Configuration file settings');
my $local_config_file = 'OpenEHR.conf';
ok( -f $local_config_file, 'Local Configuration file exists' );
ok( open( my $fh, '<', $local_config_file ), 'Local Configuration file is readable' );
my %local_config;

while ( my $line = <$fh> ) {
    next if $line =~ /^[#|\s]/;
    my ( $param, $value ) = $line =~ /(\w*)\s*(.*)/;
    note("Param($param) value($value)");
    $local_config{$param} = $value;
}

my $oe1 = OpenEHR->new();

is( $oe1->user, $local_config{user}, 'Default User set from conf file' );
is( $oe1->password, $local_config{password},
    'Default Password set from conf file' );
is( $oe1->url, $local_config{url}, 'Default URL for server set from conf file' );
is( $oe1->language_code, $local_config{language_code},
    'Default Language code set from conf file' );
is( $oe1->language_terminology,
    $local_config{language_terminology},
    'Default Language terminology set from conf file'
);
is( $oe1->territory_code, $local_config{territory_code},
    'Default Territory Code set from conf file' );
is( $oe1->territory_terminology,
    $local_config{territory_terminology},
    'Default Territory Terminology set from conf file'
);
is( $oe1->encoding_code, $local_config{encoding_code},
    'Default encoding code set from conf file' );
is( $oe1->encoding_terminology,
    $local_config{encoding_terminology},
    'Default encoding terminology set from conf file'
);
is( $oe1->base_path,  $local_config{base_path},  'Base Path set from conf file' );
is( $oe1->test_ehrid, $local_config{test_ehrid}, 'Test EHRID set from conf file' );
is( $oe1->test_uid,   $local_config{test_uid},   'Test UID set from conf file' );
is( $oe1->test_subject_id, $local_config{test_subject_id},
    'Test Subject ID set from conf file' );

is( $oe1->id_namespace,  $local_config{id_namespace},  'Namespace Id set from conf file' );
is( $oe1->id_scheme,  $local_config{id_scheme},  'Scheme Id set from conf file' );
is( $oe1->facility_name,  $local_config{facility_name},  'Facility Name set from conf file' );
is( $oe1->facility_id,  $local_config{facility_id},  'Facility Id set from conf file' );

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
is( $oe2->language_code, $local_config{language_code},
    'Default language code retained from conf file' );
is( $oe2->language_terminology,
    $local_config{language_terminology},
    'Default language terminology retained from conf file'
);
is( $oe2->territory_code, $local_config{territory_code},
    'Default territory code retained from conf file' );
is( $oe2->territory_terminology,
    $local_config{territory_terminology},
    'Default territory terminology retained from conf file'
);
is( $oe2->base_path, $local_config{base_path},
    'Base path retained from conf file' );

eval { my $oe3 = OpenEHR->new( url => 'http://localhost:8081' ); };
ok( $@, 'Failed to initialise object with faulty URL' );


done_testing;
