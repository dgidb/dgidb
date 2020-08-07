module ApiAnalytics
  extend ActiveSupport::Concern

  included do
    after_action :queue_google_analytics_submission

    def self.skip_analytics(*actions)
      skip_after_action :queue_google_analytics_submission, only: actions
    end
  end

  def queue_google_analytics_submission
    if should_send_analytics?
      SendApiAnalytics.perform_later(
        referrer: request.referer,
        user_agent: request.user_agent,
        user_ip: request.remote_ip,
        path: request.path,
      )
    end
  end

  private
  def should_send_analytics?
    [
      Rails.env.production?,
    ].all?
  end
end