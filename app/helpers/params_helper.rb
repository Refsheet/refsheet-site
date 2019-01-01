module ParamsHelper
  def bool(string)
    return if string.nil?
    %w(true 1 yes on t).include?(string.to_s.downcase)
  end
end