# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'lib', 'engineyard-dns', 'version')

Gem::Specification.new do |s|
  s.name        = "engineyard-dns"
  s.version     = EngineYard::DNS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dr Nic Williams", "Martin Emde"]
  s.email       = ["drnicwilliams@gmail.com", "memde@engineyard.com"]
  s.homepage    = "https://github.com/engineyard/engineyard-dns#readme"
  s.summary     = %q{Configure DNS for your Engine Yard Cloud environment.}
  s.description = %q{Easily configure your DNS with Engine Yard Cloud via Fog.}

  s.rubyforge_project = "engineyard-dns"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("engineyard", "1.4.10")
  s.add_dependency("fog", "~> 1.0")
  s.add_dependency("ipaddress", "~> 0.8")
  s.add_dependency("domo-rb")

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
