# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'triggerable/version'

Gem::Specification.new do |spec|
  spec.name          = "triggerable"
  spec.version       = Triggerable::VERSION
  spec.authors       = ["DmitryTsepelev"]
  spec.email         = ["dmitry.a.tsepelev@gmail.com"]
  spec.description   = "Triggers/automations engine"
  spec.summary       = "Triggerable is a powerful engine for adding a conditional behaviour for ActiveRecord models."
  spec.homepage      = "https://github.com/anjlab/triggerable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activesupport", "~> 4.1.0"
  spec.add_development_dependency "activerecord", "~> 4.1.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "simplecov"
end
