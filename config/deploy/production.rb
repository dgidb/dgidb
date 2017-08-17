server "", user: 'ubuntu', roles: %w{web}

set :rbenv_ruby, '2.4.1'

set :ssh_options, {
    keys: [ENV['DGIDB_PROD_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
}

