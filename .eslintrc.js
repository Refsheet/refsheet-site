// In a file called .eslintrc.js
module.exports = {
  parser: "babel-eslint",
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    }
  },
  rules: {
    // ES6
    "no-unused-vars": 'warn',
    "no-undef": 'warn',
    "no-constant-condition": 'warn',
    "no-unreachable": 'warn',
    "no-prototype-builtins": 'warn',

    // React
    "react/no-deprecated": 'error',
    "react/display-name": 'warn',
    "react/jsx-no-undef": 'warn',
    "react/prop-types": 'warn',
    "react/no-unescaped-entities": 'off',

    // GraphQL
    "graphql/template-strings": ['error', {
      // Import default settings for your GraphQL client. Supported values:
      // 'apollo', 'relay', 'lokka', 'fraql', 'literal'
      env: 'literal',
      tagName: 'gql',
      validators: 'all',
    }]
  },
  settings: {
    react: {
      version: "16.12.0"
    }
  },
  plugins: [
    'graphql',
    'react'
  ],
  env: {
    browser: true,
    node: true,
    jasmine: true,
    es6: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
  ]
}