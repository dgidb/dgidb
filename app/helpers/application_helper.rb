module ApplicationHelper
  def tx(fragment_id)
    EXTERNAL_STRINGS[params["action"]][fragment_id].html_safe
  end

  def to(fragment_id)
    EXTERNAL_STRINGS[params["action"]][fragment_id]
  end
end
