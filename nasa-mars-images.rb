require 'dotenv'
require './input-parser'
require './nasa-api-client'
require './images-query'

Dotenv.load

puts "The NASA Open Images API Inspector"

begin
  input = InputParser.new(ARGV).parse
  client = NASA::Api::Client.new(api_key: ENV['NASA_API_KEY'])
  ImagesQuery.new(input: input, client: client).call
rescue => error
  puts error.to_s
  exit 1
end


