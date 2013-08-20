module GeneClaimSortOrder
  def self.sort_value(sortval)
    case sortval
    when 'Entrez'
      return 1
    when 'Ensembl'
      return 2
    else
      return 99
    end
  end
end
