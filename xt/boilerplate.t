#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 31;

sub not_in_file_ok {
    my ($filename, %regex) = @_;
    open( my $fh, '<', $filename )
        or die "couldn't open $filename for reading: $!";

    my %violated;

    while (my $line = <$fh>) {
        while (my ($desc, $regex) = each %regex) {
            if ($line =~ $regex) {
                push @{$violated{$desc}||=[]}, $.;
            }
        }
    }

    if (%violated) {
        fail("$filename contains boilerplate text");
        diag "$_ appears on lines @{$violated{$_}}" for keys %violated;
    } else {
        pass("$filename contains no boilerplate text");
    }
}

sub module_boilerplate_ok {
    my ($module) = @_;
    not_in_file_ok($module =>
        'the great new $MODULENAME'   => qr/ - The great new /,
        'boilerplate description'     => qr/Quick summary of what the module/,
        'stub function definition'    => qr/function[12]/,
    );
}

TODO: {
  local $TODO = "Need to replace the boilerplate text";

  not_in_file_ok(README =>
    "The README is used..."       => qr/The README is used/,
    "'version information here'"  => qr/to provide version information/,
  );

  not_in_file_ok(Changes =>
    "placeholder date/time"       => qr(Date/time)
  );

  module_boilerplate_ok('lib/OpenEHR.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Filler.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/LabResult.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/LabResultReport.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/LabTest.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/LabTestPanel.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Mapping.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/OrderingProvider.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Placer.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Professional.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/RequestedTest.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Requester.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/Specimen.pm');
  module_boilerplate_ok('lib/OpenEHR/Composition/TestRequestDetails.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/Composition.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/EHR.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/EhrAccess.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/EhrStatus.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/EhrSubject.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/PathTest.pm');
  module_boilerplate_ok('lib/OpenEHR/Model/PatientComment.pm');
  module_boilerplate_ok('lib/OpenEHR/REST.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/AQL.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/Demographics.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/EHR.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/PathologyReport.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/Template.pm');
  module_boilerplate_ok('lib/OpenEHR/REST/View.pm');


}

