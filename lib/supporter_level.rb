class SupporterLevel
  APPRENTICE = 1
  SILVER = 5
  GOLD = 10

  def initialize(amount, admin)
    if admin
      @amount = 999
    else
      @amount = amount
    end
  end

  def authorize!(level)
    unless @amount >= level
      raise NotAuthorizedError, "Your account does not meet the supporter requirement for this feature."
    end
  end

  def apprentice?
    @amount >= APPRENTICE
  end

  def silver?
    @amount >= SILVER
  end

  def gold?
    @amount >= GOLD
  end

  class NotAuthorizedError < StandardError; end
end