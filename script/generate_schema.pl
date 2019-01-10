use DBIx::Class::Schema::Loader qw/ make_schema_at /;

make_schema_at(
    'Genomes_100K::Schema',
    {
        debug          => 1,
        dump_directory => './lib',
        skip_load_external => 1,
    },
    [
        'dbi:ODBC:DSN=CRIUGenomesTest',
        'dr00', 'letmein', { LongReadLen => 80, LongTruncOk => 1 }
    ],
);


make_schema_at(
    'Carecast::Schema',
    {
        debug          => 1,
        dump_directory => './lib',
    },
    [
        'dbi:ODBC:DSN=CRIUCarecastTest',
        'dr00', 'letmein', { LongReadLen => 80, LongTruncOk => 1 }
    ],
);
