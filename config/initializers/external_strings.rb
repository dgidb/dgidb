EXTERNAL_STRINGS = {}

Dir[Rails.root.join('text',"*.yml")].each do |file|
  EXTERNAL_STRINGS.merge!(YAML.load_file(file))
end
