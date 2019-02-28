# == Schema Information
#
# Table name: characters_profile_widgets
#
#  id                 :integer          not null, primary key
#  guid               :string
#  character_id       :integer
#  profile_section_id :integer
#  column             :integer
#  row_order          :integer
#  widget_type        :string
#  title              :string
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_characters_profile_widgets_on_character_id        (character_id)
#  index_characters_profile_widgets_on_guid                (guid)
#  index_characters_profile_widgets_on_profile_section_id  (profile_section_id)
#  index_characters_profile_widgets_on_row_order           (row_order)
#

FactoryBot.define do
  factory :characters_profile_widget, class: 'Characters::ProfileWidget' do
    guid { "MyString" }
    character { nil }
    profile_section { nil }
    column { 1 }
    row_order { 1 }
    widget_type { "MyString" }
    title { "MyString" }
    data { "MyText" }
  end
end
