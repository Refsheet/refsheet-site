const globImporter = require('node-sass-glob-importer');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  test: /\.(css|sass|scss)$/i,
  use: [
    MiniCssExtractPlugin.loader,
    "css-loader",
    {
      loader: 'sass-loader',
      options: {
        sourceMap: false,
        sassOptions: {
          allChunks: true,
          importer: globImporter(),
          includePaths: [
            'app/javascript/sass',
            'app/assets/stylesheets',
            'app/assets'
          ],
          outputStyle: 'compressed'
        }
      }
    },
  ]
}
