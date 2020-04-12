const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  test: /\.(css|sass|scss)$/i,
  loader: ExtractTextPlugin.extract({
    use: [
      'css-loader',
      {
        loader: 'sass-loader',
        options: {
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