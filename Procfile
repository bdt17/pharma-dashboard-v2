web: bundle exec rails server -p $PORT -e $RAILS_ENV || puma -p $PORT
worker: bundle exec sidekiq -C config/sidekiq.yml
