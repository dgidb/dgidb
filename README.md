Rails frontend to The Genome Institute's drug gene interaction database.

Install dependencies (works on Ubuntu Precise):
    sudo apt-get update
    sudo apt-get install ruby1.9.1  ruby1.9.1-dev  rubygems1.9.1  irb1.9.1  ri1.9.1  rdoc1.9.1  build-essential  apache2  libopenssl-ruby1.9.1  libssl-dev  zlib1g-dev  libcurl4-openssl-dev  apache2-prefork-dev  libapr1-dev  libaprutil1-dev
    sudo apt-get install memcached postgresql postgresql-contrib libpq-dev libxslt-dev libxml2-dev
    sudo /usr/bin/gem1.9.1 install bundler --no-ri --no-rdoc

    # choose ruby 1.9.1
    sudo update-alternatives --config ruby

    # choose gem 1.9.1 (gem 1.8.11 is /usr/bin/gem1.9.1 because it works with 1.9.1)
    sudo update-alternatives --config gem

    # setup the database
    sudo -u postgres psql -d dgidb -f /var/www/dgi-db/db/data.sql
   
    # to run in production 
    cd ..
    sudo mv dgi-db /var/www/
    sudo chown -R www-data /var/www/dgi-db/
    cd /var/www/dgi-db && sudo -u www-data RAILS_ENV=production /usr/bin/ruby1.9.1 /usr/local/bin/bundle exec rake -f /var/www/dgi-db/Rakefile db:schema:load && cd -
    sudo -u www-data touch /var/www/dgi-db/tmp/restart.txt

Additional documentation forthcoming.
