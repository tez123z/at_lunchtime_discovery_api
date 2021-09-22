#! /bin/sh

# if database exists, migrate else setup (create and seed)
bundle exec rake db:prepare && echo "Database is ready!"