web: bundle exec rails server -b 0.0.0.0 -p $PORT
webpacker: ./bin/webpack-dev-server
worker: bundle exec rake resque:work QUEUE=*
cable: bundle exec puma -p 28080 cable/config.ru