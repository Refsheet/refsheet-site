FactoryBot.define do
  factory :media_artist_credit, class: 'Media::ArtistCredit' do
    media { nil }
    artist { nil }
    validated { false }
    validated_by_user { nil }
    tagged_by_user { nil }
    notes { "MyText" }
    validated_at { "2021-05-21 01:19:06" }
  end
end
