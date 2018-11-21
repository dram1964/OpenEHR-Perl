use DBIx::Class::Schema::Loader qw/ make_schema_at /;

make_schema_at(
    'Genomes_100K::Schema',
    {
        debug          => 1,
        dump_directory => './lib',
    },
    [
        'dbi:ODBC:DSN=CRIUGenomesLiveTest',
        'dr00', 'letmein', { LongReadLen => 80, LongTruncOk => 1 }
    ],
);
