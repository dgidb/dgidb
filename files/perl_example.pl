use strict;
use warnings;

use JSON;
use HTTP::Request::Common;
use LWP::UserAgent;
use Getopt::Long;
use Data::Dumper qw(Dumper);

my $domain = 'http://dgidb.genome.wustl.edu/';
my $api_path = 'interaction_search_results.json';
my $genes;
my $sources;
my $gene_categories;
my $interaction_types;
my $drug_types;
my $anti_neoplastic_only = '';
my %properties = ( genes => \$genes, sources => \$sources, interaction_types => \$interaction_types, gene_categories => \$gene_categories );
my $ua = LWP::UserAgent->new;

sub parse_opts {
    GetOptions (
        'anti_neoplastic_only' => \$anti_neoplastic_only,
        'gene_names=s'         => \$genes,
        'source_names:s'       => \$sources,
        'interaction_types:s'  => \$interaction_types,
        'category_types:s'     => \$gene_categories,
    );
}

sub get_params_for_request {
    my %params;
    for (keys %properties) {
     $params{$_} = ${$properties{$_}} if ${$properties{$_}};
    }
    if ($anti_neoplastic_only) {
        $params{drug_types} = ['antineoplastic'];
    }
    return \%params;
}

sub print_response {
    my $json_ref = shift;
    my %response_body = %{$json_ref};

    #loop over each search term that was definitely matched
    for (@{$response_body{matchedTerms}}) {
        print 'Matched search term: ',  $_->{searchTerm}, ' to gene: ', $_->{geneName}, "\n";
        print $_->{geneName}, " had the following interactions: \n";
        #loop over any interactions for this gene
        foreach my $interaction(@{$_->{interactions}}){
            print Data::Dumper::Dumper($interaction), "\n";
        }
        print $_->{geneName}, " was in the following categories: \n";
        print join(",", @{$_->{geneCategories}}), "\n";
    }

    #loop over each search term that wasn't matched definitely
    #and print suggestions if it was ambiguous
    for (@{$response_body{unmatchedTerms}}) {
        print 'Unmatched search term: ', $_->{searchTerm}, "\n";
        print 'Possible suggestions: ', join(",", @{$_->{suggestions}}), "\n";
    }
}

parse_opts();
my $resp = $ua->request(POST $domain . $api_path, get_params_for_request());
if ($resp->is_success) {
    print_response(decode_json($resp->content));
} else {
    print "Something went wrong! Did you specify any genes?\n";
    exit 1;
}

