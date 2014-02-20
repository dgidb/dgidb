class TrustLevelPresenter
  def self.source_link_with_trust_flag(context, source)
    type = if source.source_trust_level_id == DataModel::SourceTrustLevel.EXPERT_CURATED
               'success'
              else
                'warning'
              end
    context.link_to(context.label(source.source_db_name, type), context.source_path(source.source_db_name))
  end
end
