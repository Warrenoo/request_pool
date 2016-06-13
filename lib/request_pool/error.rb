module RequestPool
  class RequestPoolError < RuntimeError; end
  class TimeOutError < RequestPoolError; end
  class UnconnHostError < RequestPoolError; end
  class ServersEmptyError < RequestPoolError; end
  class NoAvailableServerError < RequestPoolError; end
  # 抛出返回错误
  class ResponseError < RequestPoolError
    attr_reader :response
    def initialize(message = nil, response = nil)
      super(message)
      @response = response
    end
  end
end
