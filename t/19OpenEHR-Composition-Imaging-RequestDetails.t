use strict;
use warnings;

use Test::More;
use Data::Dumper;
use DateTime;

use OpenEHR::Composition::Elements::ImagingExam::RequestDetail;
use OpenEHR::Composition::Elements::ImagingExam::Requester;
use OpenEHR::Composition::Elements::ImagingExam::Receiver;
use OpenEHR::Composition::Elements::ImagingExam::ReportReference;

=for inclusion 
=cut

my $requester = OpenEHR::Composition::Elements::ImagingExam::Requester->new(
    id => '1232341234234',
);
my $receiver = OpenEHR::Composition::Elements::ImagingExam::Receiver->new(
    id => 'rec-1235',
);
my $report_reference = OpenEHR::Composition::Elements::ImagingExam::ReportReference->new(
    id => '99887766',
);

my $request_details = OpenEHR::Composition::Elements::ImagingExam::RequestDetail->new(
    requester => $requester,
    receiver => $receiver,
    report_reference => $report_reference,
    exam_request => [ qw/ Request1 Request2/ ],
    dicom_url => 'http://uclh.dicom.store/image_1',
);



for my $format ( (qw/FLAT/) ) {
    ok($request_details->composition_format($format), "Set format to $format");
    ok(my $composition = $request_details->compose, "Called compose for $format format");
    is(ref($composition), "HASH", "Composition is a HASHREF");
    ok(my $json = $request_details->print_json, "Called print_json for $format format");
    print Dumper $composition;
}


done_testing;
