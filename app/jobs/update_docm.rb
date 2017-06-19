class UpdateDocm < ApiUpdater
  def updater
    return Genome::OnlineUpdaters::Docm::Updater.new()
  end
end
