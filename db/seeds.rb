# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'nokogiri'
require 'json'
require "open-uri"
require 'pry-byebug'


def seed_ships
  regions = ['asia', 'europe', 'australia', 'oceania']
  ships_seed = []

  regions.each do |region|
    filepath = File.join(__dir__, "data/ships/#{region}.json")
    serialized_ship_loc = File.read(filepath)

    ship_locs = JSON.parse(serialized_ship_loc)
    ship_folders = ship_locs['kml']['Document']['Folder']
    ship_folders.each do |folder|

      ship_hash = {
        id: ships_seed.count + 1,
        location: folder['name']['#cdata-section']
      }
      placemark = folder['Placemark']
      if placemark.instance_of?(Hash)
        log_lat = placemark['Point']['coordinates'].split(',')
        unless log_lat.empty?
          ship_hash[:name] = placemark['name']['#cdata-section']
          ship_hash[:latitude] = log_lat[1]
          ship_hash[:longitude] = log_lat[0]
        end
        ships_seed << ship_hash
      else
        placemark.each do |ship_info|
          log_lat = ship_info['Point']['coordinates'].split(',')
          unless log_lat.empty?
            ship_hash[:name] = ship_info['name']['#cdata-section']
            ship_hash[:latitude] = log_lat[1]
            ship_hash[:longitude] = log_lat[0]
          end
          ships_seed << ship_hash
        end
      end
    end
  end
  return ships_seed.uniq
end

def seed_dive_centers
  regions = ['asia', 'europe', 'australia']
  dive_centers_seed = []

  regions.each do |region|
    filepath = File.join(__dir__, "data/dive_center/#{region}.json")
    serialized_dive_center = File.read(filepath)
    dive_centers_json = JSON.parse(serialized_dive_center)

    dive_centers = dive_centers_json['div']['div'][1]['div'][0]['div']

    dive_centers.each do |dive_center|
      if dive_center['div']['div'][0]['div']['div'].instance_of?(Hash)
        img = dive_center['div']['div'][0]['div']['div']['div']['div']['div']['div']['img']['@src']
      else
        img = dive_center['div']['div'][0]['div']['div'][1]['div']['div'][0]['div']['div']['img']['@src']
      end
      name = dive_center['div']['div'][1]['div'][0]['p']['#text']
      loc = dive_center['div']['div'][1]['div'][1]['div'][0]['div'][0]['p'][0]['#text']
      if dive_center['div']['div'][1]['div'][1]['div'][0]['div'][1]['p'].instance_of?(Hash)
        lag = dive_center['div']['div'][1]['div'][1]['div'][0]['div'][1]['p']['span']['#text']
      else
        lag = dive_center['div']['div'][1]['div'][1]['div'][0]['div'][1]['p'][0]['span']['#text']
      end

      dive_center_hash = {
        id: dive_centers_seed.count + 1,
        img: img,
        name: name,
        location: loc,
        language: lag.split(',')
      }
      dive_centers_seed << dive_center_hash
    end
  end
  return dive_centers_seed
end

puts 'Destroying everything... 💣'
Interest.destroy_all
User.destroy_all
puts 'Users destroyed!'
puts 'Interests destroyed!'

puts 'initialize seed... 🌱'

puts 'creating ships database from exsiting files...'
ship_seed = seed_ships
puts 'Ships database created!'

puts 'creating ships database from exsiting files...'
dive_center_seed = seed_dive_centers
puts 'Ships database created!'

puts 'Creating interests for homepage...'
filepath = File.join(__dir__, 'data/interests.json')
serialized_interests = File.read(filepath)
interests_json = JSON.parse(serialized_interests)

interests_json.each do |interest|
  puts "Creating interest: #{interest[0]}"
  Interest.create!(
  name: interest[0],
  description: interest[1]['description'],
  img_url: interest[1]['img_url']
)
  puts "#{interest[0]} created! ✅"
end
puts "All interests seeded!"

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

puts 'creating dive centers for random users'
dive_center_seed.each do |dive_center|
  img_file = URI.open(dive_center[:img])
  dive_center[:location] = dive_center[:location].split(",")
  center = Center.create!(
    name: dive_center[:name],
    description: Faker::Company.catch_phrase,
    address: dive_center[:location][0],
    phone_number: Faker::Company.australian_business_number,
    email: Faker::Internet.email,
    location: dive_center[:location][1],
    user: User.all.sample,
    language: dive_center[:language]
  )
  puts "Attaching image to the center"
  center.photo.attach(io: img_file, filename: "#{center.name}_photo.jpg", content_type: "image/jpg")
end

puts 'creating listings for random dive center'
CATEGORY = ["trip", "course"]
ship_seed.each do |ship|
  file = URI.open('https://source.unsplash.com/1920x1080/?scuba')
  listing = Listing.create!(
    category: CATEGORY.sample,
    name: ship[:name],
    description: Faker::Lorem.paragraph,
    price: rand(100..250),
    date: Faker::Date.forward(days: 1),
    start_time: Faker::Time.forward(days: 1, period: :morning, format: :short),
    duration: rand(1..72),
    dive_count: rand(1..4),
    max_divers: rand(2..8),
    latitude: ship[:latitude],
    longitude: ship[:longitude],
    center: Center.all.sample
  )

  puts "Attaching the photo to trips 📷"
  listing.photo.attach(io: file, filename: "#{listing.name}_photo.jpg", content_type: "image/jpg")
end

puts "Listings all seeded"

5.times do
  puts "Creating a booking now 📚"
  booking = Booking.create!(
    user: User.first,
    listing: Listing.all.sample,
    no_of_divers: rand(1..6),
    status: ["booked", "cancelled", "completed"].sample,
    costs: rand(100..1000)
  )
  puts "New booking for #{booking.no_of_divers} divers created! 🌟"
end

puts 'seeding completed!'
