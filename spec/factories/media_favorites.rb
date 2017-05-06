FactoryGirl.define do
  factory :media_favorite, class: 'Media::Favorite' do
    association :media, factory: :image
    user
  end
end
