module CategoryResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'dGene'
      1
    when 'FoundationOneGenes'
      2
    when 'RussLampel'
      3
    when 'HopkinsGroom'
      4
    when 'GO'
      5
    else
      99
    end
  end
end
