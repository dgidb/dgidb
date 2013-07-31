module Utils
  module Logging
    def self.toggle_sql
      if @old_logger
        puts 'Enabling ActiveRecord logging...'
        ActiveRecord::Base.logger = @old_logger
        @old_logger = nil
      else
        puts 'Disabling ActiveRecord logging...'
        @old_logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = nil
      end
    end
  end
end