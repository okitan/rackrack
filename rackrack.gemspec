# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "rackrack"
  spec.version       = File.read(File.expand_path("../VERSION", __FILE__)).chomp
  spec.authors       = ["okitan"]
  spec.email         = ["okitakunio@gmail.com"]

  spec.summary       = "Rack middlewares for double"
  spec.description   = "Rack middlewares for double"
  spec.homepage      = "https://github.com/okitan/rackrack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  # for testing
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "rack-test"

  # for debug
  spec.add_development_dependency "pry"
  spec.add_development_dependency "tapp"
end
