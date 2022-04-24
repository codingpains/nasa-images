require 'net/http'
require 'json'

module NASA
  module Api
    class Client
      attr_reader :api_key

      def initialize(api_key: 'DEMO_KEY')
        @api_key = api_key
      end

      def images(asof:, rover:, cam:, days:)
        res = {}
        (0...days).each do |days_ago|
          date = (asof - DAY_IN_SECONDS * days_ago).strftime('%Y-%m-%d')
          uri = URI(build_url(rover: rover, date: date, cam: cam))
          res[date] = ::JSON.parse(Net::HTTP.get(uri))
        end
        res
      end

      private

      DAY_IN_SECONDS = 84600

      def build_url(rover:, date:, cam:)
        date_param = date ? "earth_date=#{date}" : ''
        camera_param = cam ? "camera=#{cam}" : ''
        params = "#{date_param}#{camera_param}&api_key=#{api_key}"
        "https://api.nasa.gov/mars-photos/api/v1/rovers/#{rover}/photos?#{params}"
      end
    end
  end
end