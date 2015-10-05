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
      when 'ChEMBL'
        8
      when 'GuideToPharmacologyInteractions'
        9
      when 'MyCancerGenomeClinicalTrial'
        10
      when 'ClearityFoundationClinicalTrial'
        11
      when 'TdgClinicalTrial'
        12
      when 'PharmGKB'
        13
      when 'TTD'
        14
      when 'DrugBank'
        15
    else
      99
    end
  end
end
