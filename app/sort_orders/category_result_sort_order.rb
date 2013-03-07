module CategoryResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'dGene'
      1
    when 'RussLampel'
      2
    when 'HopkinsGroom'
      3
    when 'GO'
      4
    else
      99
    end
  end
end
