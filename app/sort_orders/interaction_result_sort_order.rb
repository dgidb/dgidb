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
    when 'TdgClinicalTrial'
      7
    when 'TEND'
      8
    when 'GuideToPharmacologyInteractions'
      9
    when 'PharmGKB'
      10
    when 'TTD'
      11
    when 'DrugBank'
      12
    else
      99
    end
  end
end
