FactoryGirl.define do
  factory :patreon_reward, class: 'Patreon::Reward' do
    patreon_id "MyString"
    amount_cents 1
    description "MyText"
    image_url "MyString"
    requires_shipping false
    title "MyString"
    url "MyString"
    grants_badge false
  end
end
