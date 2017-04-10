# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20170410204422) do

  create_table "drug_aliases", :id => false, :force => true do |t|
    t.text "id",           :null => false
    t.text "drug_id",      :null => false
    t.text "alias",        :null => false
    t.text "nomenclature", :null => false
  end

  create_table "drug_aliases_sources", :id => false, :force => true do |t|
    t.text "drug_alias_id", :null => false
    t.text "source_id",     :null => false
  end

  create_table "drug_attributes", :id => false, :force => true do |t|
    t.text "id",      :null => false
    t.text "drug_id", :null => false
    t.text "name",    :null => false
    t.text "value",   :null => false
  end

  create_table "drug_attributes_sources", :id => false, :force => true do |t|
    t.text "drug_attribute_id", :null => false
    t.text "source_id",         :null => false
  end

  create_table "drug_claim_aliases", :id => false, :force => true do |t|
    t.text "id",            :null => false
    t.text "drug_claim_id", :null => false
    t.text "alias",         :null => false
    t.text "nomenclature",  :null => false
  end

  add_index "drug_claim_aliases", ["drug_claim_id"], :name => "drug_claim_aliases_drug_claim_id_idx"

  create_table "drug_claim_attributes", :id => false, :force => true do |t|
    t.text "id",            :null => false
    t.text "drug_claim_id", :null => false
    t.text "name",          :null => false
    t.text "value",         :null => false
  end

  add_index "drug_claim_attributes", ["drug_claim_id"], :name => "drug_claim_attributes_drug_claim_id_idx"
  add_index "drug_claim_attributes", ["name"], :name => "index_drug_claim_attributes_on_name"
  add_index "drug_claim_attributes", ["value"], :name => "index_drug_claim_attributes_on_value"

  create_table "drug_claim_types", :id => false, :force => true do |t|
    t.string "id",   :null => false
    t.string "type", :null => false
  end

  create_table "drug_claim_types_drug_claims", :id => false, :force => true do |t|
    t.string "drug_claim_id",      :null => false
    t.string "drug_claim_type_id", :null => false
  end

  create_table "drug_claims", :id => false, :force => true do |t|
    t.text   "id",           :null => false
    t.text   "name",         :null => false
    t.text   "nomenclature", :null => false
    t.text   "source_id"
    t.string "primary_name"
    t.text   "drug_id"
  end

  add_index "drug_claims", ["source_id"], :name => "drug_claims_source_id_idx"

  create_table "drugs", :id => false, :force => true do |t|
    t.text "id",   :null => false
    t.text "name"
  end

  create_table "gene_aliases", :id => false, :force => true do |t|
    t.text "id",           :null => false
    t.text "gene_id",      :null => false
    t.text "alias",        :null => false
    t.text "nomenclature", :null => false
  end

  create_table "gene_aliases_sources", :id => false, :force => true do |t|
    t.text "gene_alias_id", :null => false
    t.text "source_id",     :null => false
  end

  create_table "gene_attributes", :id => false, :force => true do |t|
    t.text "id",      :null => false
    t.text "gene_id", :null => false
    t.text "name",    :null => false
    t.text "value",   :null => false
  end

  create_table "gene_attributes_sources", :id => false, :force => true do |t|
    t.text "gene_attribute_id", :null => false
    t.text "source_id",         :null => false
  end

  create_table "gene_categories_genes", :id => false, :force => true do |t|
    t.text "gene_claim_category_id", :null => false
    t.text "gene_id",                :null => false
  end

  create_table "gene_claim_aliases", :id => false, :force => true do |t|
    t.text "id",            :null => false
    t.text "gene_claim_id", :null => false
    t.text "alias",         :null => false
    t.text "nomenclature",  :null => false
  end

  add_index "gene_claim_aliases", ["alias"], :name => "index_gene_claim_aliases_on_alias"
  add_index "gene_claim_aliases", ["gene_claim_id"], :name => "gene_claim_aliases_gene_claim_id_idx"

  create_table "gene_claim_attributes", :id => false, :force => true do |t|
    t.text "id",            :null => false
    t.text "gene_claim_id", :null => false
    t.text "name",          :null => false
    t.text "value",         :null => false
  end

  add_index "gene_claim_attributes", ["gene_claim_id"], :name => "gene_claim_attributes_gene_claim_id_idx"
  add_index "gene_claim_attributes", ["name"], :name => "index_gene_claim_attributes_on_name"
  add_index "gene_claim_attributes", ["value"], :name => "index_gene_claim_attributes_on_value"

  create_table "gene_claim_categories", :id => false, :force => true do |t|
    t.string "id",   :null => false
    t.string "name", :null => false
  end

  create_table "gene_claim_categories_gene_claims", :id => false, :force => true do |t|
    t.string "gene_claim_id",          :null => false
    t.string "gene_claim_category_id", :null => false
  end

  create_table "gene_claims", :id => false, :force => true do |t|
    t.text "id",           :null => false
    t.text "name",         :null => false
    t.text "nomenclature", :null => false
    t.text "source_id"
    t.text "gene_id"
  end

  add_index "gene_claims", ["name"], :name => "index_gene_claims_on_name"
  add_index "gene_claims", ["source_id"], :name => "gene_claims_source_id_idx"

  create_table "gene_gene_interaction_claim_attributes", :id => false, :force => true do |t|
    t.string "id",                             :null => false
    t.string "gene_gene_interaction_claim_id", :null => false
    t.string "name",                           :null => false
    t.string "value",                          :null => false
  end

  create_table "gene_gene_interaction_claims", :id => false, :force => true do |t|
    t.string "id",                  :null => false
    t.string "gene_id",             :null => false
    t.string "interacting_gene_id", :null => false
    t.string "source_id",           :null => false
  end

  add_index "gene_gene_interaction_claims", ["gene_id", "interacting_gene_id"], :name => "left_and_interacting_gene_interaction_index"
  add_index "gene_gene_interaction_claims", ["gene_id"], :name => "index_gene_gene_interaction_claims_on_gene_id"
  add_index "gene_gene_interaction_claims", ["interacting_gene_id"], :name => "index_gene_gene_interaction_claims_on_interacting_gene_id"

  create_table "genes", :id => false, :force => true do |t|
    t.text   "id",        :null => false
    t.text   "name"
    t.string "long_name"
  end

  add_index "genes", ["name"], :name => "index_genes_on_name"

  create_table "interaction_attributes", :id => false, :force => true do |t|
    t.text "id",             :null => false
    t.text "interaction_id", :null => false
    t.text "name",           :null => false
    t.text "value",          :null => false
  end

  create_table "interaction_attributes_sources", :id => false, :force => true do |t|
    t.text "interaction_attribute_id", :null => false
    t.text "source_id",                :null => false
  end

  create_table "interaction_claim_attributes", :id => false, :force => true do |t|
    t.text "id",                   :null => false
    t.text "interaction_claim_id", :null => false
    t.text "name",                 :null => false
    t.text "value",                :null => false
  end

  add_index "interaction_claim_attributes", ["interaction_claim_id"], :name => "interaction_claim_attributes_interaction_claim_id_idx"

  create_table "interaction_claim_types", :id => false, :force => true do |t|
    t.string "id",   :null => false
    t.string "type"
  end

  create_table "interaction_claim_types_interaction_claims", :id => false, :force => true do |t|
    t.string "interaction_claim_type_id", :null => false
    t.string "interaction_claim_id",      :null => false
  end

  create_table "interaction_claims", :id => false, :force => true do |t|
    t.text   "id",                :null => false
    t.text   "drug_claim_id",     :null => false
    t.text   "gene_claim_id",     :null => false
    t.text   "source_id"
    t.string "known_action_type"
    t.text   "interaction_id"
  end

  add_index "interaction_claims", ["drug_claim_id"], :name => "interaction_claims_drug_claim_id_idx"
  add_index "interaction_claims", ["gene_claim_id"], :name => "interaction_claims_gene_claim_id_idx"
  add_index "interaction_claims", ["known_action_type"], :name => "index_interaction_claims_on_known_action_type"
  add_index "interaction_claims", ["source_id"], :name => "interaction_claims_source_id_idx"

  create_table "interaction_types_interactions", :id => false, :force => true do |t|
    t.text "interaction_claim_type_id", :null => false
    t.text "interaction_id",            :null => false
  end

  create_table "interactions", :id => false, :force => true do |t|
    t.text "id",      :null => false
    t.text "drug_id", :null => false
    t.text "gene_id", :null => false
  end

  create_table "publications", :force => true do |t|
    t.string   "pmid"
    t.string   "citation"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "source_trust_levels", :id => false, :force => true do |t|
    t.string "id",    :null => false
    t.string "level", :null => false
  end

  create_table "source_types", :id => false, :force => true do |t|
    t.string "id",           :null => false
    t.string "type",         :null => false
    t.string "display_name"
  end

  create_table "sources", :id => false, :force => true do |t|
    t.text    "id",                                                :null => false
    t.text    "source_db_name",                                    :null => false
    t.text    "source_db_version",                                 :null => false
    t.text    "citation"
    t.text    "base_url"
    t.text    "site_url"
    t.text    "full_name"
    t.string  "source_type_id"
    t.integer "gene_claims_count",                  :default => 0
    t.integer "drug_claims_count",                  :default => 0
    t.integer "interaction_claims_count",           :default => 0
    t.integer "interaction_claims_in_groups_count", :default => 0
    t.integer "gene_claims_in_groups_count",        :default => 0
    t.integer "drug_claims_in_groups_count",        :default => 0
    t.string  "source_trust_level_id"
    t.integer "gene_gene_interaction_claims_count", :default => 0
  end

  add_index "sources", ["source_trust_level_id"], :name => "sources_source_trust_level_id_idx"
  add_index "sources", ["source_type_id"], :name => "sources_source_type_id_idx"

end
