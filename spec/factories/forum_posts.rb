FactoryGirl.define do
  factory :forum_post, class: 'Forum::Post' do
    topic_id 1
    user_id 1
    character_id 1
    guid 1
    content "MyText"
    karma_total 1
  end
end
