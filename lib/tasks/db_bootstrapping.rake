namespace :dgidb do
  desc 'create a dump of the current local database'
  task :dump_local do
  end

  desc 'load the source controlled db dump and schema into the local db, blowing away what is currently there'
  task load_local: ['db:create', 'db:schema:load'] do
    system "psql -h localhost -d dgidb -f #{Rails.root}/db/data.sql"
  end
end
