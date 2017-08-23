# == Schema Information
#
# Table name: forum_threads
#
#  id           :integer          not null, primary key
#  forum_id     :integer
#  user_id      :integer
#  character_id :integer
#  topic        :string
#  slug         :string
#  shortcode    :string
#  content      :text
#  locked       :boolean
#  karma_total  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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
