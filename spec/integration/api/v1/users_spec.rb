require 'swagger_helper'

describe 'V1 Users API' do
  let(:api_user) { create(:user) }
  let(:api_key) { ApiKey.create(user: api_user) }
  let(:'X-ApiKeyId') { api_key.guid }
  let(:'X-ApiKeySecret') { api_key.secret }

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
        schema type: :object,
               properties: {
                  name: { type: :string },
                  username: { type: :string },
                  profile: { type: :string },
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

On successful update, this will return `HTTP 204: No Content`.
      MARKDOWN
      operationId 'update'

      parameter name: :id,
                in: :path,
                type: :string,
                description: 'User GUID'

      parameter name: :user, in: :body,
                schema: {
                    type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                name: { type: :string },
                                username: { type: :string },
                                email: { type: :string },
                                profile: { type: :string },
                            }
                        }
                    }
                }


      let(:id) { api_user.guid }

      let(:user) {{
          name: "John Doe III",
          email: "j.doe3@example.com",
          username: 'jdoe3',
          profile: "I really like Fortnite."
      }}

      response '204', 'user updated' do
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '401', 'not authorized' do
        let(:target_user) { create :user }
        let(:id) { target_user.guid }
        run_test!
      end

      response '400', 'bad request body' do
        let(:user) { "This is a strange object, isn't it?" }
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
        schema type: :object,
               properties: {
                   name: { type: :string },
                   username: { type: :string },
                   profile: { type: :string },
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