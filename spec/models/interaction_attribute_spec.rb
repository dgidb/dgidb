require 'spec_helper'

describe GenomeModels::DataModel::InteractionAttribute do
  set_fixture_class :drug_gene_interaction_report_attribute => "GenomeModels::DataModel::InteractionAttribute"
  fixtures :drug_gene_interaction_report_attribute, :drug_gene_interaction_report
  it "should have an interaction" do
    drug_gene_interaction_report_attribute(:attribute_a).interaction.should be_an_instance_of(GenomeModels::DataModel::Interaction)
  end
end
