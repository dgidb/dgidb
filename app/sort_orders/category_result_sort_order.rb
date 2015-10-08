module CategoryResultSortOrder
  def self.sort_value(sortval)
    case sortval
      when 'MskImpact'
        1
      when 'CarisMolecularIntelligence'
        2
      when 'dGene'
        3
      when 'FoundationOneGenes'
        4
      when 'RussLampel'
        5
      when 'HopkinsGroom'
        6
      when 'GuideToPharmacologyGenes'
        7
      when 'BaderLabGenes'
        8
      when 'GO'
        9
      else
        99
    end
  end
end
