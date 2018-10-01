class SitemapUpdateJob < ApplicationJob
  def perform
    Rails.logger.info `rake -f #{Rails.root.join("Rakefile")} sitemap:refresh`
  end
end
