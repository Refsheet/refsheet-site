const { environment } = require('@rails/webpacker')
const coffee = require('./loaders/coffee')
const erb = require('./loaders/erb')
const graphql = require('./loaders/graphql')
const sass = require('./loaders/sass')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

// Export Defaults

let output = {
  library: ['Packs', 'application'],
  libraryTarget: 'this'
}

const optimization = {
  splitChunks: {
    automaticNameDelimiter: '~',
    automaticNameMaxLength: 30,
    chunks: 'async',
    maxAsyncRequests: 6,
    maxInitialRequests: 4,
    maxSize: 0,
    minChunks: 1,
    minSize: 30000,

    cacheGroups: {
      defaultVendors: {
        test: /[\\/]node_modules[\\/]/,
        priority: -10
      },
      default: {
        minChunks: 2,
        priority: -20,
        reuseExistingChunk: true
      }
    }
  }
}

const plugins = [
  new MiniCssExtractPlugin()
]

environment.config.merge({output, optimization, plugins})

// Drink Coffee

environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)
environment.loaders.append('graphql', graphql)
environment.loaders.append('sass', sass)

const babelLoader = environment.loaders.get('babel')
babelLoader.test = /\.(coffee|js|jsx)(\.erb)?$/
babelLoader.exclude = [
    /node_modules\/(?!superagent|query-string|strict-uri-encode|react-justified-layout)/
]

module.exports = environment
