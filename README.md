# Refsheet.net

Your characters, **organized.**
*Let Refsheet help you commission, share, and socialize*

Refsheet is a place for character and world builders to attach assets 
related to their characters in one unified format, allowing artists and 
story writers to access the specific details of a character, maintaining
synchronized dynamic canon.

## Development Setup

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

[Travis CI][3] will take care of testing out our app when you commit
changes and push them up to the repository. If you want to test things
locally, swell! Uh, run `rspec` against the project. Or, use an IDE
like [RubyMine][4], it'll do this for you. Specs live in `./specs`.

## Maintainer

This project is built and maintained by Will, and you can reach him at
[@refsheet on Twitter](https://twitter.com/refsheet).

## Special Thanks

I would like to thank the bits, and bytes, and copper and fiber wires that
made transmitting the commit containing this thank you message possible.

I would also like to thank #devfurs for being good little rubber ducks.


[1]: https://trello.com/b/4UljEwOX/application-development
[2]: https://zube.io/eiwi1101/refsheetnet/w/application-development/kanban
[3]: https://travis-ci.com/eiwi1101/refsheet-site
[4]: https://www.jetbrains.com/ruby/