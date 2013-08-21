# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poison_pill/version'

Gem::Specification.new do |spec|
  spec.name          = "poison_pill"
  spec.version       = PoisonPill::VERSION
  spec.authors       = ["Larry Baltz"]
  spec.email         = ["larry@baltz.org"]

  spec.description   = %q{Ruby library for attributes that shouldn't be touched}
  spec.summary       =
    %q{A Ruby library providing a PoisonPill that will fail at (almost) any attempt to use it and report a useful error to let you know where the pill originated }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rr"
end
