# Refsheet.net

Your characters, **organized.**
*Let Refsheet help you commission, share, and socialize*

Refsheet is a place for character and world builders to attach assets 
related to their characters in one unified format, allowing artists and 
story writers to access the specific details of a character, maintaining
synchronized dynamic canon.

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

## Maintainer

This project is built and maintained by Mau, and you can reach them at
[@refsheet on Twitter](https://twitter.com/refsheet).

## Links

- Translations: [locize.io](https://www.locize.io/p/zbocgoxn)
- CI / CD: [Google Cloud Build](https://console.cloud.google.com/cloud-build/builds?organizationId=183290543501&project=refsheet-239409)
- Monitoring: [Stackdriver Monitoring](https://console.cloud.google.com/monitoring/dashboards/custom/10331969783848097169?project=refsheet-239409&timeDomain=1d)
- Logs: [Stackdriver Logging](https://console.cloud.google.com/logs/viewer?organizationId=183290543501&project=refsheet-239409&minLogLevel=0&expandAll=false&timestamp=2020-01-13T01:39:35.490000000Z&customFacets=&limitCustomFacetWidth=true&dateRangeStart=2020-01-13T00:39:35.742Z&dateRangeEnd=2020-01-13T01:39:35.742Z&interval=PT1H&resource=container&scrollTimestamp=2020-01-13T01:39:26.519636322Z)
- Infrastructure: [Google Kubernetes Engine](https://console.cloud.google.com/kubernetes/workload?organizationId=183290543501&project=refsheet-239409&workload_list_tablesize=50)
- Error Reporting: [Sentry](https://sentry.io/organizations/refsheetnet/issues/?project=1307540)
- Production: [Refsheet.net](https://refsheet.net)
- Staging: [kube.Refsheet.net](https://kube.refsheet.net)

## Special Thanks

I would like to thank the bits, and bytes, and copper and fiber wires that
made transmitting the commit containing this thank you message possible.

I would also like to thank #devfurs for being good little rubber ducks.

[4]: https://www.jetbrains.com/ruby/
 
