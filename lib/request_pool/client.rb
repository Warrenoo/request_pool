require "forwardable"
module RequestPool
  # 客户端连接类，进行基本配置
  # servers: hosts列表
  class Client
    attr_accessor :server, :http
    attr_accessor :config

    extend Forwardable
    def_delegators :http, :match, :get, :put, :post, :delete, :patch

    def initialize(servers, &block)
      configure(&block)
      @server = Server.new(servers)
      @http = Http.new(server, config)
    end

    def configure
      @config ||= RequestPool::Config.new
      yield @config if block_given?
    end
  end
end
