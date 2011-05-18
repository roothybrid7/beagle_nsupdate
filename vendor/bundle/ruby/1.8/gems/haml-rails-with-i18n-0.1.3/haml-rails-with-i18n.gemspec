# -*- encoding: utf-8 -*-
require File.expand_path("../lib/haml-rails/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "haml-rails-with-i18n"
  s.version     = Haml::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["André Arko", "Enrique García"]
  s.email       = ["egarcia@splendeo.es"]
  s.homepage    = "http://github.com/splendeo/haml-rails"
  s.summary     = "let your Gemfile do the configuring"
  s.description = "Haml-rails with i18n views"

  s.rubyforge_project         = "haml-rails"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "haml",          "~> 3.0"
  s.add_dependency "activesupport", "~> 3.0"
  s.add_dependency "actionpack",    "~> 3.0"
  s.add_dependency "railties",      "~> 3.0"

  s.add_development_dependency "rails",   "~> 3.0"
  s.add_development_dependency "bundler", "~> 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end
