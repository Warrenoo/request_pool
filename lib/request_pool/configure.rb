module RequestPool
  # CONFIG
  class Config
    attr_accessor :max_pending, :ping, :timeout, :connecttimeout, :open_proxy, :proxy_url, :gzip

    def initialize
      @max_pending = 3_000
      @connecttimeout = 5_000
      @timeout = 30_000
      @ping = "/"
      @open_proxy = false
      @proxy_url = ""
      @gzip = false
    end
  end
end
