require 'json'

class ImagesQuery
  def initialize(input:, client:)
    @input = input
    @client = client
    @days = input[:days]
  end

  def call
    fetch.to_json
  end

  private

  DAY_IN_SECONDS = 84600

  def fetch
    res = {}
    (0..@days).each do |days_ago|
      date = (asof - DAY_IN_SECONDS * days_ago).strftime('%Y-%m-%d')
      res[date] = @client.images_for_day(date: date, **query_params)
    end
    res
  end

  def asof
    @input[:asof]
  end

  def query_params
    {
      rover: @input[:rover],
      cam: @input[:cam],
      limit: 3
    }
  end
end