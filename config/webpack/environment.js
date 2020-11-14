const { environment } = require('@rails/webpacker')
const coffee = require('./loaders/coffee')
const erb = require('./loaders/erb')
const graphql = require('./loaders/graphql')
const sass = require('./loaders/sass')
const json = require('./loaders/json')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const webpack = require('webpack')
const path = require('path')

// Export Defaults
let config = {
  output: {
    library: ['Packs', '[name]'],
    libraryTarget: 'var'
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new MiniCssExtractPlugin()
  ],

  node: false,

  resolve: {
    fallback: {
      stream: require.resolve("stream-browserify"),
      crypto: false,
      https: false,
      http: false,
      fs: false,
      path: require.resolve("path-browserify"),
    },
    alias: {
      graphql$: path.resolve(__dirname, '../../node_modules/graphql/index.js'),
    }
  },

  module: {
    rules: [
      {
        test: /\.m?js/,
        type: "javascript/auto",
        resolve: {
          fullySpecified: false
        }
      },
    ]
  }
}

environment.config.merge(config)

// Drink Coffee

environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)
environment.loaders.append('graphql', graphql)
environment.loaders.append('sass', sass)
environment.loaders.append('json', json)

const babelLoader = environment.loaders.get('babel')
babelLoader.test = /\.(coffee|m?js|jsx)(\.erb)?$/
babelLoader.exclude = [
    /node_modules\/(?!superagent|query-string|strict-uri-encode)/
]

module.exports = environment
