class Tour
  Step = Struct.new( :id, :content )

  def initialize( steps )
    @steps = steps
  end

  def each_step
    @steps.each { |k, v| yield Step.new( k == 'welcome' ? nil : "##{k}", v.html_safe ) }
  end
end
