RSpec.configure do |config|
  unless ENV['SWAGGER_HACK']
    config.define_derived_metadata(file_path: %r{spec/(features|requests)/}) do |metadata|
      metadata[:webpack] = true
    end

    config.when_first_matching_example_defined(:webpack, :js) do
      puts "Contemplating Webpack compilation..."
      puts `#{Rails.root.join('bin', 'webpack')}`
    end
  end
end