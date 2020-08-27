class SendApiAnalytics < ApplicationJob
  def perform(args = {})
    tracker = Staccato.tracker('UA-35524735-1', nil, ssl: true)
    tracker.pageview(args)
  end
end
