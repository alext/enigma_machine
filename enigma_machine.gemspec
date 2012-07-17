# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enigma_machine/version"

Gem::Specification.new do |s|
  s.name        = "enigma_machine"
  s.version     = EnigmaMachine::VERSION
  s.authors     = ["Alex Tomlins"]
  s.email       = ["alex@tomlins.org.uk"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
