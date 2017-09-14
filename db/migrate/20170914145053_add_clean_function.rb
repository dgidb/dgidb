class AddCleanFunction < ActiveRecord::Migration[5.1]
  def change
    reversible do |clean|
      clean.up do
        connection.execute(%q{
          create or replace function clean(text) returns text as $cleaned$
            declare cleaned text;
            BEGIN
              select upper(regexp_replace($1, '[^[:alnum:]]+', '', 'g')) into cleaned;
              return cleaned;
            END
            $cleaned$ language plpgsql immutable;
                           })
      end
      clean.down do
        connection.execute(%q{
          drop function clean(text);
                           })
      end
    end
    add_index :drug_aliases, 'clean(alias)', name: 'drug_aliases_index_on_clean_alias'
    add_index :drug_claim_aliases, 'clean(alias)', name: 'drug_claim_aliases_index_on_clean_alias'
    add_index :chembl_molecules, 'clean(pref_name)', name: 'chembl_molecules_index_on_clean_pref_name'
    add_index :chembl_molecule_synonyms, 'clean(synonym)', name: 'chembl_molecule_synonyms_index_on_clean_synonym'
  end
end
