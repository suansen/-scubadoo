# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Destroying users and centers"
User.destroy_all
Center.destroy_all

puts "initialize seed"

10.times do
  puts "creating user"
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '1234abcd'
  )
  puts user.first_name
end

5.times do
  puts "creating dive center for first 2 users"
  center = Center.create!(
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    address: Faker::Address.street_address,
    phone_number: Faker::Company.australian_business_number,
    email: Faker::Internet.email ,
    location: Faker::Address.city,
    user: User.first
  )
end
