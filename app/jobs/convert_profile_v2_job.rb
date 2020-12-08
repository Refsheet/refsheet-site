class ConvertProfileV2Job < ApplicationJob
  def perform(character)
    Rails.logger.tagged "ConvertProfileV2Job" do
      raise "Already done!" if character.version == 2

      profile_widget = character.profile_widgets.new(
          widget_type: 'RichText',
          column: 0,
          title: nil,
          data: {
              content: character.profile,
              content_html: character.profile_html
          }
      )

      profile_section = character.profile_sections.new(
          title: "About #{character.name}",
          columns: [12],
          widgets: [
              profile_widget
          ]
      )

      likes_widget = character.profile_widgets.new(
          widget_type: 'RichText',
          column: 0,
          title: 'Likes',
          data: {
              content: character.likes,
              content_html: character.likes_html
          }
      )

      dislikes_widget = character.profile_widgets.new(
          widget_type: 'RichText',
          column: 1,
          title: 'Dislikes',
          data: {
              content: character.dislikes,
              content_html: character.dislikes_html
          }
      )

      like_dislike_section = character.profile_sections.new(
          title: nil,
          columns: [6, 6],
          widgets: [
              likes_widget,
              dislikes_widget
          ]
      )

      raise profile_section.errors.inspect unless profile_section.valid?
      raise like_dislike_section.errors.inspect unless like_dislike_section.valid?

      profile_section.save!
      like_dislike_section.save!

      character.update(version: 2)
    end
  end
end
