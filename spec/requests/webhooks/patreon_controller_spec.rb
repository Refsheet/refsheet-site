require 'rails_helper'

describe Webhooks::PatreonController, type: :request do
  let(:headers) {{
      'X-Patreon-Event' => 'test',
      'X-Patreon-Signature' => 'not-a-signature'
  }}

  let(:payload) { JSON.parse(<<-JSON) }
    {
      "data": {
        "attributes": {
          "amount_cents": 150,
          "created_at": null,
          "declined_since": null,
          "is_twitch_pledge": false,
          "patron_pays_fees": false,
          "pledge_cap_cents": null
        },
        "id": null,
        "relationships": {
          "address": {
            "data": null
          },
          "creator": {
            "data": {
              "id": "4704297",
              "type": "user"
            },
            "links": {
              "related": "https:\/\/api.patreon.com\/user\/4704297"
            }
          },
          "patron": {
            "data": {
              "id": "32187",
              "type": "user"
            },
            "links": {
              "related": "https:\/\/api.patreon.com\/user\/32187"
            }
          },
          "reward": {
            "data": {
              "id": "1299443",
              "type": "reward"
            },
            "links": {
              "related": "https:\/\/api.patreon.com\/rewards\/1299443"
            }
          }
        },
        "type": "pledge"
      },
      "included": [
        {
          "attributes": {
            "amount": 100,
            "amount_cents": 100,
            "created_at": "2017-01-18T18:07:58.792947+00:00",
            "deleted_at": null,
            "description": "<ul><li>Your name on the credits page of Refsheet.net!<\/li><li>My undying love and gratitude<\/li><\/ul>",
            "discord_role_ids": null,
            "edited_at": "2017-01-18T18:19:48.597614+00:00",
            "image_url": null,
            "is_twitch_reward": false,
            "patron_count": 0,
            "post_count": null,
            "published": true,
            "published_at": "2017-01-18T18:07:58.792947+00:00",
            "remaining": null,
            "requires_shipping": false,
            "title": "Tip Jar",
            "unpublished_at": null,
            "url": "\/bePatron?u=4704297&rid=1299443",
            "user_limit": null
          },
          "id": "1299443",
          "relationships": {
            "campaign": {
              "data": {
                "id": "668105",
                "type": "campaign"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/campaigns\/668105"
              }
            },
            "creator": {
              "data": {
                "id": "4704297",
                "type": "user"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/user\/4704297"
              }
            }
          },
          "type": "reward"
        },
        {
          "attributes": {
            "about": "Hey there",
            "created": "2013-05-10T13:27:42+00:00",
            "facebook": "https:\/\/www.facebook.com\/foo",
            "first_name": "Corgi",
            "full_name": "Corgi Pager & Friends & Fans",
            "gender": 0,
            "image_url": "\/\/s3-us-west-1.amazonaws.com\/patreon.user\/QIsuvl8VXy6o0SG6Ha2LhXvFFk6vbUUvlOyVBRL28FAQLzLOTFQIyOnkk9QTqVFo_large_2.jpeg",
            "last_name": "Pager & Friends & Fans",
            "status": 1,
            "thumb_url": "\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb_large_3.jpeg",
            "thumbnails": {
              "thumb": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb.jpeg",
              "thumb_2": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb_2.jpeg",
              "thumb_large": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb_large.jpeg",
              "thumb_large_2": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb_large_2.jpeg",
              "thumb_large_3": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/5DyTi2VqwWl9n0thXTrh4ZFkCLGw9AmySVP3tc8e0ZQq0hO3WV2QYpShwLYM1wdo_thumb_large_3.jpeg"
            },
            "twitch": "https:\/\/www.twitch.tv\/foo",
            "twitter": "",
            "url": "https:\/\/www.patreon.com\/corgi",
            "vanity": "corgi",
            "youtube": ""
          },
          "id": "32187",
          "relationships": {
            "campaign": {
              "data": {
                "id": "70261",
                "type": "campaign"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/campaigns\/70261"
              }
            }
          },
          "type": "user"
        },
        {
          "attributes": {
            "about": null,
            "created": "2016-12-26T23:11:10+00:00",
            "discord_id": null,
            "email": "weisert@eisertdev.com",
            "facebook": null,
            "facebook_id": null,
            "first_name": "Mau",
            "full_name": "Mau",
            "gender": 0,
            "has_password": "[FILTERED]",
            "image_url": "\/\/s3-us-west-1.amazonaws.com\/patreon.user\/J5kJcrM6IOOOJPO5h8kOY8vGegjpYjTlojAagspKyzVEZjQHr9N7nfhzh3c3QPJQ_large_2.jpeg",
            "is_deleted": false,
            "is_nuked": false,
            "is_suspended": false,
            "last_name": "",
            "social_connections": {
              "deviantart": null,
              "discord": null,
              "facebook": null,
              "spotify": null,
              "twitch": null,
              "twitter": null,
              "youtube": null
            },
            "status": 0,
            "thumb_url": "\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb_large_3.jpeg",
            "thumbnails": {
              "thumb": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb.jpeg",
              "thumb_2": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb_2.jpeg",
              "thumb_large": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb_large.jpeg",
              "thumb_large_2": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb_large_2.jpeg",
              "thumb_large_3": "https:\/\/s3-us-west-1.amazonaws.com\/patreon.user\/HnXr8HbuDI3hSKmQyhPAg9gABl714anMSzYnSMYlLQsp2HIlQWFnqxm6AWJutTxR_thumb_large_3.jpeg"
            },
            "twitch": null,
            "twitter": "Refsheet",
            "url": "https:\/\/www.patreon.com\/refsheet",
            "vanity": "refsheet",
            "youtube": null
          },
          "id": "4704297",
          "relationships": {
            "campaign": {
              "data": {
                "id": "668105",
                "type": "campaign"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/campaigns\/668105"
              }
            }
          },
          "type": "user"
        },
        {
          "attributes": {
            "amount": 500,
            "amount_cents": 500,
            "created_at": "2017-01-18T18:09:38.696767+00:00",
            "deleted_at": null,
            "description": "<ul><li>You get a shiny profile badge!<\/li><li>I'll post new things here for you to review before I ship it<\/li><li>And all the Tip Jar rewards<\/li><\/ul>",
            "discord_role_ids": null,
            "edited_at": "2017-01-18T18:19:48.615329+00:00",
            "image_url": null,
            "is_twitch_reward": false,
            "patron_count": 1,
            "post_count": null,
            "published": true,
            "published_at": "2017-01-18T18:09:38.696767+00:00",
            "remaining": null,
            "requires_shipping": false,
            "title": "I'm Helping!",
            "unpublished_at": null,
            "url": "\/bePatron?u=4704297&rid=1299450",
            "user_limit": null
          },
          "id": "1299450",
          "relationships": {
            "campaign": {
              "data": {
                "id": "668105",
                "type": "campaign"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/campaigns\/668105"
              }
            },
            "creator": {
              "data": {
                "id": "4704297",
                "type": "user"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/user\/4704297"
              }
            }
          },
          "type": "reward"
        },
        {
          "attributes": {
            "amount": 1000,
            "amount_cents": 1000,
            "created_at": "2017-01-18T18:15:29.851506+00:00",
            "deleted_at": null,
            "description": "<ul><li>If I make some sort of paid account feature, you get it free<\/li><li>You can very easily convince me to work on features you choose to be important<\/li><li>Plus a shiny profile badge and Tip Jar rewards<\/li><\/ul>",
            "discord_role_ids": null,
            "edited_at": "2017-01-18T18:19:48.631978+00:00",
            "image_url": null,
            "is_twitch_reward": false,
            "patron_count": 0,
            "post_count": null,
            "published": true,
            "published_at": "2017-01-18T18:15:29.851506+00:00",
            "remaining": null,
            "requires_shipping": false,
            "title": "Gawsh Heck, Thanks!",
            "unpublished_at": null,
            "url": "\/bePatron?u=4704297&rid=1299468",
            "user_limit": null
          },
          "id": "1299468",
          "relationships": {
            "campaign": {
              "data": {
                "id": "668105",
                "type": "campaign"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/campaigns\/668105"
              }
            },
            "creator": {
              "data": {
                "id": "4704297",
                "type": "user"
              },
              "links": {
                "related": "https:\/\/api.patreon.com\/user\/4704297"
              }
            }
          },
          "type": "reward"
        }
      ],
      "links": {
        "self": "https:\/\/api.patreon.com\/pledges\/None"
      }
    }
  JSON

  describe '#create' do
    it 'handles patron:create' do
      post '/webhooks/patreon', params: payload, headers: headers
      expect(response).to have_http_status :ok

      expect(Patreon::Pledge.count).to eq 1
      expect(Patreon::Reward.count).to eq 1
      expect(Patreon::Patron.count).to eq 1
    end
  end
end
