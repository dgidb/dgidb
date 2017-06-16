#class Updater  < ActiveJob::Base
class Updater
  def reschedule
    self.class.set(wait_until: next_month).perform_later
  end

  def next_month
    Date.today
      .beginning_of_week
      .next_month
      .midnight
  end
end
