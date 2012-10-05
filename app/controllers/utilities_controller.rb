class UtilitiesController < ApplicationController
  def invalidate_cache
    cache_key = params[:key]
    if cache_key.blank?
      Rails.cache.clear
      #hack to clear cached pages
      FileUtils.rm_f( Dir[File.join( Rails.public_path, "*.html") ].reject{|f| f =~ /404\.html|422\.html|500\.html/} )
      render nothing: true, status: 200
    else
      ok = Rails.cache.delete(cache_key)
      render nothing: true, status: ok ? 200 : 400
    end
  end
end
