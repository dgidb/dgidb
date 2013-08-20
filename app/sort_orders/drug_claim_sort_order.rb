module DrugClaimSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'PubChem'
      return -1
    else
      return 0
    end
  end
end
