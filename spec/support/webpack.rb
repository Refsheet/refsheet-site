RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{spec/(features|requests)/}) do |metadata|
    metadata[:webpack] = true
  end

  config.when_first_matching_example_defined(:webpack, :js) do
    puts "Contemplating Webpack compilation..."
    puts `pwd`
    puts `ls`
    puts `bin/webpack`
  end
end