Dir[Rails.root + "lib/**/*.rb"].each { |f| require f }

include Genome::Extensions