const environment = require('./environment')

// webpack-5
environment.plugins.delete('OptimizeCSSAssets')

const config = environment.toWebpackConfig()

config.devtool = 'none'

module.exports = config
