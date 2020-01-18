require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  description = <<-MARKDOWN
The Refsheet.net API allows another application to view and manipulate data on behalf of a user. To get started,
[generate an API Key from your account settings](https://refsheet.net/account/settings/api).

## Authentication

The API requires two values, `api_key_id` and `api_key_secret` to be sent either as query parameters or via headers.

|Field|URL Param|Header|
|---|---|---|
|API Key ID|`api_key_id`|`X-ApiKeyId`|
|API Key Secret|`api_key_secret`|`X-ApiKeySecret`|


```
curl -H "X-ApiKeyId: YOUR_KEY_ID" \\
     -H "X-ApiKeySecret: YOUR_KEY_SECRET" \\
     https://refsheet.net/api/v1/users/abc123
```
  MARKDOWN

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Refsheet.net API',
        description: description,
        version: 'v1'
      },
      host: (Rails.env.production? ? 'https://refsheet.net' : 'http://dev1.refsheet.net'),
      basePath: '/api/v1',
      paths: {},
      securityDefinitions: {
          apiKeyId: {
              type: :apiKey,
              name: 'X-ApiKeyId',
              in: :header
          },
          apiKeySecret: {
              type: :apiKey,
              name: 'X-ApiKeySecret',
              in: :header
          }
      },
      security: [
          apiKeyId: [],
          apiKeySecret: []
      ],
      schemes: [
          'https'
      ],
      consumes: [
          'application/json'
      ],
      produces: [
          'application/json'
      ]
    }
  }

  config.define_derived_metadata(file_path: %r{spec/integration/api/}) do |metadata|
    metadata[:swagger] = true
  end

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json

  config.after(:each, :swagger) do |example|
    if response&.body.present?
      example.metadata[:response][:examples] = { response.content_type => JSON.parse(response.body, symbolize_names: true) }
    end
  end
end
