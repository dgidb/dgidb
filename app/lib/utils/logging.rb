module Utils
  module Logging
    def self.without_sql
      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil
      yield
      ensure
        ActiveRecord::Base.logger = old_logger
    end
  end
end