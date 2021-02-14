class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Attributes

  def show_private?
    update?
  end

  def update_private?
    show_private?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  private

  def hidden?
    record.respond_to?(:character) && record.character.hidden or record.hidden
  end

  def blocked?
    target_user = record.respond_to?(:user) ? record.user : record
    user && user.blocked_by?(target_user)
  end

  def admin?
    user&.admin?
  end
end
