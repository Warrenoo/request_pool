# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_pool/version'

Gem::Specification.new do |spec|
  spec.name          = "request_pool"
  spec.version       = RequestPool::VERSION
  spec.authors       = ["沈汪洋"]
  spec.email         = ["541991a@gmail.com"]
  spec.summary       = "LoadBalancer Pool for Http & Https Request"
  spec.description   = "LoadBalancer Pool for Http & Https Request"
  spec.homepage      = "www.janecy.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop"

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency 'simplecov'

  spec.add_dependency "typhoeus"
end
