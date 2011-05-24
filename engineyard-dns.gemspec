# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "engineyard-dns/version"

Gem::Specification.new do |s|
  s.name        = "engineyard-dns"
  s.version     = EngineYard::DNS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dr Nic Williams"]
  s.email       = ["drnicwilliams@gmail.com"]
  s.homepage    = "https://github.com/engineyard/engineyard-dns#readme"
  s.summary     = %q{Configure your Engine Yard AppCloud environment and your DNSimple domain.}
  s.description = %q{Easily configure your DNS with Engine Yard AppCloud via DNSimple.}

  s.rubyforge_project = "engineyard-dns"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("engineyard", "1.3.19")
  s.add_dependency("fog", "~> 0.8.1")

  s.add_development_dependency("rake", ["~> 0.9.0"])
  s.add_development_dependency("cucumber", ["~> 0.10"])
  s.add_development_dependency("rspec", ["~> 2.5"])
  s.add_development_dependency("json", ["~>1.4.0"])
  s.add_development_dependency("awesome_print")
  s.add_development_dependency("realweb", '~>0.1.6')
  s.add_development_dependency("open4")
  s.add_development_dependency("sinatra")
  s.add_development_dependency("fakeweb", "~>1.3.0")
end
