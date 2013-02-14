module DrugClaimSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'pubchem'
      return -1
    else
      return 0
    end
  end
end
