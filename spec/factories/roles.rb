# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#

FactoryBot.define do
  factory :role do
    name { 'admin' }
  end
end
