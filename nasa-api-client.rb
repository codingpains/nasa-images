require 'net/http'
require 'json'

module NASA
  module Api
    class Client
      attr_reader :api_key

      def initialize(api_key:)
        @api_key = api_key
      end

      def images_for_day(date:, rover:, cam:, limit:)
        uri = URI(build_url(rover: rover, date: date, cam: cam))
        res = ::JSON.parse(Net::HTTP.get(uri))
        res = limit(res, limit)
        cleanup(res)
      end

      private

      def build_url(rover:, date:, cam:)
        date_param = date ? "earth_date=#{date}" : ''
        camera_param = cam ? "camera=#{cam}" : ''
        params = "#{date_param}&#{camera_param}&api_key=#{api_key}"
        "#{ENV['NASA_API_BASE_URL']}/#{rover}/photos?#{params}"
      end

      def limit(res, n)
        res['photos'].slice(0, n)
      end

      def cleanup(res)
        res.map {|img| img['img_src']}
      end
    end
  end
end