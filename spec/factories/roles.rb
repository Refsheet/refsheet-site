# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#
# Indexes
#
#  index_roles_on_name  (name)
#

FactoryBot.define do
  factory :role do
    name { 'admin' }
  end
end
