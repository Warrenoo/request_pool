module RequestPool
  # hosts 切换规则类
  class Server
    attr_accessor :servers

    def initialize(servers)
      raise ServersEmptyError unless servers.is_a?(Array) && servers.size > 0
      # host 列表
      @servers = servers
      # host 数量
      @servers_size = servers.size
      # 当前host下标
      @index = 0
      # 计数器
      @counter = 0
    end

    # 当检索次数超过servers数量时抛出异常结束
    def convert_server
      unless @counter < @servers_size - 1
        clear_counter!
        raise NoAvailableServerError, "no available server, sorry"
      end
      @counter += 1
      @index = (@index + 1) % @servers_size
    end

    def current_server
      servers[@index]
    end

    # 请求未报错或者抛出NoAvailableServerError异常，重置counter
    def clear_counter!
      @counter = 0
    end

    def package(url = "")
      current_server + full_url(url)
    end

    def full_url(url)
      url.start_with?("/") ? url : "/#{url}"
    end
  end
end
