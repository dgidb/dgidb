class DataSources

  class << self

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^uniq_source_names_with_(.+)$/
        uniq_source_names_with_table($1)
      elsif meth.to_s =~ /^data_source_summary_by_(.+)$/
        data_source_summary_by($1,args[0])
      else
        super
      end
    end

    def respond_to?(meth)
      if meth.to_s =~ /^uniq_source_names_with_(.+)$/ || meth.to_s =~ /^data_source_for_summary_by_(.+)$/
        true
      else
        super
      end
    end

    def uniq_source_names
      DataModel::Source.uniq.pluck(:source_db_name)
    end

    def all_source_summaries
      DataModel::Source.all.map{ |s| DataSourceSummary.new(s) }
    end

    private
    def uniq_source_names_with_table(relation_name)
      DataModel::Source.joins(relation_name.to_sym).uniq.pluck(:source_db_name)
    end

    #injection opportunity, make sure this method never takes user input
    def data_source_summary_by(col,val)
      source = DataModel::Source.where("#{col} ILIKE ?", val).first
      DataSourceSummary.new(source)
    end

  end

end
