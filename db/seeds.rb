# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def make_user(username, email=nil)
  email ||= "#{username}@example.com"
  name = username.humanize

  if User.exists? username: username
    puts "-X User exists: @#{username}"
  else
    user = User.create! username: username,
                        email: email,
                        name: name,
                        password: 'fishsticks',
                        password_confirmation: 'fishsticks'

    puts "-> User made: #{name} (@#{username}, #{email})"
    yield user
  end
end

make_user 'administrator', 'admin@example.com' do |admin|
  admin.roles << Role.new(name: 'admin')
end

make_user 'moderator', 'mod@example.com' do |mod|
  mod.roles << Role.new(name: 'mod')
end

make_user 'username', 'user@example.com' do |user|
end