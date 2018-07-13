use Test::More tests => 21;

BEGIN {
    use_ok('OpenEHR');
    use_ok('OpenEHR::Composition');
    use_ok('OpenEHR::Composition::Filler');
    use_ok('OpenEHR::Composition::LabResult');
    use_ok('OpenEHR::Composition::LabResultReport');
    use_ok('OpenEHR::Composition::LabTest');
    use_ok('OpenEHR::Composition::LabTestPanel');
    use_ok('OpenEHR::Composition::OrderingProvider');
    use_ok('OpenEHR::Composition::Placer');
    use_ok('OpenEHR::Composition::Professional');
    use_ok('OpenEHR::Composition::RequestedTest');
    use_ok('OpenEHR::Composition::Requester');
    use_ok('OpenEHR::Composition::Specimen');
    use_ok('OpenEHR::Composition::TestRequestDetails');
    use_ok('OpenEHR::REST');
    use_ok('OpenEHR::REST::AQL');
    use_ok('OpenEHR::REST::Demographics');
    use_ok('OpenEHR::REST::EHR');
    use_ok('OpenEHR::REST::Composition');
    use_ok('OpenEHR::REST::Template');
    use_ok('OpenEHR::REST::View');
}

diag("Testing OpenEHR $OpenEHR::VERSION");
