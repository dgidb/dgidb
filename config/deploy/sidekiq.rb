set :sidekiq_roles, -> { :web }
set :sidekiq_systemd_unit_name, 'sidekiq'

namespace :sidekiq do
  desc 'Quiet sidekiq (stop fetching new tasks from Redis)'
  task :quiet do
    on roles fetch(:sidekiq_roles) do
      # See: https://github.com/mperham/sidekiq/wiki/Signals#tstp
      execute :sudo, :systemctl, 'kill', '-s', 'SIGTSTP', fetch(:sidekiq_systemd_unit_name), raise_on_non_zero_exit: false
    end
  end

  desc 'Stop sidekiq (graceful shutdown within timeout, put unfinished tasks back to Redis)'
  task :stop do
    on roles fetch(:sidekiq_roles) do
      # See: https://github.com/mperham/sidekiq/wiki/Signals#tstp
      execute :sudo, :systemctl, 'kill', '-s', 'SIGTERM', fetch(:sidekiq_systemd_unit_name), raise_on_non_zero_exit: false
    end
  end

  desc 'Start sidekiq'
  task :start do
    on roles fetch(:sidekiq_roles) do
      execute :sudo, :systemctl, 'start', fetch(:sidekiq_systemd_unit_name)
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    on roles fetch(:sidekiq_roles) do
      execute :sudo, :systemctl, 'restart', fetch(:sidekiq_systemd_unit_name)
    end
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:updated', 'sidekiq:stop'
after 'deploy:published', 'sidekiq:start'
after 'deploy:failed', 'sidekiq:restart'
