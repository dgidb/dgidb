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

ActiveRecord::Schema.define(:version => 0) do

  create_table "citation", :id => false, :force => true do |t|
    t.text "id",                :limit => nil, :null => false
    t.text "source_db_name",    :limit => nil, :null => false
    t.text "source_db_version", :limit => nil, :null => false
    t.text "citation"
    t.text "base_url",          :limit => nil
    t.text "site_url",          :limit => nil
    t.text "full_name",         :limit => nil
  end

  create_table "drug_gene_interaction_report", :id => false, :force => true do |t|
    t.text "id",                  :limit => nil, :null => false
    t.text "drug_name_report_id", :limit => nil, :null => false
    t.text "gene_name_report_id", :limit => nil, :null => false
    t.text "interaction_type",    :limit => nil
    t.text "description"
    t.text "citation_id",         :limit => nil
  end

  add_index "drug_gene_interaction_report", ["drug_name_report_id", "gene_name_report_id", "interaction_type"], :name => "drug_gene_interaction_report_drug_name_report_id_key", :unique => true
  add_index "drug_gene_interaction_report", ["gene_name_report_id"], :name => "gene_name_report_id_idx"

  create_table "drug_gene_interaction_report_attribute", :id => false, :force => true do |t|
    t.text "id",             :limit => nil, :null => false
    t.text "interaction_id", :limit => nil, :null => false
    t.text "name",           :limit => nil, :null => false
    t.text "value",          :limit => nil, :null => false
  end

  create_table "drug_name_group", :id => false, :force => true do |t|
    t.text "id",   :limit => nil, :null => false
    t.text "name"
  end

  create_table "drug_name_group_bridge", :id => false, :force => true do |t|
    t.text "drug_name_group_id",  :limit => nil, :null => false
    t.text "drug_name_report_id", :limit => nil, :null => false
  end

  create_table "drug_name_report", :id => false, :force => true do |t|
    t.text "id",           :limit => nil, :null => false
    t.text "name",         :limit => nil, :null => false
    t.text "description"
    t.text "nomenclature", :limit => nil, :null => false
    t.text "citation_id",  :limit => nil
  end

  add_index "drug_name_report", ["name"], :name => "drug_name_report_name_index"

  create_table "drug_name_report_association", :id => false, :force => true do |t|
    t.text "id",                  :limit => nil, :null => false
    t.text "drug_name_report_id", :limit => nil, :null => false
    t.text "alternate_name",      :limit => nil, :null => false
    t.text "description"
    t.text "nomenclature",        :limit => nil, :null => false
  end

  add_index "drug_name_report_association", ["drug_name_report_id"], :name => "drug_name_report_id_index"

  create_table "drug_name_report_category_association", :id => false, :force => true do |t|
    t.text "id",                  :limit => nil, :null => false
    t.text "drug_name_report_id", :limit => nil, :null => false
    t.text "category_name",       :limit => nil, :null => false
    t.text "category_value",      :limit => nil, :null => false
    t.text "description"
  end

  create_table "gene_name_group", :id => false, :force => true do |t|
    t.text "id",   :limit => nil, :null => false
    t.text "name"
  end

  add_index "gene_name_group", ["name"], :name => "name_idx"

  create_table "gene_name_group_bridge", :id => false, :force => true do |t|
    t.text "gene_name_group_id",  :limit => nil, :null => false
    t.text "gene_name_report_id", :limit => nil, :null => false
  end

  add_index "gene_name_group_bridge", ["gene_name_report_id"], :name => "gene_name_report_id_ix"

  create_table "gene_name_report", :id => false, :force => true do |t|
    t.text "id",           :limit => nil, :null => false
    t.text "name",         :limit => nil, :null => false
    t.text "description"
    t.text "nomenclature", :limit => nil, :null => false
    t.text "citation_id",  :limit => nil
  end

  add_index "gene_name_report", ["name"], :name => "gene_name_report_name_index"

  create_table "gene_name_report_association", :id => false, :force => true do |t|
    t.text "id",                  :limit => nil, :null => false
    t.text "gene_name_report_id", :limit => nil, :null => false
    t.text "alternate_name",      :limit => nil, :null => false
    t.text "description"
    t.text "nomenclature",        :limit => nil, :null => false
  end

  add_index "gene_name_report_association", ["alternate_name"], :name => "alternate_name_index"

  create_table "gene_name_report_category_association", :id => false, :force => true do |t|
    t.text "id",                  :limit => nil, :null => false
    t.text "gene_name_report_id", :limit => nil, :null => false
    t.text "category_name",       :limit => nil, :null => false
    t.text "category_value",      :limit => nil, :null => false
    t.text "description"
  end

  add_index "gene_name_report_category_association", ["category_name", "category_value"], :name => "category_name_and_value_idx"
  add_index "gene_name_report_category_association", ["category_name"], :name => "category_name"
  add_index "gene_name_report_category_association", ["category_value"], :name => "category_value_idx"

  if connection.adapter_name == 'PostgreSQL'
    execute <<-eos
          create index on gene_name_group using gin(to_tsvector('english', name));
          create index on drug_name_group using gin(to_tsvector('english', name));
          create index on gene_name_report_association using gin(to_tsvector('english', alternate_name));
          create index on drug_name_report_association using gin(to_tsvector('english', alternate_name));
          create index on gene_name_report using gin(to_tsvector('english', name));
          create index on drug_name_report using gin(to_tsvector('english', name));
    eos
  end

end
