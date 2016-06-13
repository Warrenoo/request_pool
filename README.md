# RequestPool

In-process HTTP load balancer client with retries and backpressure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'request_pool'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install request_pool


## Usage Example

```ruby
servers = [
    "http://10.0.0.1:8000",
    "http://10.0.0.2:8000",
    "http://10.0.0.3:8000"
];

api_pool = RequestPool.new(servers) # 或者
api_pool = RequestPool::Client.new(servers)

# 配置
api_pool.configure do |config|
  config.max_pending = 3000     # ping时超时时间, 暂时没有使用
  config.ping = "/ping"         # ping请求url, 暂时没有使用
  config.timeout = 10000        # 正常超时时间, 默认10000
  config.connecttimeout = 5000  # 连接超时时间, 默认5000
  config.open_proxy = true      # 是否开启代理, 默认false
  config.proxy_url = "xxxx"     # 代理转发url, open_proxy为true时配置
end


# 调用
api_pool.get("/api/auth?username=xx")

api_pool.get("/api/auth", {username=xx})

api_pool.post("/api/auth", {username=xx})  # with params
api_pool.post("/api/auth", {}, {username=xx}) # with body

api_pool.put("/api/auth", {username=xx})   # with params
api_pool.put("/api/auth", {}, {username=xx}) # with body

api_pool.delete("/api/auth", {username=xx})

# 可以设置临时参数进行调用
api_pool.get("/api/auth", {}) do |config|
  config.timeout = 30_000
end

```

TEST
======

```ruby
RSpec.configure do |config|
  config.before :each do
    RequestPool::Expectation.clear
  end
end

response = RequestPool::Response.new(code: 200, body: "{'name' : 'paul'}")
RequestPool::Test.stub('www.example.com').and_return(response)
RequestPool::Client.get("www.example.com") == response
```


Example for P2P Client
======

```ruby
servers = [
    "http://10.0.0.1:8000",
    "http://10.0.0.2:8000",
    "http://10.0.0.3:8000"
];

P2PClient.host = RequestPool.new(servers)
```
