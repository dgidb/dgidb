class UtilitiesController < ApplicationController
  def invalidate_cache
    cache_key = params[:key]
    if cache_key.blank?
      Rails.cache.clear
      render nothing: true, status: 200
    else
      ok = Rails.cache.delete(cache_key)
      render nothing: true, status: ok ? 200 : 400
    end
  end
end
