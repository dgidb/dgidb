module ApplicationHelper
  def tx( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id].html_safe
  end

  def to( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id]
  end
end
