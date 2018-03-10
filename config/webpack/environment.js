const { environment } = require('@rails/webpacker')
const coffee = require('./loaders/coffee')
const erb = require('./loaders/erb')

// Export Defaults

let output = {
  library: ['Packs', 'application'],
  libraryTarget: 'var'
}

environment.config.merge({output})

// Drink Coffee

environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)

const babelLoader = environment.loaders.get('babel')
babelLoader.test = /\.(coffee|js|jsx)(\.erb)?$/

module.exports = environment
