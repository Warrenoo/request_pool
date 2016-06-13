require "typhoeus"
module RequestPool
  # request 继承Typhoeus Request 类
  # 加入了默认的请求信息，和异常处理
  class Request < Typhoeus::Request
    attr_accessor :origin_url, :request_id

    def initialize(origin_url, config, opts, is_ping = false)
      super(origin_url, opts)

      @origin_url = origin_url
      @is_ping = is_ping

      setup_opts(config)
      setup_callback!
    end

    def setup_opts(config)
      options.merge!(default_opts)
      # 连接超时时间
      options.merge!(connecttimeout_ms: config.connecttimeout) if config.connecttimeout
      # 正常超时时间
      options.merge!(timeout_ms: config.timeout) if config.timeout
      # ping时的超时时间
      options.merge!(timeout_ms: config.max_pending) if @is_ping && config.max_pending
      # 代理
      options.merge!(proxy: config.proxy_url) if config.open_proxy
      # gzip
      options.merge!(accept_encoding: "gzip") if config.gzip
    end

    def setup_callback!
      on_complete do |response|
        # 无法连接
        raise UnconnHostError if [:couldnt_resolve_host, :couldnt_connect].include?(response.return_code)
      end
    end

    def run_by_server(server)
      @base_url = server.package(origin_url)

      RequestPool::Logger.info("#{Time.now}-#{request_id} REQUEST! url: #{@base_url}, options: #{options}")
      response = run
      server.clear_counter!
      response
    rescue UnconnHostError
      server.convert_server
      retry
    ensure
      if response
        force_keys = %w[total_time connect_time namelookup_time effective_url response_code return_code]
        msg = response.options.select{|k,v| force_keys.include?(k.to_s)}.map{|k,v| "#{k}: #{v}"}.join(", ")
        RequestPool::Logger.info("#{Time.now}-#{request_id} RESPONSE! #{msg}")
      end
    end

    def default_opts
      {
        followlocation: true
      }
    end
  end
end
