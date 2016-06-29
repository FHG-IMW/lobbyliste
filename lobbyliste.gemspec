# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lobbyliste/version'

Gem::Specification.new do |spec|
  spec.name          = "lobbyliste"
  spec.version       = Lobbyliste::VERSION
  spec.authors       = ["DarthMax"]
  spec.email         = ["max@kopfueber.org"]

  spec.summary       = %q{Ruby crawler for the list of lobbyists published by German Bundestag}
  spec.description   = %q{This gem crawls and parses the the list of lobbyists which is published as a PDF by the German Bundestag. }
  spec.homepage      = "https://github.com/FHG-IMW/lobbyliste"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["lobbyliste"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
