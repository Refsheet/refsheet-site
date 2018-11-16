# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists? username: 'admin'
  admin = User.create!(
      name: "Admin Mc Adminpants",
      email: 'admin@example.com',
      username: 'administrator',
      password: 'fishsticks',
      password_confirmation: 'fishsticks'
  )

  admin.roles << Role.new(name: 'admin')
end