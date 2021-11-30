# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Destroying users and centers..'
Center.destroy_all
User.destroy_all
puts 'Users and centers destroyed!'

puts 'initialize seed..'

puts 'creating user'
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '1234abcd'
  )
end

puts 'creating dive center for first 2 users'
5.times do
  Center.create!(
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    address: Faker::Address.street_address,
    phone_number: Faker::Company.australian_business_number,
    email: Faker::Internet.email,
    location: Faker::Address.city,
    user: User.first
  )
end

CATEGORY = ["Diving", "course"]
10.times do
  puts 'creating listings for the first dive center'
  Listing.create!(
    category: CATEGORY.sample,
    name: CATEGORY.sample,
    description: Faker::Lorem.paragraphs,
    price: rand(100..250),
    date: Faker::Date.forward(days: 1),
    start_time: Faker::Time.forward(days: 1, period: :morning),
    duration: rand(1..72),
    dive_count: rand(1..4),
    max_divers: rand(2..8),
    center: Center.first
  )
end

puts 'seeding completed!'
