Dir["#{Rails.root}/lib/genome/extensions/*.rb"].each {|file| require file }
include Genome::Extensions