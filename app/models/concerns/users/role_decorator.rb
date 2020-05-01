module Users::RoleDecorator
  extend ActiveSupport::Concern

  included do
    attr_accessor :no_cache
    scope :patrons, -> { joins(:patreon_patron).order('patreon_patrons.created_at DESC').where.not patreon_patrons: { id: nil } }
    scope :with_role, -> (r) { joins(:roles).where(roles: { name: [r, Role::ADMIN] }) }
  end

  # The only safe way to query the database for a given role. Danger of N+1, for
  # syntax only, use the helper methods.
  #
  # @param [String] role
  def role?(role)
    self.roles.exists?(name: role.to_s)
  end

  def admin?
    cache_value 'admin' do
      role? Role::ADMIN
    end
  end

  def patron?
    cache_value 'patron' do
      self.admin? || self.pledges.active.any?
    end
  end

  def supporter?
    cache_value 'supporter' do
      self.support_pledge_amount > 0
    end
  end

  def moderator?
    cache_value 'moderator' do
      role? Role::MODERATOR
    end
  end

  def supporter_level
    SupporterLevel.new(self.support_pledge_amount, admin?)
  end

  private

  def cache_value(column)
    val = self.attributes[column]
    if val.nil? || @no_cache
      val = yield
      self.update_columns(column => val)
    end
    val
  end
end