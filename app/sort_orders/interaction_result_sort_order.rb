module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'TALC'
      2
    when 'TEND'
      3
    when 'CancerCommons'
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
