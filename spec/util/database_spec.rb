require 'spec_helper'

describe Utils::Database do
  describe '.delete_source' do
    def setup_source
      source = Fabricate(:source)

      gene_claim = Fabricate(:gene_claim, source: source)
      gene_claim_alias = Fabricate(:gene_claim_alias, gene_claim: gene_claim)
      gene_claim_attribute = Fabricate(:gene_claim_attribute, gene_claim: gene_claim)

      drug_claim = Fabricate(:drug_claim, source: source)
      drug_claim_alias = Fabricate(:drug_claim_alias, drug_claim: drug_claim)
      drug_claim_attribute = Fabricate(:drug_claim_attribute, drug_claim: drug_claim)

      interaction_claim = Fabricate(:interaction_claim, source: source)
      interaction_claim_attribute = Fabricate(:interaction_claim_attribute, interaction_claim: interaction_claim)

      [source, gene_claim_alias, gene_claim_attribute, drug_claim_alias, drug_claim_attribute, interaction_claim, interaction_claim_attribute]
    end

    def assert_source_deleted(source)
      expect(DataModel::Source.where(source_db_name: source.source_db_name).count).to eq(0)
      [DataModel::GeneClaim, DataModel::DrugClaim, DataModel::InteractionClaim].each do |klass|
        expect(klass.joins(:source).where('sources.source_db_name = ?', source.source_db_name).count).to eq(0)
      end
    end

    it 'should delete all elements associated with a source' do
      (source, _) = *setup_source
      Utils::Database.delete_source(source.source_db_name)
      assert_source_deleted(source)
    end

    it 'should not delete elements related to other sources' do
      (source_to_delete, _) = *setup_source
      (source_to_keep, _) = *setup_source

      Utils::Database.delete_source(source_to_delete.source_db_name)
      assert_source_deleted(source_to_delete)

      expect(DataModel::Source.where(source_db_name: source_to_keep.source_db_name).count).to eq(1)
    end
  end
end