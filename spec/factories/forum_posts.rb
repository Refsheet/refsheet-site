# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :integer
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

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
