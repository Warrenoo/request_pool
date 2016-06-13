require "typhoeus"
module RequestPool
  # HTTP 请求代理类
  class Http
    attr_accessor :server, :config
    def initialize(server, config)
      @server = server
      @config = config
    end

    %w(get delete put post patch).each do |method|
      define_method method.to_sym do |url, params, body = {}, headers = {}, &block|
        match(method, url, params, body, headers, &block)
      end
    end

    def match(type, url, params = {}, body = {}, headers = {})
      block_given? ? yield(tmp_config = config.dup) : tmp_config = nil

      request_id = "#{rand_num}#{Time.now.strftime('%Y%m%d%H%M%S%L')}".to_i.to_s(36)

      request = RequestPool::Request.new(url, tmp_config || config, method: type, params: params, body: body, headers: headers)
      request.request_id = request_id

      response = RequestPool::Response.copy_by(request.run_by_server(server))
      response
    end

    def rand_num
      rand(100_000).to_s.ljust(5, '0')
    end
  end
end
