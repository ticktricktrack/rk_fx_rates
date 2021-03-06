# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rk_fx_rates/version'

Gem::Specification.new do |spec|
  spec.name          = "rk_fx_rates"
  spec.version       = RkFxRates::VERSION
  spec.authors       = ["Rainer Kuhn"]
  spec.email         = ["ticktricktrack@gmail.com"]
  spec.description   = %q{Obtains foreign exchange rates}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'chronic'

  # only for dirty testing
  # spec.add_runtime_dependency 'pry-remote'
end
