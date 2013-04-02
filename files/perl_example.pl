#!/usr/bin/env perl

use strict;
use warnings;

#You may need to install the CPAN JSON package before this script will work
#http://www.cpan.org/modules/INSTALL.html
#On a mac you can do the following:
# First configure the 'cpan' tool
# % sudo cpan
# Then at a cpan prompt:
# % get JSON
# % make JSON
# % install JSON
# % q

use JSON;
use HTTP::Request::Common;
use LWP::UserAgent;
use Getopt::Long;
use Data::Dumper qw(Dumper);

my $domain = 'http://dgidb.genome.wustl.edu/';

my $api_path = '/api/v1/interactions.json';
my $genes;
my $sources;
my $gene_categories;
my $interaction_types;
my $drug_types;
my $trust_levels;
my $anti_neoplastic_only = '';
my $help;
my %properties = ( genes => \$genes, interaction_sources => \$sources, interaction_types => \$interaction_types, gene_categories => \$gene_categories, source_trust_levels => \$trust_levels );
my $ua = LWP::UserAgent->new;

parse_opts();
my $resp = $ua->request(POST $domain . $api_path, get_params_for_request());
if ($resp->is_success) {
    print_response(decode_json($resp->content));
} else {
    print "Something went wrong! Did you specify any genes?\n";
    exit 1;
}

sub parse_opts {
    GetOptions (
        'genes=s'              => \$genes,
        'source_names:s'       => \$sources,
        'category_types:s'     => \$gene_categories,
        'interaction_types:s'  => \$interaction_types,
        'antineoplastic_only'  => \$anti_neoplastic_only,
        'source_trust_levels:s'  => \$trust_levels,
        'help'                 => \$help,
    );
    if (!$genes || $help){
        print "\n\nFor complete documentation refer to http://dgidb.genome.wustl.edu/api";
        print "\n\nRequired parameters:";
        print "\n--genes (List of gene symbols. Use offical entrez symbols for best results)";
        print "\n\nOptional parameters:";
        print "\n--source_names (Data sources. e.g. DrugBank, PharmGKB, TALC, TEND, TTD)";
        print "\n--category_types (Druggable gene type. e.g. 'KINASE', 'ION CHANNEL', etc.)";
        print "\n--interaction_types (Mechanism of drug-gene interaction. e.g. 'inhibitor', 'antibody', etc.)";
        print "\n--antineoplastic_only (Limit results to anti-cancer drugs only)";
        print "\n\nExample usage:";
        print "\n./perl_example.pl --genes='FLT3'";
        print "\n./perl_example.pl --genes='FLT3,EGFR,KRAS'";
        print "\n./perl_example.pl --genes='FLT3,EGFR' --source_names='TALC,TEND'";
        print "\n./perl_example.pl --genes='FLT3,EGFR' --category_types='KINASE'";
        print "\n./perl_example.pl --genes='FLT3,EGFR' --interaction_types='inhibitor'";
        print "\n./perl_example.pl --genes='FLT3,EGFR' --source_trust_levels='Expert curated'";
        print "\n./perl_example.pl --genes='FLT3,EGFR' --antineoplastic_only";
        print "\n./perl_example.pl --genes='FLT3,EGFR,KRAS' --source_names='TALC,TEND' --category_types='KINASE' --interaction_types='inhibitor' --antineoplastic_only";
        print "\n\n";
        exit 1;
    }
}

sub get_params_for_request {
    my %params;
    for (keys %properties) {
     $params{$_} = ${$properties{$_}} if ${$properties{$_}};
    }
    if ($anti_neoplastic_only) {
        $params{drug_types} = 'antineoplastic';
    }
    return \%params;
}

sub print_response {
    my $json_ref = shift;
    my %response_body = %{$json_ref};

    print "gene_name\tdrug_name\tinteraction_type\tsource\tgene_categories\n";

    #loop over each search term that was definitely matched
    for (@{$response_body{matchedTerms}}) {
        my $gene_name = $_->{geneName};
        my @gene_categories = @{$_->{geneCategories}};
        my @gene_categories_sort = sort @gene_categories;
        my $gene_categories = join(",", @gene_categories_sort);
        $gene_categories = lc($gene_categories);

        #loop over any interactions for this gene
        foreach my $interaction(@{$_->{interactions}}){
            my $source = $interaction->{'source'};
            my $drug_name = $interaction->{'drugName'};
            my $interaction_type = $interaction->{'interactionType'};
            print "$gene_name\t$drug_name\t$interaction_type\t$source\t$gene_categories\n";    

        }
    }

    #loop over each search term that wasn't matched definitely
    #and print suggestions if it was ambiguous
    for (@{$response_body{unmatchedTerms}}) {
        print "\n" . 'Unmatched search term: ', $_->{searchTerm}, "\n";
        print 'Possible suggestions: ', join(",", @{$_->{suggestions}}), "\n";
    }
}


