# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{SystemTimer}
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philippe Hanrigou", "David Vollbracht"]
  s.autorequire = %q{system_timer}
  s.date = %q{2011-03-19}
  s.extensions = ["ext/system_timer/extconf.rb"]
  s.files = ["test/all_tests.rb", "ext/system_timer/extconf.rb"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{systemtimer}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Set a Timeout based on signals, which are more reliable than Timeout. Timeout is based on green threads.}
  s.test_files = ["test/all_tests.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
