const { environment } = require('@rails/webpacker')
const coffee = require('./loaders/coffee')
const erb = require('./loaders/erb')
const graphql = require('./loaders/graphql')
const sass = require('./loaders/sass')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

// Export Defaults

let output = {
  library: ['Packs', 'application'],
  libraryTarget: 'var'
}

let plugins = [
  new MiniCssExtractPlugin()
]

environment.config.merge({plugins, output})

// Drink Coffee

environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)
environment.loaders.append('graphql', graphql)
environment.loaders.append('sass', sass)

const babelLoader = environment.loaders.get('babel')
babelLoader.test = /\.(coffee|js|jsx)(\.erb)?$/
babelLoader.exclude = [
    /node_modules\/(?!superagent|query-string|strict-uri-encode)/
]

module.exports = environment
