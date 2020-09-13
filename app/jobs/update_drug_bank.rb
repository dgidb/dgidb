require 'zip'

class UpdateDrugBank < TsvUpdater
  def tempfile_name
    ['drugbank', '.tsv']
  end

  def create_importer
    Genome::Importers::DrugBank::NewDrugBank.new(tempfile)
  end

  def download_file
    system("python", "lib/genome/updaters/get_drugbank.py", temp_path, tempfile.path)
  end

  def should_group_genes?
    true
  end

  def should_group_drugs?
    true
  end
end
