module Utils
  module Logging
    def self.without_sql
      puts 'Disabling ActiveRecord logging...'
      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil
      yield
      puts 'Enabling ActiveRecord logging...'
      ActiveRecord::Base.logger = old_logger
    end
  end
end