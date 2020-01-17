require 'swagger_helper'

describe 'V1 Users API' do
  let(:api_user) { create(:user) }
  let(:api_key) { ApiKey.create(user: api_user) }
  let(:'X-ApiKeyId') { api_key.guid }
  let(:'X-ApiKeySecret') { api_key.secret }

  #path '/api/v1/users' do
    #
    #post 'Creates a blog' do
    #  tags 'Blogs'
    #  consumes 'application/json', 'application/xml'
    #  parameter name: :blog, in: :body, schema: {
    #      type: :object,
    #      properties: {
    #          title: { type: :string },
    #          content: { type: :string }
    #      },
    #      required: [ 'title', 'content' ]
    #  }
    #
    #  response '201', 'blog created' do
    #    let(:blog) { { title: 'foo', content: 'bar' } }
    #    run_test!
    #  end
    #
    #  response '422', 'invalid request' do
    #    let(:blog) { { title: 'foo' } }
    #    run_test!
    #  end
    #end
  #end

  path '/users/{id}', swagger_doc: 'v1/swagger.json' do
    get 'Retrieves a User' do
      let(:user) { create :user }

      tags 'Users'
      produces 'application/json'
      parameter name: :id,
                in: :path,
                type: :string,
                description: 'User GUID'

      response '200', 'user found' do
        #schema type: :object,
        #       properties: {
        #           id: { type: :string },
        #       },
        #       required: [ 'id' ]

        let(:id) { user.guid }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end