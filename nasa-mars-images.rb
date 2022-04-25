require 'dotenv'
require './input-parser'
require './nasa-api-client'
require './images-query'
require './cache'

Dotenv.load

def print_help
  text = <<~HEREDOC
    usage: ruby nasa-mars-images.rb --rover[=<name>] --cam[=<name>] 
                                 [--asof=<date:today>] [--days=<number:10>]
    These are the valid Rover names
     - curiosity
     - opportunity
     - spirit

    These are the valid camera codes
      - name=FHAZ, -> Front Hazard Avoidance Camera
      - name=RHAZ, -> Rear Hazard Avoidance Camera
      - name=MAST, -> Mast Camera
      - name=CHEMCAM, -> Chemistry and Camera Complex
      - name=MAHLI, -> Mars Hand Lens Imager
      - name=MARDI, -> Mars Descent Imager
      - name=NAVCAM, -> Navigation Camera
      - name=PANCAM, -> Panoramic Camera
      - name=MINITES, -> Miniature Thermal Emission Spectrometer (Mini-TES)

    Example:
    
    Get me 10 days of pictures as of Jan 1st 2022 from the
    Navigation camera of curiosity rover.

    $ ruby nasa-mars-images.rb --rover=curiosity --cam=NAVCAM --asof=2022-01-01 --days=3

  HEREDOC

  puts text
end

begin
  input = NASA::Api::InputParser.new(ARGV).parse
  client = NASA::Api::Client.new(api_key: ENV['NASA_API_KEY'])
  if input[:help]
    print_help 
  else
    puts ImagesQuery.new(input: input, client: client, cache: Cache.new).call
  end
rescue => error
  puts error.to_s
  puts error.backtrace unless error.is_a?(ApiError)
  exit 1
end
