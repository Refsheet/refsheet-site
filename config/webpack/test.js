const environment = require('./environment')

const config = environment.toWebpackConfig()
config.devtool = 'inline-source-map'
module.exports = config
