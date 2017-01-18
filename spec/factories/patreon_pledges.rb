FactoryGirl.define do
  factory :patreon_pledge, class: 'Patreon::Pledge' do
    patreon_id "MyString"
    amount_cents 1
    declined_since "2017-01-18 17:14:27"
    patron_pays_fees false
    pledge_cap_cents 1
  end
end
