# Suggested docs
# --------------
# https://github.com/bblimke/webmock
# https://github.com/bblimke/webmock/wiki/Stubbing
# https://github.com/bblimke/webmock/wiki/RSpec-support
require 'dotenv'
require 'webmock/rspec'

Dotenv.load

WebMock.disable_net_connect!

module WebMockHelpers

  NASA_API_BASE_URL = ENV['NASA_API_BASE_URL']

  def stub_get(path)
    stub_request(:get, NASA_API_BASE_URL + path)
  end
end

RSpec.configure do |config|
  config.include WebMockHelpers
end
