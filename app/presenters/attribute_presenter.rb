class AttributePresenter < SimpleDelegator
  attr_accessor :attribute
  def initialize(attribute)
    @attribute = attribute
    super
  end

  def data
    {
      name: self.name,
      value: self.value,
      sources: self.sources.map(&:source_db_name),
    }
  end
end
