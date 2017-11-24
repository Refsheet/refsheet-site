# -*- encoding: utf-8 -*-
# stub: will_paginate-materialize 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "will_paginate-materialize".freeze
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Patrick Lindsay".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-11-24"
  s.description = "This gem integrates the MaterializeCSS pagination component with the will_paginate pagination gem.".freeze
  s.email = ["patrick.lindsay@sage.com".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, ".travis.yml".freeze, "CHANGELOG.mod".freeze, "CODE_OF_CONDUCT.md".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/materialize_pagination/action_view.rb".freeze, "lib/materialize_pagination/materialize_renderer.rb".freeze, "lib/materialize_pagination/railtie.rb".freeze, "lib/materialize_pagination/version.rb".freeze, "lib/materialize_pagination/view_helpers.rb".freeze, "lib/will_paginate/materialize.rb".freeze, "will_paginate-materialize.gemspec".freeze]
  s.homepage = "https://github.com/patricklindsay/will_paginate-materialize".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "MaterializeCSS pagination renderer for the will_paginate pagination gem.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<will_paginate>.freeze, ["~> 3.1.3"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<will_paginate>.freeze, ["~> 3.1.3"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<will_paginate>.freeze, ["~> 3.1.3"])
  end
end
