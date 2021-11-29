namespace :deploy do
  desc 'flush memcached'
  task :flush_memcached do
    on roles(:all) do
      execute :echo, 'flush_all | nc -q 1 localhost 11211'
    end
  end
  after "deploy:published", "flush_memcached"

  desc 'update local data submodule'
  task :update_data_submodule do
    run_locally do
      with rails_env: :development do
        run_locally do
          system('git submodule update --init data')
        end
      end
    end
  end
end