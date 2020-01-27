// In a file called .eslintrc.js
module.exports = {
  parser: "babel-eslint",
  rules: {
    "graphql/template-strings": ['error', {
      // Import default settings for your GraphQL client. Supported values:
      // 'apollo', 'relay', 'lokka', 'fraql', 'literal'
      env: 'literal',
      tagName: 'gql',
      validators: 'all',
    }]
  },
  plugins: [
    'graphql'
  ]
}