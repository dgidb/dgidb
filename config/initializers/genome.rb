Dir[Rails.root + "lib/**/*.rb"].sort_by(&length).each { |f| require f }

include Genome::Extensions