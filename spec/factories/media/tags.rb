FactoryBot.define do
  factory :media_tag, class: 'Media::Tag' do
    media { nil }
    character { nil }
    position_x { 1 }
    position_y { 1 }
  end
end
