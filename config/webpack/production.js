const environment = require('./environment')

environment.config.merge({
  devtool: 'cheap-module-source-map'
})

// webpack-5
// environment.plugins.delete('OptimizeCSSAssets')

module.exports = environment.toWebpackConfig()
