FactoryGirl.define do
  factory :forum_karma, class: 'Forum::Karma' do
    karmic_id 1
    karmic_type 1
    user_id 1
    discord false
  end
end
