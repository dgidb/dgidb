class NewsPresenter < SimpleDelegator

  def initialize(unread_item, view_context)
    super(view_context)
    @unread_item = unread_item
    @read = false
  end

  def mark_read!
    @read = true
  end

  def news_ticker
   if unread_news?
     headline = link_to(@unread_item['headline'], '/news')

     content_tag(:p) do
       concat content_tag(:hr)
       concat content_tag(:strong, 'Unread News: ')
       concat content_tag(:strong, headline)
       concat content_tag(:hr)
     end
   else
     ''
   end
  end

  def unread_news?
    !!@unread_item && !@read
  end

  def unread_news_badge
    content_tag(:span, '!', class: ['badge', 'badge-important']) if unread_news?
  end
end
