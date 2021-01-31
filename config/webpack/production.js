const environment = require('./environment')
const SentryWebpackPlugin = require('@sentry/webpack-plugin')

environment.config.merge({
  devtool: 'cheap-module-source-map'
})

environment.plugins.append('sentry-webpack', new SentryWebpackPlugin({
  // sentry-cli configuration
  authToken: process.env.SENTRY_API_TOKEN,
  org: "refsheetnet",
  project: "refex",

  // webpack specific configuration
  include: ".",
  ignore: ["node_modules", "webpack.config.js"],
}))

// webpack-5
environment.plugins.delete('OptimizeCSSAssets')

module.exports = environment.toWebpackConfig()
