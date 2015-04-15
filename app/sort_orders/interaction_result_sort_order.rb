module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'MyCancerGenomeClinicalTrial'
      2
    when 'CancerCommons'
      3
    when 'ClearityFoundationBiomarkers'
      4
    when 'ClearityFoundationClinicalTrial'
      5
    when 'TALC'
      6
    when 'TEND'
      7
    when 'GuideToPharmacologyInteractions'
      8
    when 'PharmGKB'
      9
    when 'TTD'
      10
    when 'DrugBank'
      11
    else
      99
    end
  end
end
