require 'rbconfig'

namespace :dgidb do

  data_file = "#{Rails.root}/db/data.sql"

  desc 'set up path for macs running Postgres.app'
  task :setup_path do
    #special case for macs running Postgres.app
    if RbConfig::CONFIG['host_os'] =~ /darwin/ && File.exist?( '/Applications/Postgres.app' )
      puts 'Found Postgres.app'
      ENV['PATH'] = "/Applications/Postgres.app/Contents/MacOS/bin:#{ENV['PATH']}"
    end

    # MacPorts Handling
    macports_postgres = Dir.glob( '/opt/local/lib/postgresql*/bin')
    macports_postgres_path = macports_postgres.last
    macports_postgres_version = File.basename(File.dirname(macports_postgres_path))
    if RbConfig::CONFIG['host_os'] =~ /darwin/ && macports_postgres.any?
      puts "Found MacPorts #{macports_postgres_version}"
      ENV['PATH'] = "#{macports_postgres_path}:#{ENV['PATH']}"
    end

    # Homebrew Handling (TODO)
  end

  desc 'create a dump of the current local database'
  task dump_local: [:setup_path] do
    system "pg_dump -a -f #{data_file} -h localhost dgidb"
  end

  desc 'load the source controlled db dump and schema into the local db, blowing away what is currently there'
  task load_local: ['setup_path', 'db:drop', 'db:create', 'db:structure:load'] do
    system "psql -h localhost -d dgidb -f #{data_file}"
  end

end
