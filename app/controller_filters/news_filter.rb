class NewsFilter
  def self.filter(controller)
    unread_news = if read_date = controller.send(:cookies)[:most_recent_post_date]
                     most_recent_post_date > DateTime.parse(read_date)
                   else
                     true
                   end
    controller.instance_variable_set('@unread_news', unread_news)
  end

  def self.most_recent_post_date
    @@most_recent_post_date ||= Date.parse(EXTERNAL_STRINGS['news']['posts'].last['date'])
  end
end
