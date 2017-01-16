# == Schema Information
#
# Table name: color_schemes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  color_data :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ColorScheme, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
