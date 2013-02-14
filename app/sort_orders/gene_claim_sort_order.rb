module GeneClaimSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'Ensembl'
      return -1
    when 'Entrez'
      return -2
    else
      return 0
    end
  end
end
