server "ec2-34-210-223-149.us-west-2.compute.amazonaws.com", user: 'ubuntu', roles: %w{web db}

set :rbenv_ruby, '2.4.1'

set :branch, 'staging'

set :ssh_options, {
    keys: [ENV['DGIDB_STAGING_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
}