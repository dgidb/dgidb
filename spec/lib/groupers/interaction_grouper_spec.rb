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

  it 'group interaction claims with same drug and gene' do
    drug = Fabricate(:drug)
    gene = Fabricate(:gene)
    drug_claim = Fabricate(:drug_claim, drug: drug)
    gene_claim = Fabricate(:gene_claim, gene: gene)
    Fabricate(:interaction_claim, drug_claim: drug_claim, gene_claim: gene_claim)
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::Interaction.all.count).to eq 1
    interaction_claim_type = Fabricate(:interaction_claim_type)
    Fabricate(:interaction_claim, drug_claim: drug_claim, gene_claim: gene_claim, interaction_claim_types: [interaction_claim_type])
    Genome::Groupers::InteractionGrouper.run
    expect(DataModel::Interaction.all.count).to eq 1
  end

end
