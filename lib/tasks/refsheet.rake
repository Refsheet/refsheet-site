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
    env = args.fetch(:env) { 'refsheet-staging' }

    puts "Deploying to #{env}"
    build = get_version

    puts "Writing version #{build} out..."
    File.write Rails.root.join('VERSION'), build
    message = Shellwords.escape %x{ git log -1 --oneline }

    puts %x{ git commit -m "[ci-skip] #{build}" -- VERSION CHANGELOG }
    puts %x{ git tag #{build} }

    puts "Deploying version #{build} to Beanstalks..."
    puts %x{ eb deploy #{env} --label #{build} --message #{message} }

    puts "Done."
  end

  def get_version
    version = %x{ git describe --tags --abbrev=0 }.chomp
    semver = File.read(Rails.root.join('VERSION')).chomp

    if semver =~ /\Av?(\d+(?:.\d+){0,2}(?:-\d+(?:\.\d+)?)?)\z/
      s, p = $1.split('-')
      semver = s.split('.').collect(&:to_i)
      semver.fill 0, semver.length-1, 3-semver.length
      semver.push p&.to_f
    else
      semver = [0, 0, 0, nil]
    end

    puts "Getting notable data since #{version.inspect} (#{semver.inspect})..."

    log = %x{ git log '#{version}..HEAD' --pretty=oneline --abbrev-commit }.split("\n")

    puts "Fetched #{log.count} commits."

    data = log.collect do |l|
      if (m = l.match(/\A(?<hash>[a-z0-9]+)\s+(?<tags>(\[.*?\]\s*)*)(?<message>.*)\z/))
        h = m.names.zip(m.captures).to_h
        h['tags'] = h['tags']&.split(/\]\s*\[/)&.map { |s| s.gsub(/\A\s*\[|\]\s*/, '') } || []
        h.symbolize_keys
      else
        { hash: nil, tags: [], message: l }
      end
    end

    in_minor = data.any? { |d| d[:tags].grep(/\Af(?:eature)?\z/).count > 0 }
    in_rev = data.any? { |d| d[:tags].grep(/\Ab(?:ug)?\z/).count > 0 }

    if data.length == 0
      puts 'No commits found.'
      semver[3] ||= 0
      semver[3] += 0.001
    elsif in_minor
      puts 'Feature commit detected, adding minor revision.'
      semver[1] += 1
      semver[2] = 0
      semver[3] = nil
    elsif in_rev
      puts 'Bug commit detected, increasing minor revision.'
      semver[2] += 1
      semver[3] = nil
    else
      puts 'No tagged commits of interest, logging build.'
      semver[3] ||= 0
      semver[3] += 1
    end

    semver_str = if semver[3].nil?
      'v%d.%d.%d' % semver
    else
      'v%d.%d.%d-%0.3f' % semver
    end

    changelog = { semver_str => data.collect(&:stringify_keys) }.to_yaml

    n = Rails.root.join('tmp/CHANGELOG')
    o = Rails.root.join('CHANGELOG')

    File.open n, 'a' do |n|
      n << changelog
      n << File.read(o)
    end

    File.rename n, o

    semver_str
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
end
