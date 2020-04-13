const environment = require('./environment')

const config = environment.toWebpackConfig()

config.merge({
  devServer: {
    stats: {
      errors: true,
      errorDetails: true,
      colors: true,
      optimizationBailout: true
    }
  }
})

config.devtool = 'inline-source-map'
module.exports = config
