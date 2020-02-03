const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = {
  test: /\.(css|sass|scss)$/i,
  use: [
    MiniCssExtractPlugin.loader,
    'css-loader',
    {
      loader: 'sass-loader',
      options: {
        sassOptions: {
          sourceMap: true,
          includePaths: [
            'app/javascript/sass',
            'app/assets/stylesheets',
            'app/assets',
          ],
        },
      },
    },
  ],
}
