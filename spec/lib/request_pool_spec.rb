require 'spec_helper'

describe RequestPool do
  before(:example) do
    @servers = [
      "https://www.cais.com",
      "https://www.caishuo.com",
      "https://www.baidu.com"
    ]

    @max_pending = 1000
    @default_timeout = 1000
    @connecttimeout = 6000
    @timeout = 10_000
    @open_proxy = true
    @proxy_url = "n"
  end

  subject do
    rc = RequestPool::Client.new(@servers)
    rc.configure do |config|
      config.max_pending = @max_pending
      config.ping = @ping
      config.timeout = @default_timeout
      config.connecttimeout = @connecttimeout
      config.open_proxy = @open_proxy
      config.proxy_url = @proxy_url
    end
    rc
  end

  it "configurable" do
    expect(subject.config.max_pending).to eq @max_pending
    expect(subject.config.ping).to eq @ping
    expect(subject.config.connecttimeout).to eq @connecttimeout
    expect(subject.config.timeout).to eq @default_timeout
    expect(subject.config.open_proxy).to eq @open_proxy
    expect(subject.config.proxy_url).to eq @proxy_url
  end

  let(:server) do
    subject.server
  end

  it "server" do
    expect(server.servers).to eq @servers
    expect do
      (@servers.size + 1).times { server.convert_server }
    end.to raise_error(RequestPool::NoAvailableServerError)
    expect(server.package("test").start_with?(server.current_server)).to be true
  end

  it "http" do
    %w(get delete put post patch).each do |method|
      p "test #{method}"
      expect(subject.http.send(method, "", nil, nil).is_a?(RequestPool::Response)).to be true
    end
  end
end
