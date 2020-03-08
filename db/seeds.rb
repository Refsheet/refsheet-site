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

#== Forums

Forum.create(name: 'Support', slug: 'support', description: 'For technical and account support.') unless Forum.exists? slug: 'support'
Forum.create(name: 'Site Feedback', slug: 'feedback', description: 'Feature requests and site feedback.') unless Forum.exists? slug: 'feedback'
Forum.create(name: 'Swaps', slug: 'swaps', description: 'Trade art + characters!') unless Forum.exists? slug: 'swaps'
Forum.create(name: 'Roleplay', slug: 'rp', description: 'OwO *notices ur forum*') unless Forum.exists? slug: 'rp'

1000.times do
  Forum::Discussion.create!(forum: Forum.random, user: User.random, topic: Faker::Books::Lovecraft.tome, content: Faker::Books::Lovecraft.paragraph)
end

3000.times do
  Forum::Post.create!(discussion: Forum::Discussion.random, user: User.random, content: Faker::Books::Lovecraft.paragraph)
end