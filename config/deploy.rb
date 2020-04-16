set :application, "dgidb"
set :repo_url, "https://github.com/griffithlab/dgi-db.git"

set :rails_env, "production"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/dgidb"

set :rbenv_type, :user
set :rbenv_ruby, '2.3.4'

set :migration_role, :web

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/data')
append :linked_dirs, '.bundle'
