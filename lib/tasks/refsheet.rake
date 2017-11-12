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
  task :deploy do
    build = %x{ git log -n 1 --pretty=format:"%H" }

    puts "Writing version #{build} out..."
    File.write Rails.root.join('VERSION'), build

    puts %x{ git commit -m "[ci-skip] Deploying build #{build}." -- VERSION }

    puts "Deploying version #{build} to Beanstalks..."
    puts %x{ eb deploy refsheet-staging }

    puts "Done."
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
