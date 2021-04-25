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
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def delete?
    destroy?
  end

  def moderate?
    admin?
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

  def find_user
    if record.is_a? User
      record
    elsif record.respond_to?(:user)
      record.user
    elsif record.respond_to?(:recipient)
      record.recipient
    end
  end

  def hidden?
    record.respond_to?(:character) && record.character.hidden or record.hidden
  end

  def blocked?
    user && user.blocked_by?(find_user)
  end

  def blocks?
    user && user.blocked?(find_user)
  end

  def admin?
    user&.admin?
  end

  def logged_in?
    !!user
  end
end
