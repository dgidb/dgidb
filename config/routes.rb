DruggableGene::Application.routes.draw do
  get 'interactions/:id' => 'interactions#show', constraints: { name: /[^\/]+/ }
  get 'gene_claims/:source_db_name/:name' => 'gene_claims#show'
  get 'drug_claims/:source_db_name/:name' => 'drug_claims#show'
  get 'gene_names' => 'genes#names'
  # add a drug_names thing here, so that they can be pulled via json?
  get 'drug_names' => 'drugs#names'
  get 'genes/:name' => 'genes#show', as: 'gene'
  get 'interaction_claims/:id' => 'interaction_claims#show', as: 'interaction_claims'
  get 'druggable_gene_categories/:name' => 'genes#druggable_gene_category', as: 'gene_by_category'
  get 'druggable_gene_categories' => 'genes#druggable_gene_categories'
  get 'drugs/:name' => 'drugs#show', as: 'drug', name: /.*/
  get 'sources/:source_db_name' => 'sources#show', as: 'source'
  get 'sources' => 'sources#sources'
  get 'search_results' => 'search#search_results'
  get 'cache/invalidate' => 'utilities#invalidate_cache'
  get 'downloads' => 'downloads#show'
  post  'download_table' => 'utilities#download_request_content'
  scope 'api' do
    scope 'v1' do
      post  'interactions' => 'services_v1#interactions'
      post  'related_genes' => 'services_v1#related_genes'
      get 'gene_categories' => 'services_v1#gene_categories'
      get 'drug_types' => 'services_v1#drug_types'
      get 'interaction_types' => 'services_v1#interaction_types'
      get 'interaction_sources' => 'services_v1#interaction_sources'
      get 'source_trust_levels' => 'services_v1#source_trust_levels'
      get 'gene_categories_for_sources' => 'services_v1#gene_categories_for_sources'
      get 'genes_in_category' => 'services_v1#genes_in_category'
      get 'related_genes' => 'services_v1#related_genes'
      get 'interactions' => 'services_v1#interactions'
      get 'gene_id_mapping' => 'services_v1#gene_id_mapping'
    end
    scope 'v2' do
      post  'interactions' => 'services_v2#interactions'
      post  'related_genes' => 'services_v2#related_genes'
      get 'genes' => 'services_v2#genes'
      get 'drugs' => 'services_v2#drugs'
      get 'interactions' => 'services_v2#interactions'
      get 'related_genes' => 'services_v2#related_genes'
      get 'gene_id_mapping' => 'services_v2#gene_id_mapping'
      get 'gene_categories' => 'services_v2#gene_categories'
      get 'interaction_types' => 'services_v2#interaction_types'
      get 'interaction_sources' => 'services_v2#interaction_sources'
      get 'source_trust_levels' => 'services_v2#source_trust_levels'
      get 'gene_categories_for_sources' => 'services_v2#gene_categories_for_sources'
      get 'genes_in_category' => 'services_v2#genes_in_category'
      get   'genes/:entrez_id' => 'services_v2#gene_details'
      get   'drugs/:chembl_id' => 'services_v2#drug_details'
      get   'interactions/:id' => 'services_v2#interaction_details'
    end
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web, at: '/jobs'
  end
  match 'interaction_search_results/:name' => 'interaction_claims#interaction_search_results', name: /.*[^#]/, via: [:get, :post]
  match 'interaction_search_results' => 'interaction_claims#interaction_search_results', via: [:get, :post]
  match 'interactions_for_related_genes' => 'interaction_claims#interactions_for_related_genes', via: [:get, :post]
  match 'categories_search_results' => 'genes#categories_search_results', via: [:get, :post]
  get 'home' => 'static#home'
  get 'search_categories' => 'static#search_categories'
  get 'search_interactions' => 'static#search_interactions'
  get 'news' => 'static#news'
  get 'api' => 'static#api'
  get 'api_v1' => 'static#api_v1'
  get 'contact' => 'static#contact'
  get 'downloads' => 'static#downloads'
  get 'faq' => 'static#faq'
  get 'getting_started' => 'static#getting_started'
  get 'search' => 'static#search'
  get 'statistics' => 'static#statistics'
  root :to => 'static#home'
end
