# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['TMPDIR'] = Rails.root.join('tmp/uploads').to_s

# Initialize the rails application
DruggableGene::Application.initialize!
