// Karma configuration
// Generated on Fri Mar 23 2018 02:04:11 GMT-0500 (CDT)

const webpackConfig = require('./config/webpack/test.js');

webpackConfig.externals = {
  cheerio: 'window',
  'react/addons': 'react',
  'react/lib/ExecutionEnvironment': 'react',
  'react/lib/ReactContext': 'react',
  'react-addons-test-utils': 'react-dom'
}

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['mocha'],

    files: [
      'spec/javascript/specHelper.js'
    ],

    exclude: [
    ],

    preprocessors: {
      'spec/javascript/specHelper.js': ['webpack', 'sourcemap']
    },

    client: {
      mocha: {
        ui: 'bdd-lazy-var/global',
        require: [require.resolve('bdd-lazy-var/global')]
      }
    },

    reporters: ['progress', 'mocha', 'junit'],
    port: 9876,
    colors: true,

    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: false,
    concurrency: Infinity,

    junitReporter: {
      outputDir: process.env.JUNIT_REPORT_PATH,
      outputFile: process.env.JUNIT_REPORT_NAME,
      userBrowserName: false
    },

    webpackMiddleware: {
      stats: 'errors-only'
    },

    webpack: webpackConfig
  })
}
