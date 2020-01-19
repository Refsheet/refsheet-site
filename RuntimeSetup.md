# Development Setup VERY OUT OF DATE! (7/30/19)

> This section is super out of date but Mau hasn't added better instructions.
> We use docker now. Install `docker-compose` and run `docker-compose up`
> Check out the whateveritis file that compose uses for service descriptions.
>
> Build `Dockerfile.dev` in dev. `Dockerfile` builds a prod instance, which
> takes 19 evers to precompile assets.

Make sure you have **Ruby 2.3.1** installed, this project was built with
`rbenv` in mind. You'll need Git, obviously, and a connection to the
World Wide Web. You might need to install a modem for this, see your
workstation's hardware manufacturer for details.

Oh yeah, install `postgres` or be prepared for pain. Also install
`redis-server`, and `resque`.

### Setup Steps

1. `rbenv install 2.3.1`
1. `gem install bundler`
1. `bundle install`
1. `createuser -dP refsheet-site-test`
   - Specify `fishsticks` as a password.
1. `createuser -dP refsheet-site-dev`
   - Specify `fishsticks` as a password.
1. `bundle exec rake db:create`
1. `bundle exec rake db:migrate`

### Running Locally

Start Rails however you start Rails. Puma is our server of choice for
local development. `rails s` will default to port 3000 of course, you
should change this if you have other projects going on. I use 3012.

If you want any of the background jobs to work (image processing, etc)
you're going to have to start up Resque.

`$ QUEUE=* bundle exec rake environment resque:work`