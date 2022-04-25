require 'json'

class ImagesQuery
  def initialize(input:, client:, cache:)
    @input = input
    @client = client
    @cache = cache
    @days = input[:days]
  end

  def call
    res = fetch.to_json
    @cache.save
    res
  end

  private

  DAY_IN_SECONDS = 84600

  def fetch
    res = {}
    (0..@days).each do |days_ago|
      date = (asof - DAY_IN_SECONDS * days_ago).strftime('%Y-%m-%d')
      res[date] = images_for_day(date)
    end
    res
  end

  def images_for_day(date)
    return @cache.get(rover, cam, date) if @cache.get(rover, cam, date)
    images = @client.images_for_day(date: date, **query_params)
    @cache.set(rover, cam, date, images)
  end

  def rover
    @input[:rover]
  end

  def asof
    @input[:asof]
  end

  def cam
    @input[:cam]
  end

  def query_params
    {
      rover: rover,
      cam: cam,
      limit: 3
    }
  end
end