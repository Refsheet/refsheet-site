namespace :refsheet do
  namespace :image do
    desc 'Incrementally rebuild thumbnails. START=0 & BATCH_SIZE=10 & VERBOSE=false'
    task :reprocess => :environment do
      batch_size = (ENV['BATCH_SIZE'] || ENV['batch_size'] || 10).to_i
      verbose    = (ENV['VERBOSE'] || ENV['verbose'] || nil)
      start      = (ENV['START'] || ENV['start'] || 0).to_i

      total = Image.count

      while start < total
        puts "Spawning: bundle exec rake refsheet:image:reprocess_some START=#{start} BATCH_SIZE=#{batch_size} VERBOSE=#{verbose} RAILS_ENV=#{Rails.env}"
        puts %x{bundle exec rake refsheet:image:reprocess_some START=#{start} BATCH_SIZE=#{batch_size} VERBOSE=#{verbose} RAILS_ENV=#{Rails.env} }
        start = start + batch_size.to_i
      end
    end

    desc 'Reprocess a batch of thumbnails. START=0 & BATCH_SIZE=10 & VERBOSE=false'
    task :reprocess_some => :environment do
      start      = (ENV['START'] || ENV['start'] || 0)
      batch_size = (ENV['BATCH_SIZE'] || ENV['batch_size'] || 10)
      verbose    = (ENV['VERBOSE'] || ENV['verbose'] || nil)

      puts "start = #{start} & batch_size = #{batch_size}" if verbose
      puts "RAILS_ENV=#{Rails.env}" if verbose

      images = Image.order("id ASC").offset(start).limit(batch_size).all
      images.each do |image|
        puts "Re-processing paperclip image on image ID: #{image.id}" if verbose
        STDOUT.flush
        image.image.reprocess!
      end
    end
  end

  desc 'Standard deploy process, needed because Rollbar and GH don\'t play along.'
  task :deploy, [:env] do |_, args|
    envs = args.fetch(:env) { 'refsheet-staging' }.split('+')
    envs = ['refsheet-prod', 'refsheet-prod-worker'] if envs[0] == ':prod'

    puts "Deploying to #{envs}"
    (build, changelog) = get_version

    begin
      puts "Writing changelog..."
      n = Rails.root.join('tmp/CHANGELOG')
      o = Rails.root.join('CHANGELOG')

      File.open n, 'a' do |f|
        f << changelog
        f << File.read(o)
      end

      File.rename n, o
    end

    begin
      puts "Writing version #{build} out..."
      File.write Rails.root.join('VERSION'), build
    end

    message = Shellwords.escape %x{ git log -1 --oneline }

    puts %x{ git commit -m "[ci-skip] #{build}" -- VERSION CHANGELOG }
    puts %x{ git tag #{build} }
    puts %x{ git push --tags }

    puts "Deploying version #{build} to Beanstalks..."

    envs.each do |env|
      puts %x{ eb deploy #{env} --label #{build} --message #{message} --timeout 3600 }
    end

    puts "Done."
  end

  def get_version
    version = %x{ git describe --tags --abbrev=0 }.chomp
    version_str = File.read(Rails.root.join('VERSION')).chomp.gsub(/^v/, '')
    semver = Semantic::Version.new version_str

    puts "Getting notable data since #{version.inspect} (now v#{semver.to_s})..."
    log = %x{ git log '#{version}..HEAD' --pretty=format:"%h %ad %s" --abbrev-commit --date=short }.split("\n")
    puts "Fetched #{log.count} commits."

    # Parse changelog for tags of interest

    data = log.collect do |l|
      if (m = l.match(/\A(?<hash>[a-f0-9]+)\s+(?<date>\d+-\d+-\d+)\s+(?<tags>(\[.*?\]\s*)*)(?<message>.*)\z/))
        h = m.names.zip(m.captures).to_h
        h['tags'] = h['tags']&.split(/\]\s*\[/)&.map { |s| s.gsub(/\A\s*\[|\]\s*/, '') } || []
        h.symbolize_keys
      else
        { hash: nil, tags: [], message: l }
      end
    end

    # Scan for major / minor tags

    in_minor = data.any? { |d| d[:tags].grep(/\Am(?:inor)?\z/).count > 0 }
    in_rev = data.any? { |d| d[:tags].grep(/\Af(?:eature)?\z/).count > 0 }

    # Calculate and reset pre/build

    old_build = semver.build&.gsub(/[^\d]/, '')&.to_i || 0
    old_pre = semver.pre&.gsub(/[^\d]/, '')&.to_i || 0

    # Increment accordingly

    if data.length == 0
      puts 'No commits found.'
      semver.build = "build.#{ old_build + 1}"
    elsif in_minor
      puts 'Big commit detected, adding minor revision.'
      semver = semver.minor!
    elsif in_rev
      puts 'Feature commit detected, increasing patch revision.'
      semver = semver.patch!
    else
      puts 'No tagged commits of interest, logging build.'
      semver.pre = "pre.#{ old_pre + 1 }"
      semver.build = nil
    end

    semver_str = "v#{semver.to_s}"

    changelog = { semver_str => data.collect(&:stringify_keys) }.to_yaml

    [semver_str, changelog]
  end

  desc 'This is to be finished on the server, after we\'re built.'
  task :post_deploy do
    require 'rest_client'

    build = File.read Rails.root.join 'VERSION'

    puts "Telling rollbar!"

    params = {
        access_token: '99b1752b1b864396a50f5ecef1232b7a',
        environment: 'production',
        local_username: `whoami`,
        revision: build
    }

    puts RestClient.post 'https://api.rollbar.com/api/1/deploy/', params

    appFile = Dir[Rails.root.join('public/assets/application-*.js')].first
    appFile =~ /application-(.*)\.js/

    mapParams = {
        access_token: '99b1752b1b864396a50f5ecef1232b7a',
        version: build,
        minified_url: 'https://refsheet.net/assets/application-' + $1 + '.js',
        source_map: (File.new(Dir[Rails.root.join('public/assets/maps/application-*.js.map')].first) rescue nil)
    }

    Dir[Rails.root.join('public/assets/sources/application-*.js')].each do |source|
      basename = source.gsub(/\A.*\/public/, '')
      mapParams[basename] = File.new source
    end

    begin
      puts RestClient.post 'https://api.rollbar.com/api/1/sourcemap', mapParams
    rescue RestClient::UnprocessableEntity => e
      puts e.response.body
    end
  end

  desc 'Refreshes image meta on images without the field present.'
  task :backfill_image_meta => :environment do
    HttpLog.configure do |config|
      config.enabled = false
    end

    Rails.logger.silence do
      scope = Image.where(image_meta: nil)
      count = scope.count

      puts "Reprocessing #{count} images..."
      progress = ProgressBar.create total: count,
                                    format: '%c/%C [%w>:|%i] %E'

      scope.find_each do |image|
        image.recalculate_attachment_meta!
        progress.increment
      end

      progress.stop
      puts "DONE"
    end
  end

  desc 'Clears image meta on all images.'
  task :clear_image_meta => :environment do
    Image.update_all image_meta: nil
  end
end
