const globImporter = require('node-sass-glob-importer');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  test: /\.(css|sass|scss)$/i,
  loader: ExtractTextPlugin.extract({
    use: [
      'css-loader',
      {
        loader: 'sass-loader',
        options: {
          importer: globImporter(),
          sourceMap: false,
          allChunks: true,
          includePaths: [
            'app/javascript/sass',
            'app/assets/stylesheets',
            'app/assets'
          ]
        }
      },
    ],
    allChunks: true,
    fallback: 'style-loader'
  })
}