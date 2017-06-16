class ApiUpdater < Updater
  def perform(recurring = true)
    begin
      updater.update
      reschedule if recurring
    end
  end

  def updater
    raise StandardError.new('Must implement #updater in subclass')
  end
end
