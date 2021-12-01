# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "open-uri"

puts 'Destroying everything... 💣'
User.destroy_all
puts 'Users destroyed!'

puts 'initialize seed... 🌱'

puts "Creating standard user for testing 👩‍🦱"
User.create!(
    first_name: "Geetha",
    last_name: "Bheema",
    email: "geebee@gmail.com",
    password: "password"
  )
puts "Standard user Geetha created! ✅"

puts "Creating faker users ⏭"
10.times do
  puts 'creating user'
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '1234abcd'
  )
  puts "#{user.first_name} account created!"
end
puts "Faker users done! 🕵️‍♀️"

puts 'creating dive centers for first user'
5.times do
  Center.create!(
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    address: Faker::Address.street_address,
    phone_number: Faker::Company.australian_business_number,
    email: Faker::Internet.email,
    location: Faker::Address.country,
    user: User.first
  )
end

CATEGORY = ["trip", "course"]
puts 'creating listings for the first dive center'
10.times do
  file = URI.open('https://source.unsplash.com/1920x1080/?scuba')
  listing = Listing.create!(
    category: CATEGORY.sample,
    name: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    price: rand(100..250),
    date: Faker::Date.forward(days: 1),
    start_time: Faker::Time.forward(days: 1, period: :morning, format: :short),
    duration: rand(1..72),
    dive_count: rand(1..4),
    max_divers: rand(2..8),
    center: Center.first
  )
  puts "Now gonna try attaching the photo 📷"
  listing.photo.attach(io: file, filename: "#{listing.name}_photo.jpg", content_type: "image/jpg")
end

puts "Listings all seeded"

5.times do
  puts "Creating a booking now 📚"
  booking = Booking.create!(
    user: User.first,
    listing: Listing.first,
    no_of_divers: rand(1..6),
    status: ["booked", "cancelled", "completed"].sample,
    costs: rand(100..1000)
  )
  puts "New booking for #{booking.no_of_divers} divers created! 🌟"
end

puts 'seeding completed!'
