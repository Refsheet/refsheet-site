require 'swagger_helper'

def model_schema(data)
  schema({
      type: :object,
      properties: {
          data: {
              type: :object,
              properties: {
                  id: { type: :string },
                  attributes: data
              },
              required: ['id']
          }
      },
      required: ['data']
  })
end

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
    get 'Retrieve User by ID' do
      let(:user) { create :user }

      tags 'Users'
      description <<-MARKDOWN
Finds a user by ID. The ID supplied should be the hexadecimal user GUID, not the username. To find a user by username,
use `/users/lookup/{id}`
MARKDOWN
      operationId 'find'

      parameter name: :id,
                in: :path,
                type: :string,
                description: 'User GUID'

      response '200', 'user found' do
        model_schema type: :object,
                     properties: {
                        name: { type: :string },
                        username: { type: :string },
                        avatar_url: { type: :string },
                        profile_image_url: { type: :string },
                        is_admin: { type: :boolean },
                        is_patron: { type: :boolean },
                        is_supporter: { type: :boolean },
                        is_moderator: { type: :boolean }
                     },
                     required: %w(name username avatar_url profile_image_url)

        let(:id) { user.guid }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch 'Update your User' do
      tags 'Users'
      description <<-MARKDOWN
Updates a user account. You may only update your own user account, unless the current API user has admin scope.
      MARKDOWN
      operationId 'update'

      parameter name: :id,
                in: :path,
                type: :string,
                description: 'User GUID'

      parameter name: :name,
                in: :body,
                type: :string,
                description: 'Display name'

      response '200', 'user updated' do
        model_schema type: :object,
                     properties: {
                         name: { type: :string },
                         username: { type: :string },
                         avatar_url: { type: :string },
                         profile_image_url: { type: :string },
                         is_admin: { type: :boolean },
                         is_patron: { type: :boolean },
                         is_supporter: { type: :boolean },
                         is_moderator: { type: :boolean }
                     },
                     required: %w(name username avatar_url profile_image_url)

        let(:user) { api_user }
        let(:name) { "John Doe III" }
        let(:id) { user.guid }

        run_test! do |response|
          puts response.inspect
        end
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        let(:name) { "I am bad at typing" }
        run_test!
      end

      response '401', 'not authorized' do
        let(:user) { create :user }
        let(:name) { "I have bad intentions" }
        let(:id) { user.guid }
        run_test!
      end
    end
  end

  path '/users/lookup/{username}', swagger_doc: 'v1/swagger.json' do
    get 'Retrieve User by Username' do
      let(:user) { create :user }

      tags 'Users'
      description <<-MARKDOWN
Finds a user by Username. This operation is not case sensitive. Please consider using `/users/{id}` directly if possible.
      MARKDOWN
      operationId 'lookup'

      parameter name: :username,
                in: :path,
                type: :string,
                description: 'Username of the user to find'

      response '200', 'user found' do
        model_schema type: :object,
                     properties: {
                         name: { type: :string },
                         username: { type: :string },
                         avatar_url: { type: :string },
                         profile_image_url: { type: :string },
                         is_admin: { type: :boolean },
                         is_patron: { type: :boolean },
                         is_supporter: { type: :boolean },
                         is_moderator: { type: :boolean }
                     },
                     required: %w(name username avatar_url profile_image_url)

        let(:username) { user.username }
        run_test!
      end

      response '404', 'user not found' do
        let(:username) { 'invalid' }
        run_test!
      end
    end
  end
end