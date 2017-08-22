FactoryGirl.define do
  factory :forum_thread, class: 'Forum::Thread' do
    forum_id 1
    user_id 1
    character_id 1
    topic "MyString"
    slug "MyString"
    shortcode "MyString"
    content "MyText"
    locked false
    karma_total 1
  end
end
