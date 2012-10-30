class ApplicationController < ActionController::Base
  include GenomeModels
  protect_from_forgery
  rescue_from HTTPStatus::NotFound, with: :render_404
  rescue_from HTTPStatus::BadRequest, with: :render_400
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  #before_filter :authenticate

  def generate_tsv_headers(filename)
    headers.merge!({
      'Cache-Control'             => 'must-revalidate, post-check=0, pre-check=0',
      'Content-Type'              => 'text/tsv',
      'Content-Disposition'       => "attachment; filename=\"#{filename}\"",
      'Content-Transfer-Encoding' => 'binary'
    })
  end

  def not_found(msg = "Not Found")
    raise HTTPStatus::NotFound.new(msg)
  end

  def bad_request(msg = "Bad Request")
    raise HTTPStatus::BadRequest.new(msg)
  end

  [404,400].each do |status|
    define_method("render_#{status}") do |exception|
      flash.now[:error] = exception.message
      respond_to do |type|
        type.html { render template: "errors/#{status}", layout: 'application', status: status }
        type.all  { render nothing: true, status: status }
      end
    end
  end

  def combine_input_genes(params)
    gene_names = params[:genes].split("\n")
    gene_names.delete_if{|gene| gene.strip.empty? }
    params[:gene_names] = gene_names.map{ |name| name.strip.upcase }.uniq
  end

  private
  def authenticate
    authenticate_or_request_with_http_digest do |username|
      USERS[username]
    end
  end

end
