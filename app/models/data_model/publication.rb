class Publication < ActiveRecord::Base
  attr_accessible :citation, :link, :pmid

  self.primary_key = "pmid"
end
