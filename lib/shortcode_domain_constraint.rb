class ShortcodeDomainConstraint
  def self.matches?(request)
    # TODO Read this from configuration perhaps.
    request.domain.downcase == 'ref.st'
  end
end
