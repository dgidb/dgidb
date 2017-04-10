require 'spec_helper'

describe Genome::Groupers::InteractionGrouper do

  it 'should not group two distinct interaction claims' do
    (1..2).map do
      drug = Fabricate(:drug)
      gene = Fabricate(:gene)
      drug_claim = Fabricate(:drug_claim, drug: drug)
      gene_claim = Fabricate(:gene_claim, gene: gene)
      interaction_claim = Fabricate(:interaction_claim, drug_claim: drug_claim, gene_claim: gene_claim)
    end
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::Interaction.all.count).to eq 2
  end

  it 'groups interaction claims with same drug and gene' do
    drug = Fabricate(:drug)
    gene = Fabricate(:gene)
    drug_claim1 = Fabricate(:drug_claim, drug: drug)
    gene_claim1 = Fabricate(:gene_claim, gene: gene)
    Fabricate(:interaction_claim, drug_claim: drug_claim1, gene_claim: gene_claim1)
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::InteractionClaim.all.count).to eq 1
    expect(DataModel::Interaction.all.count).to eq 1

    drug_claim2 = Fabricate(:drug_claim, drug: drug)
    gene_claim2 = Fabricate(:gene_claim, gene: gene)
    interaction_claim_type = Fabricate(:interaction_claim_type)
    Fabricate(:interaction_claim, drug_claim: drug_claim2, gene_claim: gene_claim2, interaction_claim_types: [interaction_claim_type])
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::InteractionClaim.all.count).to eq 2
    expect(DataModel::Interaction.all.count).to eq 1
    expect(DataModel::Interaction.first.interaction_claims.count).to eq 2
  end

  it 'add interaction attributes' do
    drug = Fabricate(:drug)
    gene = Fabricate(:gene)
    (1..2).map do |i|
      drug_claim = Fabricate(:drug_claim, drug: drug)
      gene_claim = Fabricate(:gene_claim, gene: gene)
      source = Fabricate(:source, source_db_name: "Some source#{i}")
      interaction_claim = Fabricate(:interaction_claim, drug_claim: drug_claim, gene_claim: gene_claim, source: source)
      Fabricate(:interaction_claim_attribute, interaction_claim: interaction_claim, name: 'Test name', value: 'Test value')
    end
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::InteractionAttribute.count).to eq 1
    expect(DataModel::InteractionAttribute.first.sources.count).to eq 2
  end


end
