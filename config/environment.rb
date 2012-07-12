# Load the rails application
require File.expand_path('../application', __FILE__)

upload_path = Rails.root.join('tmp/uploads').to_s
unless File.exists?(upload_path) && File.directory?(upload_path)
  FileUtils.mkdir_p(upload_path)
end

ENV['TMPDIR'] = upload_path
# Initialize the rails application
DruggableGene::Application.initialize!
