class Organization < User
  has_many :memberships
  has_many :admin_memberships, -> { admin }, class_name: Membership
  has_many :users, through: :memberships
  has_many :admins, through: :admin_memberships, class_name: User

  belongs_to :owner, class_name: User, foreign_key: :parent_user_id

  validates_presence_of :owner
end
