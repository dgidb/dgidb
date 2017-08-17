set :application, "dgidb"
set :repo_url, "https://github.com/griffithlab/dgi-db.git"

set :stages, ["staging", "production"]
set :default_stage, "staging"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/dgidb"

set :rbenv_type, :user

set :migration_role, :web

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
