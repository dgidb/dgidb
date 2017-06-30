module Genome
  module Extensions

    class NullObject
      def method_missing(name, *args)
        self
      end

      def to_str
        0
      end

      def to_s
        0
      end

      def to_a
        []
      end

      def nil?
        true
      end

      def exist?(str)
        false
      end
    end

    def Maybe(obj)
      obj.nil? ? NullObject.new : obj
    end

  end
end
