# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-att/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-att"
  s.version     = OmniAuth::ATT::VERSION
  s.authors     = ["Ari Lerner"]
  s.email       = ["arilerner@mac.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "omniauth-att"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  %w(thin sinatra json omniauth omniauth-oauth2 activesupport i18n newrelic_rpm).each do |gem|
    s.add_runtime_dependency gem
  end
  %w(omniauth-github omniauth-facebook omniauth-twitter).each do |gem|
    s.add_runtime_dependency gem
  end
  %w(shotgun heroku).each do |gem|
    s.add_development_dependency gem
  end
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
