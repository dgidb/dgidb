class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from HTTPStatus::NotFound, with: :render_404
  rescue_from HTTPStatus::BadRequest, with: :render_400
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_action TourFilter
  before_action NewsFilter

  def append_info_to_payload(payload)
    super
    payload[:genes] = params[:gene_names] if params[:gene_names]
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
        type.json { render json: { error: exception.message }.to_json, status: status }
        type.xml  { render xml: { error: exception.message }.to_xml, status: status }
        type.all  { render nothing: true, status: status }
      end
    end
  end

  def combine_input_genes(params)
    bad_request("You must enter at least one gene name to search!") unless params[:genes]
    split_char = params[:genes].include?(',') ? ',' : "\n"
    gene_names = params[:genes].split(split_char)
    gene_names.delete_if{ |gene| gene.strip.empty? }
    params[:gene_names] = gene_names.map{ |name| name.strip.upcase }.uniq
  end

  def combine_input_drugs(params)
    bad_request("You must enter at least one drug name to search!") unless params[:drugs]
    split_char = params[:drugs].include?(',') ? ',' : "\n"
    drug_names = params[:drugs].split(split_char)
    drug_names.delete_if{ |drug| drug.strip.empty? }
    params[:drug_names] = drug_names.map{ |name| name.strip.upcase }.uniq
  end

  def interpret_search_logic(params, run=1)
    bad_request("You must enter at least one term to search!") unless params[:identifiers]
    return_search = params[:identifiers].dup
    if run == 1
      return_search.gsub!(/(?:\A|\s*)\K(?:\".*?\")(?=\s*|\z)/i) { "#{$&}".gsub(/\(/, '^').gsub(/\)/, '$').gsub(/\s/, '#') }
      return_search.gsub!(/(?:\A|\s*)\K(?:\".*?\")(?=\s*|\z)/i) { "logical_interaction_search^#{$&}$.to_s" } 
      return_search.gsub!(/\(/i, '"("+')
      return_search.gsub!(/\)/i, '+")"')
      return_search.gsub!(/\sand\s/i, ' "&" ')
      return_search.gsub!(/\sor\s/i, ' "|" ')
      return_search.gsub!(/\snot\s/i, ' "-" ')
      return_search.gsub!(/\s/, '+')
      return_search.gsub!(/\^/, '(')
      return_search.gsub!(/\$/, ')')
      return_search.gsub!(/\#/, ' ')
    else
      return_search.gsub!(/\sand\s/i, ' & ')
      return_search.gsub!(/\sor\s/i, ' | ')
      return_search.gsub!(/\snot\s/i, ' - ')
      return_search.gsub!(/(?:\A|\s*)\K(?:\".*?\")(?=\s*|\z)/i) { "logical_interaction_search(#{$&}, matches, 2)" }
      return_search.gsub!(/\&/i, '|')
    end
    return_search
  end

  def determine_search_mode(term, params)
    if term =~ /\S+[\[\(](?:gene)/i
      term.gsub!(/[\[\(]gene.*/, '')
      params[:search_mode] = 'genes'
      params[:genes] = term
      combine_input_genes(params)
    elsif term =~ /\S+[\[\(](?:drug)/i
      term.gsub!(/[\[\(]drug.*/, '')
      params[:search_mode] = 'drugs'
      params[:drugs] = term
      combine_input_drugs(params)
    else
      term.gsub!(/[\[\(](?:gene|drug).*/, '')
      params[:search_mode] = 'mixed'
      params[:genes] = term
      params[:drugs] = params[:genes]
      combine_input_genes(params)
      combine_input_drugs(params)
    end
    term
  end

  private
  def validate_interaction_request(params)
    if params[:search_mode].nil?
      if params[:genes]
        params[:search_mode] = 'genes'
      elsif params[:drugs]
        params[:search_mode] = 'drugs'
      end
    end
    if params[:search_mode] == 'genes'
      bad_request('You must enter at least one gene name to search!') if params[:gene_names].size == 0
    elsif params[:search_mode] == 'drugs'
      bad_request('You must enter at least one drug name to search!') if params[:drug_names].size == 0
    else
      bad_request('You must enter at least one gene or drug name to search!') if params[:drug_names].size == 0 && params[:gene_names].size == 0
    end
  end

  def validate_logical_interaction_request(term)
    bad_request('You must enter at least one gene or drug name to search!') if term.length == 0
  end

  def validate_search_request(params)
    params[:identifiers] = params[:identifiers].scan(/./).select { |b| b.match(/[\w\s\-\[\]\(\)\@\_\'\,\.\/\+\"]/) }.join.strip
    bad_request('You must enter at least one gene or drug name to search!') if params[:identifiers].length == 0
    params[:identifiers].gsub(/(?:\A|\s*)\(*\".*?\"\)*(?=\s*|\z)/, '').split(' ').each do |term|
      if term.match(/\b(?!and|or|not)\S+/)
        bad_request('There is a syntax error in your search!')
      end
    end
  end

end
