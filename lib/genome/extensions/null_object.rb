module Genome
  module Extensions

    class NullObject
      def method_missing(name, *args)
        self
      end

      def to_str
        0
      end

      def nil?
        true
      end
    end

    def Maybe(obj)
      obj.nil? ? NullObject.new : obj
    end

  end
end