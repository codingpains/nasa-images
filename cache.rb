require 'json'

class Cache
  FILE_NAME = './store.json'

  def initialize
    @data = JSON.parse(File.read(FILE_NAME))
  end

  def get(rover, cam, date)
    @data.dig(rover, cam, date)
  end

  def set(rover, cam, date, entries)
    @data[rover] = {} unless @data[rover]
    @data[rover][cam] = {} unless @data[rover][cam]
    @data[rover][cam][date] = entries
    entries
  end

  def save
    File.write(FILE_NAME, JSON.dump(@data))
  end
end