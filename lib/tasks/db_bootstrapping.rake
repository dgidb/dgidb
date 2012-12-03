require 'rbconfig'

namespace :dgidb do

  data_file = "#{Rails.root}/db/data.sql"

  desc 'set up path for macs running Postgres.app'
  task :setup_path do
    #special case for macs running Postgres.app
    if RbConfig::CONFIG['host_os'] =~ /darwin/ && File.exist?( '/Applications/Postgres.app' )
      ENV['PATH'] = "/Applications/Postgres.app/Contents/MacOS/bin:#{ENV['PATH']}"
    end
  end

  desc 'create a dump of the current local database'
  task dump_local: [:setup_path] do
    system "pg_dump -a -f #{data_file} -h localhost dgidb"
  end

  desc 'load the source controlled db dump and schema into the local db, blowing away what is currently there'
  task load_local: ['setup_path', 'db:drop', 'db:create', 'db:schema:load'] do
    system "psql -h localhost -d dgidb -f #{data_file}"
  end

end
