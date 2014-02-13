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
    when 'BaderLabGenes'
      5
    when 'GO'
      6
    else
      99
    end
  end
end
