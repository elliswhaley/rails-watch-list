# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Movie.destroy_all

require "json"
require "open-uri"

url = "https://tmdb.lewagon.com/movie/top_rated"
movies_data = URI.open(url).read
movies_hash = JSON.parse(movies_data)
movies_array = movies_hash["results"]

puts "creating movies..."

movies_array.each do |movie|
  title = movie["title"]
  overview = movie["overview"]
  image = "https://image.tmdb.org/t/p/w185/#{movie['poster_path']}"
  rating = movie["vote_average"]
  Movie.create(
    title: title,
    overview: overview,
    poster_url: image,
    rating: rating,
  )
end

puts "#{Movie.count} movies created"
