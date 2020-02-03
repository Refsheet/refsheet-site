module.exports = {
  test: /\.coffee(\.erb)?$/,
  use: [
    {
      loader: 'babel-loader',
    },
    {
      loader: 'coffee-loader',
    },
  ],
}
