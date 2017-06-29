class UtilitiesController < ApplicationController
  def invalidate_cache
    cache_key = params[:key]
    if cache_key.blank?
      Rails.cache.clear
      #hack to clear cached pages
      FileUtils.rm_f( Dir[File.join( Rails.public_path, "**/*.html") ].reject{|f| f =~ /404\.html|422\.html|500\.html/} )
      render nothing: true, status: 200
    else
      ok = Rails.cache.delete(cache_key)
      render nothing: true, status: ok ? 200 : 400
    end
  end

  def download_request_content
    generate_tsv_headers(params[:filename] || "dgidb_export_#{Date.today}.tsv")
    render body: CGI::unescape(params[:file_contents])
  end

  private
  def generate_tsv_headers(filename)
    headers.merge!({
      'Cache-Control'             => 'must-revalidate, post-check=0, pre-check=0',
      'Content-Type'              => 'text/tsv',
      'Content-Disposition'       => "attachment; filename=\"#{filename}\"",
      'Content-Transfer-Encoding' => 'binary'
    })
  end
end
