require 'spec_helper'

describe 'gene_groups' do
  
  it 'FLT3 looks reasonable' do
    visit '/gene_groups/FLT3'
    page.status_code.should eq(200)

    within('#detailed_view') do
      within('.Entrez') do
        page.should have_content('Gene Name: 2322')
        page.should have_content('Source Database Name: Entrez')
        page.should have_content('Source Database Version: 21-Sep-2011')
        page.should have_content('FLT3')
      end

      within('.Ensembl') do
        page.should have_content('Gene Name: ENSG00000122025')
        page.should have_content('Source Database Name: Ensembl')
        page.should have_content('Source Database Version: 63')
        page.should have_content('FLT3')
      end

      within('.DrugBank') do
        page.should have_content('Gene Name: 165')
        page.should have_content('Source Database Name: DrugBank')
        page.should have_content('Source Database Version: 3')
        page.should have_content('FLT3')
      end

      within('.GO') do
        page.should have_content('Gene Name: FLT3')
        page.should have_content('Source Database Name: GO')
        page.should have_content('Source Database Version: 3-May-2012')
      end
    end

    within('#by_source') do
      page.should have_table('', rows: [['FLT3', 'a', 'a', 'a', 'a', 'z'], ['P36888', 'z', 'z', 'a', 'z', 'z'], ['165', 'z', 'z', 'a', 'z', 'z'], ['CD135', 'a', 'z', 'z', 'z', 'z'], ['STK1', 'a', 'z', 'z', 'z', 'z'], ['FLK2', 'a', 'z', 'z', 'z', 'z'], ['2322', 'a', 'z', 'z', 'z', 'z'], ['ENSG00000122025', 'z', 'a', 'z', 'z', 'z'], ['CELL SURFACE', 'z', 'z', 'z', 'a', 'z'], ['TYROSINE KINASE', 'z', 'z', 'z', 'a', 'z'], ['KINASE', 'z', 'z', 'z', 'a', 'z']])
    end
  end

end
