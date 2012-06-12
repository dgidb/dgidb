include Genome::Extensions

class GeneGroupNamePresenter
  attr_accessor :name, :source_db_names
  def initialize(name, source_db_names, all_source_db_names)
    @name = name
    @source_db_names = source_db_names
    @all_source_db_names = all_source_db_names
  end

  def row_representation
    @row ||= @all_source_db_names.map{|name| @source_db_names[name]}
  end
end
