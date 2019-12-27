# Refsheet.net

Your characters, **organized.**
*Let Refsheet help you commission, share, and socialize*

Refsheet is a place for character and world builders to attach assets 
related to their characters in one unified format, allowing artists and 
story writers to access the specific details of a character, maintaining
synchronized dynamic canon.

## Docker

A note on starting up the website in development mode:

docker-compose up will start the worker and the website at the same time, which is awesome if you want to run migrations twice on top of each other (Rails doesn't like this).

To start it up and keep the website logs in the foreground:

    docker-compose start postgres
    docker-compose start redis
    docker-compose start worker
    docker-compose up website

## Development Setup VERY OUT OF DATE! (7/30/19)

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

## Issue Tracking

We use [Trello][1] for issue influx and collaborating with the 
non-developers and not so technical things within the app. Development 
related cards move to the 'Development' list, and should be 
cross-reported in GitHub as issues, which land in the Triage queue of 
[Zube.io][2], our development tracker.

### Branch Naming

Branches should be named thusly (draft):

- `f/feature-name` - For features that hold until next release.
- `p/patch-name` - For patches that need to go out right away.
- `b/145-bug-name` - Where 145 is the GH Issue for the bug.

## Testing

CircleCI handles testing and deploys to Amazon. Google Cloud Build handles
testing and deploy to Kubernetes. If you want to test things
locally, swell! Uh, run `rspec` against the project. Or, use an IDE
like [RubyMine][4], it'll do this for you. Specs live in `./specs`.

## Maintainer

This project is built and maintained by Mau, and you them reach him at
[@refsheet on Twitter](https://twitter.com/refsheet).

## Special Thanks

I would like to thank the bits, and bytes, and copper and fiber wires that
made transmitting the commit containing this thank you message possible.

I would also like to thank #devfurs for being good little rubber ducks.


[1]: https://trello.com/b/4UljEwOX/application-development
[2]: https://zube.io/eiwi1101/refsheetnet/w/application-development/kanban
[3]: https://travis-ci.com/eiwi1101/refsheet-site
[4]: https://www.jetbrains.com/ruby/
 
