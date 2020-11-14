const environment = require('./environment')

environment.config.merge({
  devtool: null
})

environment.plugins.delete('OptimizeCSSAssets')

module.exports = environment.toWebpackConfig()
