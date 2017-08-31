if result.type == 'drugs'
  json.searchTerm result.search_term
  json.drugName result.identifier.name
  json.chemblId result.identifier.chembl_id
  json.interactions result.interactions do |interaction|
    json.interactionId interaction.interaction_id
    json.interactionTypes interaction.types
    json.geneName interaction.gene_name
    json.geneLongName interaction.gene_long_name
    json.geneEntrezId interaction.gene_entrez_id
    json.sources interaction.source_db_names
    json.pmids interaction.publications
  end
else
  json.searchTerm result.search_term
  json.geneName result.identifier.name
  json.geneLongName result.identifier.long_name
  json.entrezId result.identifier.entrez_id
  json.geneCategories result.identifier.gene_categories
  json.interactions result.interactions do |interaction|
    json.interactionId interaction.interaction_id
    json.interactionTypes interaction.types
    json.drugName interaction.drug_name
    json.drugChemblId interaction.drug_chembl_id
    json.sources interaction.source_db_names
    json.pmids interaction.publications
  end
end
