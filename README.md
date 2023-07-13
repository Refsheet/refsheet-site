# Refsheet.net

Your characters, **organized.**
*Let Refsheet help you commission, share, and socialize*

Refsheet is a place for character and world builders to attach assets 
related to their characters in one unified format, allowing artists and 
story writers to access the specific details of a character, maintaining
synchronized dynamic canon.

## THE SOURCE CODE FOR THIS REPOSITORY IS SPLITTING
## THE FRONTEND LIVES IN A NEW REPOSITORY
## THIS IS JUST THE BACKEND CODE NOW
## AND THE SPLIT IS NOT DONE
## THEREFORE I AM NOT RESPONSIBLE FOR YOU CONTRIBUTING TO THIS DEAD CODEBASE
## AND WOULD POLITELY REQUEST THAT YOU DO NOT CONTRIBUTE TO THIS BRANCH
## IF YOU WOULD LIKE TO HELP
### which would be a miracle this thing has been open source for like 3 years and hasn't had much help
## PLEASE DIRECT YOUR ATTENTION AND JAVASCRIPT LOVING BRAIN TO THIS SHINY LINK
## [https://github.com/Refsheet/refsheet-site-frontend](https://github.com/Refsheet/refsheet-site-frontend)
## THAT IS ALL

## Development

This app is now Dockerized. Install Docker and `docker-compose` to get going.

*A note on starting up the website in development mode:* `docker-compose up` will start the worker and the website at 
the same time, which is awesome if you want to run migrations twice on top of each other (Rails doesn't like this).

To start it up and keep the website logs in the foreground:

    docker-compose start postgres
    docker-compose start redis
    docker-compose start worker
    docker-compose up website
    
For your convenience, this has been summed up in `bin/start-dev`. I recommend adding `./bin` to your `$PATH`:

    echo 'export PATH="$PATH:./bin"' >> ~/.bashrc
    
#### bin/r

Since commands should be run in Docker, there is a helper in `bin/r` which can be used to run commands against the 
`website` container. The following are equivalent:

    # "Run Bundle"
    bin/rb rake db:migrate
    
    # "Run"
    bin/r bundle exec rake db:migrate
    
    # Both same as:
    docker-compose run website bundle exec rake db:migrate
    
    # If you adjusted your PATH to include ./bin
    rb rake db:migrate
    
### Initial Setup

You might need to create a database for something useful to happen. Rake does this:

    bin/r rake db:setup RAILS_ENV=development
    bin/r rake db:create RAILS_ENV=test

### Testing

Google Cloud Build handles testing and deploy to Kubernetes. If you want to test things
locally, swell! Uh, run `rspec` against the project. Or, use an IDE
like [RubyMine][4], it'll do this for you. Specs live in `./specs`.

    bin/r rspec
    bin/r yarn run karma

### Prettier

Javascript code is made prettier by Prettier. Your checks will fail in CI if you change Javascript code and it isn't
pretty enough. Before you commit:

    bin/r yarn run prettier

## Rake & Yarn

A few custom Rake and Yarn Run tasks exist to make life a bit better. 

### Rake

- `rake api:generate` - Regenerate Swagger docs from API changes
- `rake kube:update_config` - Apply config changes in .kubernetes folder
- `rake sitemap:refresh` - Regenerate sitemap files and ping search engines

### Yarn Run

- `yarn run test` - Run Karma specs
- `yarn run prettier` - Do this before committing
- `yarn run eslint` - Check for javascript code errors
- `bin/update-apollo-fragments.js` - Update Apollo (graphql) code fragments config, used if unions change

## Maintainer

This project is built and maintained by Mau, and you can reach them at
[@refsheet on Twitter](https://twitter.com/refsheet).

## Links

- Translations: [locize.io](https://www.locize.io/p/zbocgoxn)
- CI / CD: [Google Cloud Build](https://console.cloud.google.com/cloud-build/builds?organizationId=183290543501&project=refsheet-239409)
- Monitoring: [Stackdriver Monitoring](https://console.cloud.google.com/monitoring/dashboards/custom/10331969783848097169?project=refsheet-239409&timeDomain=1d)
- Logs: [Stackdriver Logging](https://console.cloud.google.com/logs/viewer?organizationId=183290543501&project=refsheet-239409&minLogLevel=0&expandAll=false&timestamp=2020-01-27T07:48:17.205000000Z&customFacets=resource.labels.container_name&limitCustomFacetWidth=true&dateRangeStart=2020-01-27T06:48:31.898Z&dateRangeEnd=2020-01-27T07:48:31.898Z&interval=PT1H&resource=k8s_container)
- Infrastructure: [Google Kubernetes Engine](https://console.cloud.google.com/kubernetes/workload?organizationId=183290543501&project=refsheet-239409&workload_list_tablesize=50)
- Error Reporting: [Sentry](https://sentry.io/organizations/refsheetnet/issues/?project=1307540)
- Production: [Refsheet.net](https://refsheet.net)
- Staging: [kube.Refsheet.net](https://kube.refsheet.net)

## Special Thanks

I would like to thank the bits, and bytes, and copper and fiber wires that
made transmitting the commit containing this thank you message possible.

I would also like to thank #devfurs for being good little rubber ducks.

[4]: https://www.jetbrains.com/ruby/
 
