module InteractionResultSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'MyCancerGenome'
      1
    when 'TALC'
      2
    when 'TEND'
      3
    when 'PharmGKB'
      4
    when 'TTD'
      5
    when 'DrugBank'
      6
    else
      99
    end
  end
end
