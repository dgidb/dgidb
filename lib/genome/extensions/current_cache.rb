module Genome
  module Extensions
     module CurrentCache
      def current_cache
        @cache ||= Rails.application ? Rails.cache : Genome::Extensions::NullObject.new
      end
    end
  end
end
