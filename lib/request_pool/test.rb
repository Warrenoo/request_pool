require "forwardable"

# DESC
module RequestPool
  # 测试类
  class Test
    extend SingleForwardable
    def_delegator :Typhoeus, :stub
  end

  # 期望类
  Expectation = Class.new Typhoeus::Expectation
end
