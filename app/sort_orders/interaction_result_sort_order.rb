module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'CancerCommons'
      2
    when 'ClearityFoundationBiomarkers'
      3
    when 'ClearityFoundationClinicalTrial'
      4
    when 'TALC'
      5
    when 'TEND'
      6
    when 'PharmGKB'
      7
    when 'TTD'
      8
    when 'DrugBank'
      9
    else
      99
    end
  end
end
