TOURS = {}

Dir[Rails.root.join('tours',"*.yml")].each do |file|
  TOURS.merge!(YAML.load_file(file))
end

TOURS.each do |k, v|
  v.values.each do |text|
    text.strip!
  end
end
