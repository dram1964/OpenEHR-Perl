use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::Elements::ImagingExam::ImagingReport;

my $imaging_report = OpenEHR::Composition::Elements::ImagingExam::ImagingReport->new(
    clinical_info => 'Clinical information provided 50',
    comment => ['Comment 44', 'Comment 45'],
    report_text => 'Imaging report text 62',
    imaging_diagnosis => ['Imaging diagnosis 29', 'Imaging Diagnosis 30'],
    findings => 'Findings 69',
    modality => 'Modality 39',
    anatomical_side => 'at0007',
    result_date => DateTime->new(
        year => 2018,
        month => 9,
        day => 14,
        hour => 12, 
        minute => 45,
    ),
    anatomical_site => ['Anatomical site 3', 'Anatomical Site 4'],
    imaging_code => 'Imaging code 87',
    result_status => 'at0009',
    image_file => ['Image file reference 97', 'Image File Reference 98'],
);



for my $format ( (qw/FLAT/) ) {
    ok($imaging_report->composition_format($format), "Set format to $format");
    ok(my $composition = $imaging_report->compose, "Called compose for $format format");
    is(ref($composition), "HASH", "Composition is a HASHREF");
    ok(my $json = $imaging_report->print_json, "Called print_json for $format format");
    print Dumper $composition;
}

done_testing;
