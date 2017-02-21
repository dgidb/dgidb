class NewsFilter
  def self.before(controller)
    unread_news = if read_date = controller.send(:cookies)[:most_recent_post_date]
                     most_recent_post_date > DateTime.parse(read_date)
                   else
                     true
                   end

    news_item = if unread_news
                  most_recent_post
                else
                  nil
                end

    news_presenter = NewsPresenter.new(news_item, controller.view_context)

    controller.instance_variable_set('@news', news_presenter)
  end

  def self.most_recent_post_date
    @@most_recent_post_date ||= Date.parse(EXTERNAL_STRINGS['news']['posts'].last['date'])
  end

  def self.most_recent_post
    @@most_recent_post ||= EXTERNAL_STRINGS['news']['posts'].last
  end
end
