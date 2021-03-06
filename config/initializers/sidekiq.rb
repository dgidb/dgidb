require 'sidekiq'
require 'sidekiq-cron'
require 'sidekiq/web'
require 'active_support/security_utils'

schedule_file = "config/scheduled_tasks.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq::Web.use(Rack::Auth::Basic) do |submitted_user, submitted_password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking
  user = ENV["SIDEKIQ_ADMIN_USER"] || Rails.application.secrets.sidekiq_admin_user
  password = ENV["SIDEKIQ_ADMIN_PASSWORD"] || Rails.application.secrets.sidekiq_admin_password
  ActiveSupport::SecurityUtils.secure_compare(submitted_user, user) &
    ActiveSupport::SecurityUtils.secure_compare(submitted_password, password)
end
