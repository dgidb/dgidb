module Hangoffs
  module WithHangoff
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def with_hangoff_table(relation_name, opts={})

        hangoff_table = reflections[relation_name].table_name
        foreign_key = reflections[relation_name].foreign_key
        name_column = opts[:name_column] || :attribute_name
        value_column = opts[:value_column] || :attribute_value

        (class << self; self; end).send(:define_method, relation_name) do |params|
        table_alias = hangoff_table + SecureRandom.hex(4)
        join_string = "INNER JOIN #{hangoff_table} AS #{table_alias} ON #{table_alias}.#{foreign_key} = #{table_name}.#{primary_key}"
        scoped.joins(join_string).where(params.inject({}) do |hash, vals|
          hash["#{table_alias}.#{name_column}"] = vals[0]
          hash["#{table_alias}.#{value_column}"] = vals[1]
          hash
        end)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Hangoffs::WithHangoff