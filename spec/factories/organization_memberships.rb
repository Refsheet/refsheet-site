FactoryGirl.define do
  factory :organization_membership, class: 'Organization::Membership' do
    user_id 1
    organization_id 1
    admin false
  end
end
