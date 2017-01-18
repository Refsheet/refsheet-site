FactoryGirl.define do
  factory :patreon_patron, class: 'Patreon::Patron' do
    patreon_id "MyString"
    email "MyString"
    full_name "MyString"
    image_url "MyString"
    is_deleted false
    is_nuked false
    is_suspended false
    status "MyString"
    thumb_url "MyString"
    twitch "MyString"
    twitter "MyString"
    youtube "MyString"
    vanity "MyString"
    url "MyString"
    user_id 1
  end
end
