def test_asset_path(filename)
  Rails.root.join 'spec/assets', filename
end

def asset(filename)
  File.new test_asset_path filename
end

def attach_asset(field, filename)
  attach_file field, test_asset_path(filename), visible: false
end
