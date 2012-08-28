module ApplicationHelper
  def tx(fragment_id)
    EXTERNAL_STRINGS[params["action"]][fragment_id].html_safe
  end
end
