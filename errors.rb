class ApiError < StandardError
  attr_accessor :details
  @code = nil
  @message = "ApiError"

  class << self
    attr_accessor :message, :code
  end
  
  def initialize(details: {})
    @details = details
  end

  def to_s
    msg = self.class.message
    code = self.class.code 
    "#{code ? "(#{code}) " : ''}#{msg}: #{details}"
  end
end

class BadInputError < ApiError
  @code = 1
  @message = "Bad Input"
end
