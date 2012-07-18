require 'spec_helper'

describe 'drug_groups' do

  it 'SUNITINIB looks reasonable' do
    visit '/drug_groups/SUNITINIB'
    page.status_code.should eq(200)

    within('.PubChem') do
      page.should have_content('Drug Name: 5329102')
      page.should have_content('Source Database Name: PubChem')
      page.should have_content('Source Database Version: 11-May-2012')
      page.should have_content('SUNITINIB')
    end

    within('.DrugBank') do
      page.should have_content('Drug Name: DB07417')
      page.should have_content('Source Database Name: DrugBank')
      page.should have_content('Source Database Version: 3')
      page.should have_content('N-[2-(DIETHYLAMINO)ETHYL]-5-[(Z)-(5-FLUORO-2-OXO-1,2-DIHYDRO-3H-INDOL-3-YLIDENE)METHYL]-2,4-DIMETHYL-1H-PYRROLE-3-CARBOXAMIDE')
    end

    within('.TTD') do
      page.should have_content('Drug Name: DAP000005')
      page.should have_content('Source Database Name: TTD')
      page.should have_content('Source Database Version: 4.3.02 (2011.08.25)')
      page.should have_content('SUTENT')
    end

  end
end
