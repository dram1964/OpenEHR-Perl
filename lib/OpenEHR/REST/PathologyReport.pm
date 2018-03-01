package OpenEHR::REST::PathologyReport;

use warnings;
use strict;
use Carp;
use Moose; 
use JSON;
use Data::Dumper;
extends 'OpenEHR::REST';

use version; our $VERSION = qv('0.0.3');

has     resource        => (
    is      =>  'rw', 
    isa     =>  'Str', 
    default =>  'composition',
);
has 	report_id	    => (
    is      =>  'rw', 
    isa     =>  'Str', 
    default => 'Report ID 36',
);
has 	results	        => (
    is      =>  'rw', 
    isa     =>  'ArrayRef[OpenEHR::Model::PathTest]',
);
has 	comment 	    => (
    is      =>  'rw', 
    isa     =>  'OpenEHR::Model::PatientComment',
);
has 	composition     => (
    is      =>  'rw',
);
has     compositionUid  => (
    is      =>  'rw', 
    isa     =>  'Str',
);
has     action          => (
    is      =>  'rw', 
    isa     => 'Str',
);
has     href	        => (
    is      =>  'rw', 
    isa     => 'Str',
);
has     err_msg         => (
    is      =>  'rw', 
    isa     =>  'Str',
);
has     templateId	    => (is  =>  'rw');
has     deleted	        => (is  =>  'rw');
has     lastVersion     => (is  =>  'rw');

sub find_by_uid {
	my $self = shift; 
	my $compositionUid = shift;
    $self->query({format => $self->request_format});
	if ($self->request_format eq 'TDD') {
        $self->headers([['Accept', 'application/xml']]);
	}
    else {
        $self->headers([['Accept', 'application/json']]);
	}
    $self->resource('composition/' . $compositionUid);
    $self->submit_rest_call;
    if ($self->response_code eq '200') {
		my $query_response;
		if ($self->request_format eq 'TDD') {
			$self->err_msg('XML responses from TDD not handled yet');
			$self->templateId('XML responses from TDD not handled yet');
            $self->response_format('TDD');
			$self->composition($self->response);
			$self->deleted(0);
			$self->lastVersion(0);
		} else {
			$query_response = from_json($self->response);
			$self->response_format($query_response->{format});
			$self->templateId($query_response->{templateId});
			$self->composition($query_response->{composition});
			$self->deleted($query_response->{deleted});
			$self->lastVersion($query_response->{lastVersion});
		}
		return 1;
	} else {
			$self->err_msg($self->response);
		carp "*** Error Unhandled Response Code: " . $self->response_code . " ***";
	}
}

sub update_by_uid {
	my $self = shift;
	my $compositionUid = shift;
    $self->query({
		templateId => 'GEL - Generic Lab Report import.v0',
		format => $self->request_format,
		committer => $self->composer_name,
	});
    $self->resource('composition/' . $compositionUid);
    $self->headers([['Content-Type', 'application/json']]);
    $self->method('PUT');
    $self->submit_rest_call($self->composition);
    if ($self->response_code eq '200') {
		my $post_response = from_json( $self->response);
		$self->compositionUid($post_response->{compositionUid});
		$self->action($post_response->{action});
		$self->href($post_response->{meta}->{href});
		return 1;
	} else {
		carp "Response Code: " . $self->response_code;
		carp "Composition: " . $self->composition;
		$self->err_msg($self->response);
        carp $self->err_msg;
		return 0;
	}
}
	
sub submit_new {
	my $self = shift;
	my $ehrId = shift;
    if ($self->request_format eq 'RAW') {
        $self->query({
            ehrId => $ehrId,
            format => $self->request_format,
            committer => $self->composer_name,
        });
    }
    else {
        $self->query({
            ehrId => $ehrId,
            format => $self->request_format,
            committer => $self->composer_name,
            templateId => 'GEL - Generic Lab Report import.v0',
        });
    }

    $self->headers([['Content-Type', 'application/json']]);
    $self->method('POST');
    $self->submit_rest_call($self->composition);
    if ($self->response_code eq '201') {
		my $post_response = from_json( $self->response);
		$self->compositionUid($post_response->{compositionUid});
		$self->action($post_response->{action});
		$self->href($post_response->{meta}->{href});
		return 1;
	} else {
		carp "Response Code: " . $self->response_code;
		carp "Composition: " . $self->composition;
		$self->err_msg($self->response);
		return 0;
	}
}

sub compose {
	my $self = shift;
	my $composer = 'compose_' . $self->request_format;
	$self->$composer();
}

sub compose_TDD {
    my $self = shift;
    $self->request_format('STRUCTURED');
    my $composer = 'compose_' . $self->request_format;
    $self->$composer();
}

sub compose_STRUCTURED {
	my $self = shift;
	my $patient_comment = [ {
		'_other_participation' => [
			{
			'|function' => 'requester',
			'|mode' => 'face-to-face communication',
			'|name' => 'Dr. Marcus Johnson',
			'|id' => '199'
			},
			{
			'|mode' => 'not specified',
			'|name' => 'Lara Markham',
			'|function' => 'performer',
			'|id' => '198'
			}
		],
		'encoding' => [
			{
			'|code' => $self->encoding_code,
			'|terminology' => $self->encoding_terminology
			}
		],
		'comment' => [
			$self->comment->comment
		],
		'language' => [
			{
			'|terminology' => $self->language_terminology,
			'|code' => $self->language_code
			}
		]
	} ];
	my $laboratory_test;
	for my $result (@{$self->results}) {
		my $labtest = $result->get_result_composition($self->request_format);
		push @$laboratory_test, $labtest;
	}
	my $composer = [ { '|name' => $self->composer_name } ];
	my $context = [ {
		'setting' => [
			{
			'|code' => '238',
			'|value' => 'other care',
			'|terminology' => 'openehr'
			}
		],
		'report_id' => [
			$self->report_id
		],
		'_health_care_facility' => [
			{
			'|id' => 'RRV',
			'|id_namespace' => 'UCLH-NS',
			'|name' => 'Hospital',
			'|id_scheme' => 'UCLH-NS'
			}
		],
		'start_time' => [
			'2017-12-05T09:53:27Z'
		]
	} ];
	my $language = [{ 
        '|terminology' => $self->language_terminology, 
        '|code' => $self->language_code 
    }];
	my $uid = [ '8b7e4490-4d8d-4f55-858f-a782b310a2b3::default::1' ];
	my $territory = [{ 
        '|terminology' => $self->territory_terminology, 
        '|code' => $self->territory_code
    }];

	my $composition = {
		'laboratory_result_report' => {
			'context' => $context,
			'laboratory_test' => $laboratory_test,
			'patient_comment' => $patient_comment,
			'composer' => $composer,
			'language' => $language,
			'_uid' => $uid,
			'territory' => $territory
		}
	};
	$self->composition(to_json($composition));
}

sub compose_RAW {
    my $self = shift;
    my (    
        $composer,              $content,           $territory,
        $category,              $class,             $laboratory_test,
        $patient_comment,       $language,          $uid,
        $archetype_node_id,     $name,              $archetype_details,
        $context,
    );
    
    $composer = {
        'name' => 'David Ramlakhan',
        '@class' => 'PARTY_IDENTIFIED'
    };

    $content = [];
    for my $result (@{$self->results}) {
		my $labtest = $result->get_result_composition($self->request_format);
		push @$content, $labtest;
	}
    my $evaluation; 
    push @$content, $evaluation if $evaluation;

    $territory = {
        '@class' => 'CODE_PHRASE',
        'terminology_id' => {
            '@class' => 'TERMINOLOGY_ID',
            'value' => 'ISO_3166-1'
        },
        'code_string' => 'GB'
    };

    $category = {
        'value' => 'event',
        '@class' => 'DV_CODED_TEXT',
        'defining_code' => {
            'code_string' => '433',
            '@class' => 'CODE_PHRASE',
            'terminology_id' => {
                '@class' => 'TERMINOLOGY_ID',
                'value' => 'openehr'
            }
        }
    };
    
    $class = 'COMPOSITION';

    $context = {
        'other_context' => {
            'name' => {
                '@class' => 'DV_TEXT',
                'value' => 'Tree'
            },
            '@class' => 'ITEM_TREE',
            'items' => [{
                'value' => {
                    'value' => $self->report_id, #'17V444999',
                    '@class' => 'DV_TEXT'
                },
                'archetype_node_id' => 'at0002',
                '@class' => 'ELEMENT',
                'name' => {
                    '@class' => 'DV_TEXT',
                    'value' => 'Report ID'
                }
            }],
            'archetype_node_id' => 'at0001'
        },
        'setting' => {
            'value' => 'other care',
            '@class' => 'DV_CODED_TEXT',
            'defining_code' => {
                'terminology_id' => {
                    '@class' => 'TERMINOLOGY_ID',
                    'value' => 'openehr'
                },
                '@class' => 'CODE_PHRASE',
                'code_string' => '238'
            }
        },
        '@class' => 'EVENT_CONTEXT',
        'health_care_facility' => {
            '@class' => 'PARTY_IDENTIFIED',
            'name' => 'Hospital',
            'external_ref' => {
                'namespace' => 'UCLH-NS',
                'type' => 'ANY',
                'id' => {
                    'scheme' => 'UCLH-NS',
                    'value' => 'RRV',
                    '@class' => 'GENERIC_ID'
                },
                '@class' => 'PARTY_REF'
            }
        },
        'start_time' => {
            'value' => '2017-12-05T09:53:27Z',
            '@class' => 'DV_DATE_TIME'
        }
    };

    $language = {
        'terminology_id' => {
            'value' => 'ISO_639-1',
            '@class' => 'TERMINOLOGY_ID'
        },
        '@class' => 'CODE_PHRASE',
        'code_string' => 'en'
    };

    $uid = {
        '@class' => 'OBJECT_VERSION_ID',
        'value' => '8e741a7e-defd-4f74-b839-5784f66fc4cb::default::1',
    };

    $archetype_node_id = 'openEHR-EHR-COMPOSITION.report-result.v1';

    $name = {
        '@class' => 'DV_TEXT',
        'value' => 'Laboratory Result Report'
    };

    $archetype_details = {
        '@class' => 'ARCHETYPED',
            'archetype_id' => {
            '@class' => 'ARCHETYPE_ID',
            'value' => 'openEHR-EHR-COMPOSITION.report-result.v1'
        },
        'rm_version' => '1.0.1',
        'template_id' => {
            '@class' => 'TEMPLATE_ID',
            'value' => 'GEL - Generic Lab Report import.v0'
        }
    };
    
	my $composition = {
        composer    => $composer,
        content     => $content,
        territory   => $territory, 
        category    => $category, 
        '@class'    => $class,
        context     => $context,
        language    => $language,
        archetype_node_id => $archetype_node_id,
        name        => $name,
        archetype_details   => $archetype_details,
    };
    #    uid         => $uid,

	$self->composition(to_json($composition));
}


sub compose_FLAT {
	my $self = shift;
	my $composition = "{";
	$composition .= "\"ctx/language\":\"" . $self->language_code . "\",
				\"ctx/territory\":\"" . $self->territory_code . "\",
				\"ctx/composer_name\":\"" . $self->composer_name . "\"";

	$composition .= ",\"ctx/time\":\"" . DateTime->now() . "\",
				\"ctx/id_namespace\": \"UCLH-NS\",
				\"ctx/id_scheme\":\"UCLH-NS\",
				\"ctx/participation_name\":\"Dr. Marcus Johnson\",
				\"ctx/participation_function\":\"requester\",
				\"ctx/participation_mode\":\"face-to-face communication\",
				\"ctx/participation_id\":\"199\",
				\"ctx/participation_name:1\":\"Lara Markham\",
				\"ctx/participation_function:1\":\"performer\",
				\"ctx/participation_id:1\":\"198\",
				\"ctx/health_care_facility|name\":\"Hospital\",
				\"ctx/health_care_facility|id\":\"RRV\",
				\"laboratory_result_report/context/report_id\":\"" . $self->report_id . "\"";

	my $index = '0';
	for my $result (@{$self->results}) {
		$composition .= 
				",\"laboratory_result_report/laboratory_test:$index/requested_test\":\"" . $result->request_test . "\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/specimen_type\":\"" . $result->specimen_type . "\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/datetime_collected\":\"" . $result->datetime_collected . "\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/collection_method\":\"Collection method 96\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/processing/datetime_received\":\"" . $result->datetime_received . "\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/processing/laboratory_specimen_identifier\":\"" . $result->sample_number . "\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/processing/laboratory_specimen_identifier|issuer\":\"Issuer\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/processing/laboratory_specimen_identifier|assigner\":\"Assigner\",
				\"laboratory_result_report/laboratory_test:$index/specimen:0/processing/laboratory_specimen_identifier|type\":\"Prescription\",
				\"laboratory_result_report/laboratory_test:$index/test_status|code\":\"" . $result->test_status_code . "\",
				\"laboratory_result_report/laboratory_test:$index/test_status_timestamp\":\"" . $result->test_status_timestamp . "\",
				\"laboratory_result_report/laboratory_test:$index/clinical_information_provided\":\"" . $result->clinical_info . "\",
				\"laboratory_result_report/laboratory_test:$index/laboratory_test_panel:0/laboratory_result:0/result_value/value\":\"" . $result->result_value . "\",
				\"laboratory_result_report/laboratory_test:$index/laboratory_test_panel:0/laboratory_result:0/comment\":\"" . $result->result_comment . "\",
				\"laboratory_result_report/laboratory_test:$index/laboratory_test_panel:0/laboratory_result:0/reference_range_guidance\":\"" . $result->ref_range . "\",
				\"laboratory_result_report/laboratory_test:$index/laboratory_test_panel:0/laboratory_result:0/result_status|code\":\"" . $result->result_status_code . "\",
				\"laboratory_result_report/laboratory_test:$index/conclusion\":\"Conclusion 34\",
				\"laboratory_result_report/laboratory_test:$index/responsible_laboratory/name_of_organisation\":\"Name of Organisation 70\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/placer_order_number\":\"" . $result->order_number . "\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/placer_order_number|issuer\":\"Issuer\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/placer_order_number|assigner\":\"Assigner\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/placer_order_number|type\":\"Prescription\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/filler_order_number\":\"074ca7dc-918f-440e-a398-19a15d54fff9\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/filler_order_number|issuer\":\"Issuer\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/filler_order_number|assigner\":\"Assigner\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/filler_order_number|type\":\"Prescription\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/ordering_provider/ordering_provider/given_name\":\"Given name 61\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/ordering_provider/ordering_provider/family_name\":\"Family name 87\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/professional_identifier\":\"9a73522e-3c3a-4b68-ab4f-2ed03af302ca\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/professional_identifier|issuer\":\"Issuer\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/professional_identifier|assigner\":\"Assigner\",
				\"laboratory_result_report/laboratory_test:$index/test_request_details/requester/professional_identifier|type\":\"Prescription\"";
				$index++;
	}
	if ($self->comment->comment) {
	    $composition .= ",\"laboratory_result_report/patient_comment/comment\":\"" . $self->comment->comment . "\",
				\"laboratory_result_report/patient_comment/encoding|code\":\"" . $self->encoding_code . "\",
				\"laboratory_result_report/patient_comment/encoding|terminology\":\"" . $self->encoding_terminology . "\",
				\"laboratory_result_report/patient_comment/language|terminology\":\"" . $self->language_terminology . "\",
				\"laboratory_result_report/patient_comment/language|code\":\"" . $self->language_code . "\"";
	}

    $composition = '{
        
    }';

    $composition = '{
"ctx/language" : "en",
"ctx/territory" :   "GB",
"ctx/composer_name" :   "Silvia Blake",
"ctx/time" : "2017-08-21T19:26:52.839+02:00",
"ctx/id_namespace" : "HOSPITAL-NS",
"ctx/id_scheme" : "HOSPITAL-NS",
"ctx/health_care_facility|name" : "Hospital",
"ctx/health_care_facility|id" : "9091",
"laboratory_result_report/context/report_id" :  "Report ID 14",
"laboratory_result_report/laboratory_test:0/requested_test" : "Coagulation Screen",
"laboratory_result_report/laboratory_test:0/requested_test|value" : "Coagulation Screen",
"laboratory_result_report/laboratory_test:0/requested_test|code" :  "H501",
"laboratory_result_report/laboratory_test:0/requested_test|terminology" :   "L",
"laboratory_result_report/laboratory_test:0/requested_test/_mapping:0/target|code" : "H501",
"laboratory_result_report/laboratory_test:0/requested_test/_mapping:0/target|terminology" : "L",
"laboratory_result_report/laboratory_test:0/requested_test/_mapping:0|match" :  "=",
"laboratory_result_report/laboratory_test:0/specimen:0/specimen_type" : "Specimen type 87",
"laboratory_result_report/laboratory_test:0/history_origin" :   "2017-08-21T19:26:52.84+02:00",
"laboratory_result_report/laboratory_test:0/specimen:0/datetime_collected" : "2017-08-21T19:26:52.84+02:00",
"laboratory_result_report/laboratory_test:0/specimen:0/collection_method" : "Collection method 37",
"laboratory_result_report/laboratory_test:0/specimen:0/processing/datetime_received" :  "2017-08-21T19:26:52.841+02:00",
"laboratory_result_report/laboratory_test:0/specimen:0/processing/laboratory_specimen_identifier" : "17b7f032-ee25-48b0-8bd3-2e151938cefc",
"laboratory_result_report/laboratory_test:0/specimen:0/processing/laboratory_specimen_identifier|issuer" :  "Issuer",
"laboratory_result_report/laboratory_test:0/specimen:0/processing/laboratory_specimen_identifier|assigner" : "Assigner",
"laboratory_result_report/laboratory_test:0/specimen:0/processing/laboratory_specimen_identifier|type" : "Prescription",
"laboratory_result_report/laboratory_test:0/test_status|code" : "at0107",
"laboratory_result_report/laboratory_test:0/test_status_timestamp" : "2017-08-21T19:26:52.841+02:00",
"laboratory_result_report/laboratory_test:0/clinical_information_provided" : "Clinical information provided 65",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name|value" :  "Sodium",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name|code" : "365761000",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name|terminology" : "LOINC",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name/_mapping:0/target|code" : "123456",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name/_mapping:0/target|terminology" : "L",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/_name/_mapping:0|match" : "=",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2|magnitude" :   "133",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2|magnitude_status" : "<",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2|unit" : "mmol/l",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value" : "Normal",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2|normal_status" : "H",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/reference_range_guidance" : "Reference range guidance 29",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/comment" : "Comment 94",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_status|code" : "at0009",
"laboratory_result_report/laboratory_test:0/conclusion" :   "Conclusion 11",
"laboratory_result_report/laboratory_test:0/responsible_laboratory/name_of_organisation" :  "Name of Organisation 12",
"laboratory_result_report/laboratory_test:0/test_request_details/placer_order_number" : "7177549e-f5bc-4bc0-92e6-808780934915",
"laboratory_result_report/laboratory_test:0/test_request_details/placer_order_number|issuer" :  "Issuer",
"laboratory_result_report/laboratory_test:0/test_request_details/placer_order_number|assigner" : "Assigner",
"laboratory_result_report/laboratory_test:0/test_request_details/placer_order_number|type" : "Prescription",
"laboratory_result_report/laboratory_test:0/test_request_details/filler_order_number" : "6b705b10-860b-4039-bd89-221e6f71d51f",
"laboratory_result_report/laboratory_test:0/test_request_details/filler_order_number|issuer" : "Issuer",
"laboratory_result_report/laboratory_test:0/test_request_details/filler_order_number|assigner" : "Assigner",
"laboratory_result_report/laboratory_test:0/test_request_details/filler_order_number|type" : "Prescription",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/ordering_provider/ordering_provider/given_name" : "Given name 48",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/ordering_provider/ordering_provider/family_name" : "Family name 3",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/professional_identifier" : "2920c271-307b-4c00-96a0-b90202498abd",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/professional_identifier|issuer" : "Issuer",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/professional_identifier|assigner" : "Assigner",
"laboratory_result_report/laboratory_test:0/test_request_details/requester/professional_identifier|type" : "Prescription",
"laboratory_result_report/patient_comment/comment" : "Comment 28"
    }';
=head2 not_supported
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2/_normal_range/lower|magnitude" : "133",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2/_normal_range/lower|unit" : "mmol/l",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2/_normal_range/upper|magnitude" : "146",
"laboratory_result_report/laboratory_test:0/laboratory_test_panel:0/laboratory_result:0/result_value/value2/_normal_range/upper|unit" : "mmol/l",
=cut

	$self->composition($composition);
}


no Moose;



__PACKAGE__->meta->make_immutable;


__END__

=head1 NAME

OpenEHR::REST::PathologyReport - Used for managing Compositions
in the 'GEL - Generic Lab Report import.v0' template format. 


=head1 VERSION

This document describes OpenEHR::REST::PathologyReport version 0.0.1


=head1 SYNOPSIS

    use OpenEHR::REST::PathologyReport;

    my $path_report1 = OpenEHR::REST::PathologyReport->new();
    $path_report1->report_id('17V333999');
    $path_report1->results([$path_test1, $path_test2]);
    $path_report1->comment($comment);
    $path_report1->Request_format('FLAT');
    $path_report1->compose();

    $path_report1->submit_new($ehr->ehrId);
    warn ("Error occurred in submission: " . $path_report1->err_msg)
        if $path_report1->err_msg;
    $path_report1->action; # 'CREATE' if successful;
    $path_report1->compositionUid # the returned CompositionUid;
    $path_report1->href # URL to view the submitted composition;


=head1 DESCRIPTION

Use this module to submit and modify Pathology compositions in the
'GEL - Generic Lab Report import.v0' template format.


=head1 METHODS

=head2 report_id($id)

Sets the report identifier for the composition

=head2 results($result_arrayref)

Adds an array of OpenEHR::Model::Array objects to the composition

=head2 comment($comment)

Adds an OpenEHR::Model::Comment object to the composition

=head2 compose()

Once data has been loaded to an OpenEHR::REST::PathologyReport object,
this method is used to create a composition in the desired format. 
Currently only FLAT and STRUCTURED formats are supported. This method
will call one of compose_[ FLAT | STRUCTURED | RAW | TDD ] to create the 
composition and the resulting composition is stored in the objects
composition attribute

=head2 submit_new($ehrId)

Submits the composition as a new composition to the database 
for the specified ehrId in the format specified by the second parameter. 
Currently only FLAT and STRUCTURED formats are supported

=head2 find_by_uid($uid)

Search the OpenEHR database for a composition with uid value of $uid.
A successful query will save the composition returned in the object's
composition attribute in the format specified by the second parameter. 
Format can be one of: [RAW, STRUCTURED, FLAT, TDD]. If the query results 
is unsuccessful then err_msg is set to the response content. 
The TDD format is not currently implemented and requests for TDD 
format compositions will also set the err_msg value. 
 
Successful queries set the objects format, templateId, composition,
deleted and lastVersion attributes with the corresponding result
response

=head2 update_by_uid($uid)

Submits an update to an existing composition. The UID must be specified as the 
methods only parameter.


=head1 ATTRIBUTES

=head2 report_id

The report identifier to be used in the composition being submitted

=head2 results

An ArrayRef of OpenEHR::Model::PathTest objects to be used in the REST
call to represent the results being submitted with the composition

=head2 comment

An OpenEHR::Model::PatientComment object to be used in the REST call
to represent a patient comment being submitted with the composition

=head2 composition

The composition data for the object in the specified format

=head2 request_format

The format to be used to construct the composition. Can be one of 
[ FLAT | STRUCTURED | RAW | TDD ]. Currently, only FLAT and
STRUCTURED formats are supported. If the request value is set to 
anything other than 'FLAT', the STRUCTURED format is used.

=head2 compositionUid

The UID value for the requested composition. 

=head2 action

The action value returned by the server in response to a REST call

=head2 href

The href values returned by the server in response to a REST call

=head2 err_msg

Failed calls to the REST server, will stored the response content
in the err_msg attribute. This value should be tested following each 
REST call

=head2 templateId

The templateId value returned by the server in response to a REST call

=head2 response_format

The format for a composition returned by the server in response
to a REST call

=head2 deleted

The deleted value returned by the server in response to a REST call

=head2 lastVersion

The lastVersion value returned by the server in response to a REST call
  

=head1 PRIVATE METHODS

=head2 compose_FLAT

returns the pathology composition in 'FLAT' format

=head2 compose_STRUCTURED

returns the pathology composition in 'STRUCTURED' format

=head2 compose_RAW

**** Not Implemented yet **** 
returns the pathology composition in 'RAW' format

=head2 compose_TDD

**** Not Implemented yet **** 
returns the pathology composition in 'TDD' format


=head1 PRIVATE ATTRIBUTES

=head2 resource 

The path relative to base_path to be used in the REST call


=head1 DIAGNOSTICS

Use the err_msg attribute of the object to check for errors following a REST call


=head1 CONFIGURATION AND ENVIRONMENT

OpenEHR::REST::PathologyReport requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-openehr-rest-pathologyreport@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Ramlakhan  C<< <dram1964@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2017, David Ramlakhan C<< <dram1964@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
