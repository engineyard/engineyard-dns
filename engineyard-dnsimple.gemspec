# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "engineyard-dnsimple/version"

Gem::Specification.new do |s|
  s.name        = "engineyard-dnsimple"
  s.version     = EngineYard::DNSimple::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dr Nic Williams"]
  s.email       = ["drnicwilliams@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Configure your Engine Yard AppCloud environment and your DNSimple domain.}
  s.description = %q{Easily configure your DNS with Engine Yard AppCloud via DNSimple.}

  s.rubyforge_project = "engineyard-dnsimple"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
