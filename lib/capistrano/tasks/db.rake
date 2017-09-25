namespace :db do
  desc 'deploy local data files to remote database'
  task load_remote: [:copy_data_to_remote, :restore_remote_db]

  desc 'copy local data files to remote server'
  task :copy_data_to_remote do
    on roles(:all) do
      upload!('data/data.sql', "#{shared_path}/data/data.sql")
      %w(interactions categories genes drugs).each do |type|
        upload!("data/#{type}.tsv", "#{shared_path}/data/#{type}.tsv")
      end
    end
  end

  desc 'restore database from remote data.sql file'
  task :restore_remote_db do
    ustring = '-U dgidb'
    hstring = '-h 127.0.0.1'
    dstring = '-d dgidb'
    on roles(:all) do
      execute sudo :service, :apache2, :stop
      begin
        execute :dropdb, :dgidb
        execute :createdb, ustring, hstring, :dgidb
        execute :psql, ustring, hstring, dstring, "< #{current_path}/db/structure.sql"
        execute :psql, ustring, hstring, dstring, "< #{shared_path}/data/data.sql"
      ensure
        execute sudo :service, :memcached, :restart
        execute sudo :service, :apache2, :start
      end
    end
  end
end
