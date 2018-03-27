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
#  done           :boolean
#  freshdesk_id   :string
#

class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :visit
  has_many :replies, class_name: Feedback::Reply

  attr_accessor :skip_freshdesk

  validates_presence_of :comment

  # before_save :post_to_trello
  after_create :post_to_freshdesk

  scope :active, -> { where.not done: true }
  scope :done, -> { where done: true }

  scoped_search on: [:name, :email, :comment]
  scoped_search relation: :user, on: [:name, :username, :email]

  def name
    self.user&.name || super || 'Anonymous'
  end

  def email
    self.user&.email || super
  end

  def avatar_image_url
    self.user&.avatar_url || GravatarImageTag.gravatar_url(email)
  end

  def trello_card
    Trello::Card.find self.trello_card_id if self.trello_card_id.present?
  end

  def post_to_freshdesk
    return if @skip_freshdesk
    fd = Freshdesk::Ticket.from_feedback(self)

    if fd.save
      self.update_attribute :freshdesk_id, fd.id
    end
  end
end
