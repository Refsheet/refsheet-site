# -*- encoding: utf-8 -*-
# stub: react-rails 1.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "react-rails".freeze
  s.version = "1.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Paul O\u{2019}Shannessy".freeze]
  s.date = "2017-11-24"
  s.description = "Compile your JSX on demand or precompile for production.".freeze
  s.email = ["paul@oshannessy.com".freeze]
  s.files = ["CHANGELOG.md".freeze, "LICENSE".freeze, "README.md".freeze, "lib/assets/javascripts".freeze, "lib/assets/javascripts/JSXTransformer.js".freeze, "lib/assets/javascripts/react_ujs.js".freeze, "lib/assets/javascripts/react_ujs_event_setup.js".freeze, "lib/assets/javascripts/react_ujs_mount.js".freeze, "lib/assets/javascripts/react_ujs_native.js".freeze, "lib/assets/javascripts/react_ujs_pjax.js".freeze, "lib/assets/javascripts/react_ujs_turbolinks.js".freeze, "lib/assets/javascripts/react_ujs_turbolinks_classic.js".freeze, "lib/assets/javascripts/react_ujs_turbolinks_classic_deprecated.js".freeze, "lib/assets/react-source".freeze, "lib/assets/react-source/development".freeze, "lib/assets/react-source/development-with-addons".freeze, "lib/assets/react-source/development-with-addons/react-server.js".freeze, "lib/assets/react-source/development-with-addons/react.js".freeze, "lib/assets/react-source/development/react-server.js".freeze, "lib/assets/react-source/development/react.js".freeze, "lib/assets/react-source/production".freeze, "lib/assets/react-source/production-with-addons".freeze, "lib/assets/react-source/production-with-addons/react-server.js".freeze, "lib/assets/react-source/production-with-addons/react.js".freeze, "lib/assets/react-source/production/react-server.js".freeze, "lib/assets/react-source/production/react.js".freeze, "lib/generators".freeze, "lib/generators/react".freeze, "lib/generators/react/component_generator.rb".freeze, "lib/generators/react/install_generator.rb".freeze, "lib/generators/react/ujs_generator.rb".freeze, "lib/generators/templates".freeze, "lib/generators/templates/component.es6.jsx".freeze, "lib/generators/templates/component.js.jsx".freeze, "lib/generators/templates/component.js.jsx.coffee".freeze, "lib/react".freeze, "lib/react-rails.rb".freeze, "lib/react.rb".freeze, "lib/react/jsx".freeze, "lib/react/jsx.rb".freeze, "lib/react/jsx/babel_transformer.rb".freeze, "lib/react/jsx/jsx_transformer.rb".freeze, "lib/react/jsx/processor.rb".freeze, "lib/react/jsx/sprockets_strategy.rb".freeze, "lib/react/jsx/template.rb".freeze, "lib/react/rails".freeze, "lib/react/rails.rb".freeze, "lib/react/rails/asset_variant.rb".freeze, "lib/react/rails/component_mount.rb".freeze, "lib/react/rails/controller_lifecycle.rb".freeze, "lib/react/rails/controller_renderer.rb".freeze, "lib/react/rails/railtie.rb".freeze, "lib/react/rails/version.rb".freeze, "lib/react/rails/view_helper.rb".freeze, "lib/react/server_rendering".freeze, "lib/react/server_rendering.rb".freeze, "lib/react/server_rendering/environment_container.rb".freeze, "lib/react/server_rendering/exec_js_renderer.rb".freeze, "lib/react/server_rendering/manifest_container.rb".freeze, "lib/react/server_rendering/sprockets_renderer".freeze, "lib/react/server_rendering/sprockets_renderer.rb".freeze, "lib/react/server_rendering/sprockets_renderer/console_polyfill.js".freeze, "lib/react/server_rendering/sprockets_renderer/console_replay.js".freeze, "lib/react/server_rendering/sprockets_renderer/timeout_polyfill.js".freeze, "lib/react/server_rendering/yaml_manifest_container.rb".freeze]
  s.homepage = "https://github.com/reactjs/react-rails".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "React/JSX adapter for the Ruby on Rails asset pipeline.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.2.2"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
      s.add_development_dependency(%q<coffee-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<es5-shim-rails>.freeze, [">= 2.0.5"])
      s.add_development_dependency(%q<guard>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<jbuilder>.freeze, [">= 0"])
      s.add_development_dependency(%q<listen>.freeze, ["~> 3.0.0"])
      s.add_development_dependency(%q<poltergeist>.freeze, [">= 0.3.3"])
      s.add_development_dependency(%q<test-unit>.freeze, ["~> 2.5"])
      s.add_development_dependency(%q<turbolinks>.freeze, [">= 2.0.0"])
      s.add_development_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_runtime_dependency(%q<coffee-script-source>.freeze, ["~> 1.8"])
      s.add_runtime_dependency(%q<connection_pool>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<execjs>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2"])
      s.add_runtime_dependency(%q<tilt>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<babel-transpiler>.freeze, [">= 0.7.0"])
    else
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.2.2"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
      s.add_dependency(%q<coffee-rails>.freeze, [">= 0"])
      s.add_dependency(%q<es5-shim-rails>.freeze, [">= 2.0.5"])
      s.add_dependency(%q<guard>.freeze, [">= 0"])
      s.add_dependency(%q<guard-minitest>.freeze, [">= 0"])
      s.add_dependency(%q<jbuilder>.freeze, [">= 0"])
      s.add_dependency(%q<listen>.freeze, ["~> 3.0.0"])
      s.add_dependency(%q<poltergeist>.freeze, [">= 0.3.3"])
      s.add_dependency(%q<test-unit>.freeze, ["~> 2.5"])
      s.add_dependency(%q<turbolinks>.freeze, [">= 2.0.0"])
      s.add_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_dependency(%q<coffee-script-source>.freeze, ["~> 1.8"])
      s.add_dependency(%q<connection_pool>.freeze, [">= 0"])
      s.add_dependency(%q<execjs>.freeze, [">= 0"])
      s.add_dependency(%q<railties>.freeze, [">= 3.2"])
      s.add_dependency(%q<tilt>.freeze, [">= 0"])
      s.add_dependency(%q<babel-transpiler>.freeze, [">= 0.7.0"])
    end
  else
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.2.2"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    s.add_dependency(%q<coffee-rails>.freeze, [">= 0"])
    s.add_dependency(%q<es5-shim-rails>.freeze, [">= 2.0.5"])
    s.add_dependency(%q<guard>.freeze, [">= 0"])
    s.add_dependency(%q<guard-minitest>.freeze, [">= 0"])
    s.add_dependency(%q<jbuilder>.freeze, [">= 0"])
    s.add_dependency(%q<listen>.freeze, ["~> 3.0.0"])
    s.add_dependency(%q<poltergeist>.freeze, [">= 0.3.3"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 2.5"])
    s.add_dependency(%q<turbolinks>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<rails>.freeze, [">= 3.2"])
    s.add_dependency(%q<coffee-script-source>.freeze, ["~> 1.8"])
    s.add_dependency(%q<connection_pool>.freeze, [">= 0"])
    s.add_dependency(%q<execjs>.freeze, [">= 0"])
    s.add_dependency(%q<railties>.freeze, [">= 3.2"])
    s.add_dependency(%q<tilt>.freeze, [">= 0"])
    s.add_dependency(%q<babel-transpiler>.freeze, [">= 0.7.0"])
  end
end
