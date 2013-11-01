require 'spec_helper'

describe Utils::Logging do
  describe '.without_sql' do
    it 'should save a reference to the old logger and restore it after the block' do
      old_logger = ActiveRecord::Base.logger
      Utils::Logging.without_sql do
        ActiveRecord::Base.logger.should be_nil
      end
      ActiveRecord::Base.logger.should eq(old_logger)
    end
  end
end
