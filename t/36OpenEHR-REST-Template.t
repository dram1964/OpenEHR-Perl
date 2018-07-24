use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok('OpenEHR::REST::Template');
}

diag("Testing OpenEHR::REST::Template $OpenEHR::REST::Template::VERSION");

note('Testing get_all_templates method');
{
    ok( my $query = OpenEHR::REST::Template->new(),
        "Template object created" );
    ok( $query->get_all_template_ids, "get_all_templates method" );
    diag( $query->err_msg ) if $query->err_msg;

    for my $template ( @{ $query->data->{templates} } ) {
        ok( $template->{createdOn},  "Created on key found" );
        ok( $template->{templateId}, "Template Id found" );
    }
}

note('Testing get_web_template method');
{
    ok( my $query = OpenEHR::REST::Template->new(),
        "Template object created" );
    $query->get_all_template_ids;

    for my $template ( @{ $query->data->{templates} } ) {
        my $template_id = $template->{templateId};
        my $query1 = OpenEHR::REST::Template->new();
        ok( $query1->get_web_template($template_id),
            "get_web_template method called for $template_id"
        );
        ok( $query1->data, "Data attribute set after query" );
        diag( $query1->err_msg ) if $query1->err_msg;
        ok( !$query1->err_msg, "No error message set after query" );
    }
}

note('Testing get_template_example method');
{
    ok( my $query = OpenEHR::REST::Template->new(),
        "Template object created" );
    $query->get_all_template_ids;

    for my $template ( @{ $query->data->{templates} } ) {
        my $template_id = $template->{templateId};
        diag($template_id);
        my $query1 = OpenEHR::REST::Template->new();
        ok(!$query1->data, "Data attribute not set before query");
        for my $format (qw(FLAT STRUCTURED RAW TDD)) {
            ok($query1->get_template_example($template_id, $format), 
                "get_template_example for $template_id in $format format");
            ok($query1->data, "Data attribute set after query");
            diag($query1->err_msg) if $query->err_msg;
            ok(!$query1->err_msg, "No error message set after query");
        }
    }
}


note('Testing call to get_template_xml method');
{
    ok(my $query = OpenEHR::REST::Template->new(), "Template object created");

    my $templateId = 'GEL - Generic Lab Report import.v0';
    ok($query->get_template_xml($templateId), 'get_template_xml method');
    ok($query->xml, "XML attribute set after query");
    diag($query->err_msg) if $query->err_msg;
    ok(!$query->err_msg, "No error message set after query");
}

note('Testing get_template_xsd method');
{
    ok(my $query = OpenEHR::REST::Template->new(), "Template object created");

    my $templateId = 'GEL - Generic Lab Report import.v0';
    ok($query->get_template_xsd($templateId), "get template xsd");
    ok($query->xml, "XML attribute set after query");
    diag($query->err_msg) if $query->err_msg;
    ok(!$query->err_msg, "No error message set after query");
}

done_testing;
