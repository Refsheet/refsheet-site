# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string
#  email          :string
#  comment        :text
#  trello_card_id :string
#  source_url     :string
#  visit_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :visit

  validates_presence_of :comment

  before_save :post_to_trello

  def name
    self.user&.name || super || 'Anonymous'
  end

  def email
    self.user&.email || super
  end

  def trello_card
    Trello::Card.find self.trello_card_id if self.trello_card_id.present?
  end

  def done?
    false
  end

  private

  def post_to_trello
    Rails.logger.tagged 'TRELLO' do
      card = self.trello_card || Trello::Card.new
      card.update_fields trello_params
      card.save

      self.trello_card_id = card.id
      Rails.logger.info "Created card #{card.id}"
    end
  rescue Trello::Error => e
    Rails.logger.tagged 'TRELLO' do
      Rails.logger.error "Could not save Trello card for Feedback(#{self.id}): #{e.message}"
    end
  end

  def trello_params
    {
        list_id: Rails.configuration.x.trello['influx_list_id'],
        name: "Feedback from #{self.name}",
        desc: self.comment
    }
  end
end
