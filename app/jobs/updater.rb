#class Updater  < ActiveJob::Base
class Updater
  def reschedule
    self.class.set(wait_until: next_update_time).perform_later
  end

  def next_update_time
    raise StandardError.new('Must implement #next_update_time in subclass')
  end
end
