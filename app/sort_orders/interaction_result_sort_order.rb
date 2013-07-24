module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'CancerCommons'
      2
    when 'TALC'
      3
    when 'TEND'
      4
    when 'PharmGKB'
      5
    when 'TTD'
      6
    when 'DrugBank'
      7
    else
      99
    end
  end
end
