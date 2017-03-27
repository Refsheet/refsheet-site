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
end