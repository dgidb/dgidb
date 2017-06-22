class UpdateCivic < ApiUpdater
  def updater
    return Genome::OnlineUpdaters::Civic::Updater.new()
  end
end
