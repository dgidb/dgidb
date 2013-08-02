module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'CancerCommons'
      2
    when 'ClearityFoundation'
      3
    when 'TALC'
      4
    when 'TEND'
      5
    when 'PharmGKB'
      6
    when 'TTD'
      7
    when 'DrugBank'
      8
    else
      99
    end
  end
end
