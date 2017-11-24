# WillPaginate::Materialize

This gem integrates the [MaterializeCSS](https://github.com/Dogfalo/materialize) [pagination component](http://materializecss.com/pagination.html) with the [will_paginate](https://github.com/mislav/will_paginate) pagination gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'will_paginate-materialize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install will_paginate-materialize

## Usage

1. Install [Materialize-sass](https://github.com/mkhairi/materialize-sass) (if you haven't already)
2. Add the following to your application.scss file
```
.pagination li.active a {
  color: #fff;
}
```
3. Add the following into your HEAD. This loads the [Google Material design Icon fonts](https://google.github.io/material-design-icons/#what-are-material-icons).
```
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
```

You're done! Use the will_paginate helper as you would otherwise.
```ruby
<%= will_paginate @collection %>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patricklindsay/will_paginate-materialize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

### Further works
 * Add specs

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

