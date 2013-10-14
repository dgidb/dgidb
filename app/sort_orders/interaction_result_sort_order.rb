module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'CancerCommons'
      2
    when 'ClearityFoundationBiomarker'
      3
    when 'ClearityFoundationClinical'
      4
    when 'TALC'
      5
    when 'TEND'
      6
    when 'PharmGKB'
      7
    when 'FoundationOneGenes'
      8
    when 'TTD'
      9
    when 'DrugBank'
      10
    else
      99
    end
  end
end
