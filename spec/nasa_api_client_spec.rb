require 'json'
require './nasa-api-client'
require './errors'
require "#{Dir.pwd}/spec/support/webmock.rb"

describe NASA::Api::Client do
  describe '#images_for_day' do

    let(:curiosity_fixture) do
      fixture_path = "#{Dir.pwd}/spec/fixtures/curiosity.json"
      File.read(fixture_path)
    end

    let(:date) {
      '2022-04-03'
    }

    let(:cam) {
      'NAVCAM'
    }

    let(:api_key) {
      'TEST_KEY'
    }

    before do
      path = "/curiosity/photos?earth_date=#{date}&camera=#{cam}&api_key=#{api_key}"
      stub_get(path).to_return(
        body: curiosity_fixture,
        headers: { content_type: 'application/json' }
      )
    end

    it 'gets images' do
      args = {date: date, cam: cam, rover: 'curiosity', limit: 3}
      client = NASA::Api::Client.new(api_key: api_key)
      expect(client.images_for_day(**args)).to eql([
        'https://mars.nasa.gov/msl-raw-images/msss/03433/mhli/3433MH0002270001201944S00_DXXX.jpg',
        'https://mars.nasa.gov/msl-raw-images/msss/03433/mhli/3433MH0002270001201943R00_DXXX.jpg',
        'https://mars.nasa.gov/msl-raw-images/msss/03433/mhli/3433MH0002270001201942S00_DXXX.jpg'
      ])
    end

    it 'handles nasa api errors' do
      path = "/curiosity/photos?earth_date=#{date}&camera=#{cam}&api_key=#{api_key}"
      stub_get(path).to_return(status: 429)
      args = {date: date, cam: cam, rover: 'curiosity', limit: 3}
      client = NASA::Api::Client.new(api_key: api_key)
      expect { client.images_for_day(**args) }.to raise_error(NasaApiError)
    end
  end
end