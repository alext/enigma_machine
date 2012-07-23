# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enigma_machine/version"

Gem::Specification.new do |s|
  s.name        = "enigma_machine"
  s.version     = EnigmaMachine::VERSION
  s.authors     = ["Alex Tomlins"]
  s.email       = ["alex@tomlins.org.uk"]
  s.homepage    = "https://github.com/alext/enigma_machine"
  s.summary     = %q{Enigma machine simulator}
  s.description = %q{Enigma machine simulator}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard", '~> 0.8.2'
  s.add_development_dependency "redcarpet"
end
