namespace :deploy do
  desc 'flush memcached'
  task :flush_memcached do
    on roles(:all) do
      execute :echo, 'flush_all | nc -q 1 localhost 11211'
    end
  end
  after "deploy:published", "flush_memcached"
end