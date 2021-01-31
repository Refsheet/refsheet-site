const environment = require('./environment')
const SentryWebpackPlugin = require('@sentry/webpack-plugin')

environment.config.merge({
  devtool: 'cheap-module-source-map'
})

console.log("Version: " + process.env.VERSION);

environment.plugins.append('sentry-webpack', new SentryWebpackPlugin({
  // sentry-cli configuration
  authToken: process.env.SENTRY_RELEASE_TOKEN,
  org: "refsheetnet",
  project: "refex",
  release: process.env.VERSION,

  // webpack specific configuration
  include: ".",
  ignore: ["node_modules", "webpack.config.js"],
}))

// webpack-5
environment.plugins.delete('OptimizeCSSAssets')

module.exports = environment.toWebpackConfig()
