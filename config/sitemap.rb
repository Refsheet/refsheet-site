SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/#{Rails.application.config.x.amazon[:bucket]}/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    :fog_provider           => 'AWS',
    :aws_access_key_id      => Rails.application.config.x.amazon[:access_key_id],
    :aws_secret_access_key  => Rails.application.config.x.amazon[:secret_access_key],
    :fog_directory          => Rails.application.config.x.amazon[:bucket],
    :fog_region             => Rails.application.config.x.amazon[:s3_region]
)

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.default_host = 'https://refsheet.net'
SitemapGenerator::Sitemap.create do
  add browse_path, priority: 0.6
  add login_path, priority: 0.75
  add register_path, priority: 0.75

  User.find_each do |user|
    add "/#{user.username.downcase}", lastmod: user.updated_at
  end

  Character.sfw.visible.find_each do |character|
    add "/#{character.user.username.downcase}/#{character.slug.downcase}", lastmod: character.updated_at
  end

  Image.sfw.visible.find_each do |image|
    add image_path(image), images: [{ loc: image.image.url(:medium), title: image.caption }]
  end
end

SitemapGenerator::Sitemap.ping_search_engines('https://refsheet.net/sitemap')
