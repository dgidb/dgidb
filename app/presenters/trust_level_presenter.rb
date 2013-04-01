class TrustLevelPresenter
  def self.source_link_with_trust_flag(context, source)
    type = if source.source_trust_level_id == DataModel::SourceTrustLevel.EXPERT_CURATED
               'success'
              else
                'warning'
              end
      context.instance_exec do
        link_to(label(source.source_db_name, type), source_path(source.source_db_name))
      end
  end
end
