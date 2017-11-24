# react-rails

#### Breaking Changes

#### New Features

#### Deprecation

#### Bug Fixes

## 1.10.0 (October 6, 2016)

#### Breaking Changes

- Alias `window = this;` has been removed from the default server rendering JavaScript to improve detection of the server rendering environment. To get the old behavior, you can add the alias in your own server rendering code. #615

#### New Features

- Calling `setTimeout` or `clearTimeout` in server rendering will raise an informative error because they aren't supported #618
- `prerender:` options will be passed to server renderer methods #641
- `react_component(..., camelize_props:)` option will override the application default #642, #645
- Ship with React.js 15.4.1 #646

#### Deprecation

#### Bug Fixes

- use `['default']` accessor to support old JavaScript versions #619
- `react_component` with a block will correctly render the content inside the `div`

## 1.9.0 (October 6, 2016)

#### Breaking Changes

#### New Features

- Accept extra JS code in `code:` option for SprocketsRenderer #604

#### Bug Fixes

- Use `asset_prefix` for YamlContainer #598
- Fix requiring `.js` from `.es6.jsx` #591

## 1.8.2 (August 9, 2016)

#### New Features

- Update to React 15.3.0 #583

#### Bug Fixes

- Fix `//= require` on Sprockets 3.7+ #582

## 1.8.1 (July 29, 2016)

#### New Features

- Update to React 15.2.1 #569

#### Bug Fixes

- Fix deprecation warnings on Sprockets 3.7+ #574
- Stop building broken addons files #576

## 1.8.0 (June 29, 2016)

#### New Features

- Sprockets 4 Support 🎉 #560
- Depend on Railties, not Rails #558
- Don't depend on `sprockets/railtie` #558
- Expose `React.camelize_props(props_hash)` #556
- Add `rails generate react:ujs --output=...` for copying the UJS into your app #557
- Support Babel 6 module exports & extension point `ReactRailsUJS.getConstructor` #503

## 1.7.2 (June 19, 2016)

#### New Features

- Improved error messages for missing components #538

#### Bug Fixes

- Fix `view_helper_implementation` config #551
- Fallback to `EnvironmentContainer` for server rendering when manifest isn't available #545

## 1.7.1 (May 10, 2016)

#### New Features

- Update to React 15.0.2 #525

#### Bug Fixes

- Update `.to_prepare` for Rails 5 #526
- Use `register_engine` with Sprockets 3 to avoid compiling _all_ files #522

## 1.7.0 (April 29, 2016)

#### New Features

- Update to React 15.0.1 #512
- Support PJAX #518
- Static renders don't include `data-react-` attributes #497

#### Bug Fixes

- Better unmounting on Turbolinks 5 #521
- Fix console replay #496

## 1.6.2 (February 28, 2016)

#### Bug Fixes

- Fix Server Rendering for Rails 3.2 #487

## 1.6.1 (February 28, 2016)

#### New Features

- UJS can mount and unmount a component by ID (not only the component's children) #466
- Support Turbolinks 5 #475

#### Bug Fixes

- Support nested arrays with `camelize_props` #480
- Improve Sprockets 3 compatibility #453
- Fix install-generator `require` spacing #476

## 1.6.0 (February 4, 2016)

#### New Features

- Individual add-ons can be included in a bundle with sprockets require directives. #457
- Support `sprockets-rails` 3 #430
- Update to React 0.14.6

#### Bug Fixes

- Fix install generator when `//= require`s are malformed #463
- Use `before_action` if available #456
- Add CHANGELOG to gem bundle #471
- Use `window.attachEvent` to support IE8 without jQuery 😬#446

## 1.5.0 (November 25, 2015)

#### New Features

- Update to React 0.14.3 #412
- `config.react.camelize_props = true` will camelize `react_component` prop keys #409

#### Bug Fixes

- Fix chained `.es6` file names with JSX processor #411
- Don't insert `// =require`s multiple times #398

## 1.4.2 (November 5, 2015)

#### New Features

- Component generator `--coffee` option #387
- Support Sprockets 4 with a JSX processor #385

#### Bug Fixes

- Support custom attributes when rendering from controller #384

## 1.4.1 (October 23, 2015)

#### Bug Fixes

- Minify & optimize the production build of React.js #380

## 1.4.0 (October 22, 2015)

#### New Features

- Include React.js 0.14

## 1.3.3 (October 21, 2015)

#### Bug Fixes

- Also support React 0.14 in `unmountComponents` #372
- Use a fallback view helper in case a Rails controller wasn't used #375

## 1.3.2 (October 13, 2015)

#### New Features

- The UJS can mount and unmount components within a given DOM node #358
- Support dropped-in React 0.14 in UJS #366

## 1.3.1 (September 18, 2015)

#### Bug Fixes

- Use controller lifecycle hooks for view helper (tests don't run middlewares) #356

## 1.3.0 (September 15, 2015)

#### New Features

- Render components directly from the controller with `render component: ...` #329
- Provide a custom view helper with `config.react.view_helper_implementation` #346

#### Bug Fixes

- Allow `react-rails` configs to be set in initializers #347

## 1.2.0 (August 19, 2015)

#### New Features

- Support `--es6` option in component generator #332
- Support Sprockets 3 #322

#### Bug Fixes

- Don't bother unmounting components `onBeforeUnload` #318
- Include `React::Rails::VERSION` in the gem #335

## 1.1.0 (July 9, 2015)

#### Breaking Changes

- Changed server rendering configuration names #253

  |  Old | New  |
  | ---- | ---- |
  | `config.react.timeout` | `config.react.server_renderer_timeout` |
  | `config.react.max_renderers` | `config.react.server_renderer_pool_size` |
  | `config.react.react_js` | `config.react.server_renderer_options[:files]` |
  | `config.react.component_filenames` | `config.react.server_renderer_options[:files]` |
  | `config.react.replay_console` | `config.react.server_renderer_options[:replay_console]` |
  | (none) | `config.react.server_renderer` |

- JSX is transformed by Babel, not JSTransform #295

#### New Features

- Allow custom renderers for server rendering #253
- Server render with `renderToStaticMarkup` via `prerender: :static` #253
- Accept `config.react.jsx_transform_options = {asset_path: "path/to/JSXTransformer.js"}` #273
- Added `BabelTransformer` for transforming JSX #295
- Added `ExecJSRenderer` to server rendering tools
- Accept `config.react.jsx_transformer_class` #302

#### Deprecations

- `JSXTransformer` won't be updated

#### Bug Fixes

- Fix gem versions in tests #270
- Expire the Sprockets cache if you change React.js builds #257
- Instead of copying builds into local directires, add different React.js builds to the asset pipeline #254
- Camelize attribute names in the component generator #262
- Add `tilt` dependency #248
- Default prerender pool size to 1 #302


## 1.0.0 (April 7, 2015)

#### New Features

- Vendor versions of React.js with `config.variant`, `config.addons` and `//= require react`
- Component generator
- View helper and UJS for mounting components
- Server rendering with `prerender: true`
- Transform `.jsx` in the asset pipeline
