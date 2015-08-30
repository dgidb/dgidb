module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
      when 'CIViC'
        1
      when 'DoCM'
        2
      when 'MyCancerGenome'
        3
      when 'CancerCommons'
        4
      when 'ClearityFoundationBiomarkers'
        5
      when 'TALC'
        6
      when 'TEND'
        7
      when 'GuideToPharmacologyInteractions'
        8
      when 'MyCancerGenomeClinicalTrial'
        9
      when 'ClearityFoundationClinicalTrial'
        10
      when 'TdgClinicalTrial'
        11
      when 'PharmGKB'
        12
      when 'TTD'
        13
      when 'DrugBank'
        14
    else
      99
    end
  end
end
