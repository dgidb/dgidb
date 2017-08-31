class ClaimAttributePresenter < SimpleDelegator
  attr_accessor :attribute
  def initialize(attribute)
    @attribute = attribute
    super
  end

  def data
    {
      name: self.name,
      value: self.value,
    }
  end
end
