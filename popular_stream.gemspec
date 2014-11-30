# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'popular_stream/version'

Gem::Specification.new do |spec|
  spec.name          = "popular_stream"
  spec.version       = PopularStream::VERSION
  spec.authors       = ["Nicolás Hock Isaza"]
  spec.email         = ["nhocki@gmail.com"]
  spec.summary       = %q{Ruby gem to track popular streams with a redis backend.}
  spec.description   = %q{Ruby gem to track popular streams with a redis backend.}
  spec.homepage      = "https://github.com/nhocki/popular_streams"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "timecop", "~> 0.7.1"
end
