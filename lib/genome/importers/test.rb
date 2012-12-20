Dir[File.dirname(__FILE__) + "/*.rb"].each do|file|
  require file
end

require 'pry'
require 'pry-nav'
require 'pry-remote'



#x = Genome::Importers::DrugBankRow.new("1	DB00001	Lepirudin	Hirudin variant-1	120993-53-5	Refludan	biotech	approved	Anticoagulants, Antithrombotic Agents, Fibrinolytic Agents	54	yes	inhibitorF2	P00734")
#binding.pry

