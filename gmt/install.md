### Installation

#### Prerequisites
In order to run DGIdb locally, you will need the following installed:

* PostgreSQL >= 9.x
* Ruby >= 1.9.3

#### Instructions
    git clone https://github.com/genome/dgi-db.git
    cd dgi-db
    bundle install
    bundle exec rake db:load_local
    bundle exec rails s



