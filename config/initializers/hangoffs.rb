module Hangoffs
  module WithHangoff
    extend ActiveSupport::Concern
    class BooleanParse

      Results = Struct.new(:expression, :values, :aliases)

      def initialize(prefix='', name_column = :name, value_column = :value)
        @prefix = prefix.to_sym
        @values = []
        @aliases = []
        @name_column = name_column.to_sym
        @value_column = value_column.to_sym
      end

      def parse!(exp_hash)
        @expression = parse_recur(exp_hash)
        val = Results.new(@expression, @values, @aliases)
        @values = []
        val
      end

      private
      def parse_recur(exp_hash, operator='')
        exp = ''
        key,val = exp_hash.shift
        raise "Hash keys must be symbols" unless key.is_a? Symbol
        if [:and,:or].include? key.downcase
          exp += " #{key.upcase } (#{parse_recur(val)})"
        else
          table_alias = @prefix.to_s + SecureRandom.hex(4)
          @aliases << table_alias
          exp += "#{operator}(#{table_alias}.#{@name_column} = '#{key}'"
          exp += " AND #{table_alias}.#{@value_column} = ?)"
          @values << val.to_s
        end
        if val.is_a?(Hash) && val.size > 0
          exp += " #{parse_recur(val)}"
        else
          exp_hash.size > 0 ? exp += "#{parse_recur(exp_hash, " AND ")}" : exp
        end
      end
    end

    included do
    end


    module ClassMethods
      def with_hangoff_table(relation_name, opts={})

        hangoff_table = reflections[relation_name].table_name
        foreign_key = reflections[relation_name].foreign_key
        name_column = opts[:name_column] || :attribute_name
        value_column = opts[:value_column] || :attribute_value

        (class << self; self; end).send(:define_method, relation_name) do |params|
          parser = BooleanParse.new(hangoff_table)
          result = parser.parse!(params)
          conditions = scoped
          result.aliases.each do |table_alias|
            join_string = "INNER JOIN #{hangoff_table} AS #{table_alias} ON #{table_alias}.#{foreign_key} = #{table_name}.#{primary_key}"
            conditions = conditions.joins(join_string)
          end
          conditions.where(result.expression, *result.values)
        end
    end
  end
end
end

ActiveRecord::Base.send :include, Hangoffs::WithHangoff