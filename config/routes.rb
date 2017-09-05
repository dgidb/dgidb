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
  post  'download_table' => 'utilities#download_request_content'
  scope 'api' do
    scope 'v1' do
      post  'interactions' => 'services_v1#interactions'
      post  'related_genes' => 'services_v1#related_genes'
      get   ':action' => 'services_v1#:action'
    end
    scope 'v2' do
      post  'interactions' => 'services_v2#interactions'
      post  'related_genes' => 'services_v2#related_genes'
      get   ':action' => 'services_v2#:action'
      get   'genes/:entrez_id' => 'services_v2#gene_details'
      get   'drugs/:chembl_id' => 'services_v2#drug_details'
      get   'interactions/:id' => 'services_v2#interaction_details'
    end
  end
  match 'interaction_search_results/:name' => 'interaction_claims#interaction_search_results', name: /.*[^#]/, via: [:get, :post]
  match 'interaction_search_results' => 'interaction_claims#interaction_search_results', via: [:get, :post]
  match 'interactions_for_related_genes' => 'interaction_claims#interactions_for_related_genes', via: [:get, :post]
  match 'categories_search_results' => 'genes#categories_search_results', via: [:get, :post]
  get ':action' => 'static#:action'
  root :to => 'static#search_interactions'
end
