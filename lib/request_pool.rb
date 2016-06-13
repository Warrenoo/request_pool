require "request_pool/client"
require "request_pool/configure"
require "request_pool/http"
require "request_pool/request"
require "request_pool/response"
require "request_pool/server"
require "request_pool/error"
require "request_pool/test"
require "request_pool/logger"
require "request_pool/version"

# 基础模块
# 在进行HTTP请求时进行多hosts地址的选择分发
module RequestPool
  extend SingleForwardable
  def_delegator RequestPool::Client, :new
end
