const environment = require('./environment')

const config = environment.toWebpackConfig()
config.devtool = 'inline-source-map'
config.compile = true
module.exports = config
