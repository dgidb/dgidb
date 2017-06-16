class ApiUpdater < Updater
  attr_reader :updater

  def perform(recurring = true)
    begin
      updater.update
      reschedule if recurring
    end
  end
end
