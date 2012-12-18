class DataSourceSummary
  def initialize(source)
    @source = source
  end

  def name
    @source.source_db_name
  end

  def full_name
    @source.full_name
  end

  def homepage
    @source.site_url
  end

  def full_citation
    @source.citation
  end

  [:gene_claims, :drug_claims].each do |relation|
    define_method "#{relation}_in_groups" do
      count ||= @source.send(relation)
        .joins("#{relation.to_s.split('_').first.pluralize}".to_sym).size
    end
  end

  [:gene_claims, :drug_claims, :interaction_claims].each do |relation|
    define_method "#{relation}_in_source" do
      count ||= @source.send(relation).size
    end
  end

  def found?
    !@source.nil?
  end

end
