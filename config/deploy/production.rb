server "ec2-35-167-156-177.us-west-2.compute.amazonaws.com", user: 'ubuntu', roles: %w{web db}

set :rbenv_ruby, '2.6.6'

set :ssh_options, {
    keys: [ENV['DGIDB_PROD_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
}

