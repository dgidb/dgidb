Fabricator(:drug, class_name: 'DataModel::Drug') do
  name { sequence(:pref_name) { |i| "Drug Name ##{i}" } }
  chembl_id { sequence(:chembl_id) { |i| "CHEMBL#{i}" } }
  chembl_molecule { |attrs| Fabricate(:chembl_molecule, pref_name: attrs[:name], chembl_id: attrs[:chembl_id])}
end

Fabricator(:drug_claim, class_name: 'DataModel::DrugClaim') do
  name { sequence(:name) { |i| "Drug Claim ##{i}" } }
  source
  nomenclature { |attrs| "#{attrs[:source].source_db_name} drug claim name" }
  primary_name { sequence(:primary_name) { |i| "Drug claim primary name ##{i}" } }
end

Fabricator(:drug_claim_alias, class_name: 'DataModel::DrugClaimAlias') do |f|
  f.alias { sequence(:alias) { |i| "Drug Claim Alias ##{i}" } }
  f.nomenclature { sequence(:nomenclature) { |i| "Drug Claim Alias nomenclature ##{i}" } }
end

Fabricator(:drug_claim_attribute, class_name: 'DataModel::DrugClaimAttribute') do
  name { sequence(:name) { |i| "Drug Claim Attribute Name ##{i}" } }
  value { sequence(:value) { |i| "Drug Claim Attribute Value ##{i}" } }
end

Fabricator(:drug_claim_type, class_name: 'DataModel::DrugClaimType') do
  type { ['antineoplastic', ''].sample }
end

Fabricator(:drug_alias, class_name: 'DataModel::DrugAlias') do |f|
  f.alias { sequence(:alias) { |i| "Drug Alias Name ##{i}" } }
  drug
end

Fabricator( :chembl_molecule, class_name: 'DataModel::ChemblMolecule') do
  pref_name { sequence(:pref_name) { |i| "Drug Name ##{i}" } }
  chembl_id { sequence(:chembl_id) { |i| "CHEMBL#{i}" } }
  max_phase { [0..4].sample }
  withdrawn_flag { [true, false].sample }
  molregno { sequence(:molregno) { |i| "#{i}"}}
end

Fabricator( :chembl_molecule_synonym, class_name: 'DataModel::ChemblMoleculeSynonym') do
  chembl_molecule
  molregno { |attrs| attrs[:chembl_molecule].molregno }
  synonym { sequence(:synonym) { |i| "Molecule Synonym Name ##{i}" } }
end

Fabricator( :drug_attribute, class_name: 'DataModel::DrugAttribute') do
  drug
  name { sequence(:name) {|i| "Drug attribute name ##{i}"}}
  value { sequence(:value) { |i| "Drug attribute value ##{i}"}}
end

