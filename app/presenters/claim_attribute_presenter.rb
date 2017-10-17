class ClaimAttributePresenter < SimpleDelegator
  attr_accessor :attribute
  def initialize(attribute)
    @attribute = attribute
    super
  end

  def as_json
    {
      name: self.name,
      value: self.value,
    }
  end
end
