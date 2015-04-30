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
    when 'GuideToPharmacologyGenes'
      5
    when 'BaderLabGenes'
      6
    when 'GO'
      7
    else
      99
    end
  end
end
