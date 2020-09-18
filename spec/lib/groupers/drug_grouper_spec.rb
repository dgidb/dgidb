require 'spec_helper'

describe Genome::Groupers::DrugGrouper do

  skip "This needs to be reworked for new drug grouper" do
    def group
      grouper = Genome::Groupers::DrugGrouper.new
      grouper.run
      grouper
    end

    it 'should add the drug claim if the drug claim name matches the drug name (case insensitive)' do
      drug = Fabricate(:drug, name: 'Test Drug')
      drug_claims = Set.new
      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claims << Fabricate(:drug_claim, name: 'Test Drug', source: source, primary_name: 'Test Drug')
      drug_claims << Fabricate(:drug_claim, name: 'TEST DRUG', source: source, primary_name: 'TEST DRUG')
      drug_claims << Fabricate(:drug_claim, name: 'Test!-drug', source: source, primary_name: 'Test!-drug')

      group
      drug_claims.each { |dc| dc.reload; expect(dc.drug).not_to be_nil }
      expect(drug.drug_claims.count).to eq 3
      expect(drug.drug_aliases.count).to eq 1
      expect(drug.drug_attributes.count).to eq 0
    end

    it 'should add the drug claim if a drug claim alias matches the drug name (case insensitive)' do
      name = 'Test Drug'
      drug = Fabricate(:drug, name: name)
      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claim = Fabricate(:drug_claim, name: 'Nonmatching Drug Name', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, alias: name, drug_claim: drug_claim)
      Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')
      another_drug_claim = Fabricate(:drug_claim, name: 'Another Nonmatching Drug Name', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, alias: 'test-drug!', drug_claim: another_drug_claim)
      Fabricate(:drug_claim_attribute, drug_claim: another_drug_claim, name: 'adverse reaction', value: 'true')

      group
      drug_claim.reload
      expect(drug_claim.drug).not_to be_nil
      expect(drug.drug_claims.count).to eq 2
      expect(drug.drug_aliases.count).to eq 3
      expect(drug.drug_attributes.count).to eq 1
    end

    it 'should add the drug claim if its name matches another grouped drug claim' do
      drug_name = 'Test Drug'
      drug = Fabricate(:drug, name: drug_name)

      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claim = Fabricate(:drug_claim, name: 'Test Drug Trade Name', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'Test Drug')
      Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

      another_source = Fabricate(:source, source_db_name: 'Test Clinical Source')
      another_drug_claim = Fabricate(:drug_claim, name: 'Test Drug Trade Name', source: another_source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: another_drug_claim, alias: 'Bogus Drug Name')
      Fabricate(:drug_claim_attribute, drug_claim: another_drug_claim, name: 'kerbanol groups', value: 3)

      group
      drug.reload
      expect(drug.drug_claims.count).to eq 2
      expect(drug.drug_aliases.count).to eq 2
      expect(drug.drug_attributes.count).to eq 2
    end

    it 'should add the drug claim if its alias matches another grouped drug claim alias' do
      drug_name = 'Test Drug'
      drug = Fabricate(:drug, name: drug_name)
      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claim = Fabricate(:drug_claim, name: 'Test Drug', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: 'Test Drug Trade Name')
      Fabricate(:drug_claim_attribute, drug_claim: drug_claim, name: 'adverse reaction', value: 'true')

      another_source = Fabricate(:source, source_db_name: 'Test Clinical Source')
      another_drug_claim = Fabricate(:drug_claim, name: 'Bogus Drug Name', source: another_source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: another_drug_claim, alias: 'Test Drug Trade Name')
      Fabricate(:drug_claim_attribute, drug_claim: another_drug_claim, name: 'kerbanol groups', value: 3)

      group
      drug.reload
      expect(drug.drug_claims.count).to eq 2
      expect(drug.drug_aliases.count).to eq 2
      expect(drug.drug_attributes.count).to eq 2
    end

    it 'should not add the drug claim if its alias matches multiple drug aliases' do
      drug = Fabricate(:drug, name: 'Test Drug')
      drug_alias = Fabricate(:drug_alias, drug: drug)

      another_drug = Fabricate(:drug, name: 'Another Test Drug')
      another_drug_alias = Fabricate(:drug_alias, drug: another_drug)

      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claim = Fabricate(:drug_claim, name: 'Drug Trade Name', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_drug_alias.alias)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: drug_alias.alias)

      grouper = group
      drug_claim.reload
      expect(drug_claim.drug).to be_nil
      expect(grouper.indirect_multimatch.count).to eq 1
    end

    it 'should not add the drug claim if it matches multiple drug names' do
      drug = Fabricate(:drug)

      another_drug = Fabricate(:drug)

      source = Fabricate(:source, source_db_name: 'Test Source')
      drug_claim = Fabricate(:drug_claim, name: 'Drug Trade Name', source: source, primary_name: nil)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: drug.name)
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, alias: another_drug.name)

      grouper = group
      drug_claim.reload
      expect(drug_claim.drug).to be_nil
      expect(grouper.direct_multimatch.count).to eq 1
      expect(grouper.indirect_multimatch.count).to eq 0
    end

    it 'should not add more than one copy of an alias from a single drug claim' do
      drug = Fabricate(:drug)
      drug_claim = Fabricate(:drug_claim, primary_name: drug.name, name: drug.concept_id)
      Fabricate(:drug_claim_alias, alias: 'My not-so-unique alias', drug_claim: drug_claim)
      Fabricate(:drug_claim_alias, alias: 'My Not-So-Unique Alias', drug_claim: drug_claim)

      group

      drug.reload
      expect(drug.drug_aliases.count).to eq 1
      expect(drug.drug_claims.first.drug_claim_aliases.count).to eq 2

    end

    it 'should properly update drug flags after grouping' do
      approved_molecule = Fabricate(:chembl_molecule, max_phase: 4, withdrawn_flag: false)
      withdrawn_molecule = Fabricate(:chembl_molecule, max_phase: 4, withdrawn_flag: true)
      unapproved_molecule = Fabricate(:chembl_molecule, max_phase: 2, withdrawn_flag: false)

      approved_drug = Fabricate(:drug, chembl_molecule: approved_molecule)
      withdrawn_drug = Fabricate(:drug, chembl_molecule: withdrawn_molecule)
      unapproved_drug = Fabricate(:drug, chembl_molecule: unapproved_molecule)

      expect(approved_drug.fda_approved).to be_truthy
      expect(withdrawn_drug.fda_approved).to be_falsey
      expect(unapproved_drug.fda_approved).to be_falsey

      immunotherapy_drug = Fabricate(:drug)
      non_immunotherapy_drug = Fabricate(:drug)

      anti_neoplastic_drugs =
        %w[TALC ClearityFoundationClinicalTrial ClearityFoundationBiomarkers CancerCommons
                                        MyCancerGenome CIViC MyCancerGenomeClinicalTrial].map do |source_db_name|
          source = Fabricate(:source, source_db_name: source_db_name)
          drug_claim = Fabricate(:drug_claim, source: source)
          drug = Fabricate(:drug, name: drug_claim.primary_name)
      end

      source = Fabricate(:source, source_db_name: 'ChEMBL')
      chembl_drug_claim = Fabricate(:drug_claim, source: source)
      chembl_drug = Fabricate(:drug, name: chembl_drug_claim.primary_name)
      immunotherapy_drug_claim = Fabricate(:drug_claim, name: immunotherapy_drug.name)
      Fabricate(:drug_claim_attribute, value: 'immunomodulatory agent',
                drug_claim: immunotherapy_drug_claim)

      group

      Genome::Normalizers::DrugTypeNormalizer.normalize_types

      anti_neoplastic_drugs.each do |drug|
        drug.reload
        expect(drug.drug_claims.count).to eq 1
        drug.send(:update_anti_neoplastic_add, drug.drug_claims.first) # Why does this need to be done for rspec?
        expect(drug.anti_neoplastic).to be_truthy,
          "drug with drug_claim source of #{drug.drug_claims.first.source.source_db_name} has anti_neoplastic flag of #{drug.anti_neoplastic}."
      end
      chembl_drug.send(:update_anti_neoplastic_add, chembl_drug.drug_claims.first)
      expect(chembl_drug.anti_neoplastic).to be_falsey

      immunotherapy_drug.reload
      non_immunotherapy_drug.reload
      expect(immunotherapy_drug.immunotherapy).to be_truthy
      expect(non_immunotherapy_drug.immunotherapy).to be_falsey

    end

    it 'should not allow drugs to have null names' do
      bond = 'CHEMBL007'
      molecule = Fabricate(:chembl_molecule, pref_name: nil, chembl_id: bond)

      drug_claim = Fabricate(:drug_claim, name: bond)

      group

      drug_claim.reload
      drug = drug_claim.drug

      expect(drug.name).to eq bond
      expect(drug.chembl_id).to eq bond

      expect{Fabricate(:drug, molecule: molecule)}.to raise_error
    end

    it 'should blacklist and remove common aliases' do
      drug_claims = Fabricate.times(4, :drug_claim).each do |dc|
        Fabricate(:drug, name: dc.name)
        Fabricate(:drug_claim_alias, alias: 'beans', drug_claim: dc)
        Fabricate(:drug_claim_alias, drug_claim: dc)
      end
      group
      drug_claims.each do |dc|
        dc.reload
        expect(dc.drug).to_not be_nil
        expect(dc.drug_claim_aliases.count).to eq 1
      end
    end
  end
end
