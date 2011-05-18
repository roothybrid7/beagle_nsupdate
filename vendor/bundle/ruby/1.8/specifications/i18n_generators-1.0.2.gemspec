# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{i18n_generators}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Akira Matsuda"]
  s.date = %q{2010-11-29}
  s.description = %q{A Rails generator plugin & gem that generates Rails I18n locale files for almost every known locale.}
  s.email = %q{ronnie@dio.jp}
  s.files = ["spec/cldr_spec.rb", "spec/i18n_locale_command_spec.rb", "spec/i18n_translation_command_spec.rb", "spec/spec_helper.rb", "spec/translator_spec.rb", "spec/yaml_spec.rb"]
  s.homepage = %q{http://github.com/amatsuda/i18n_generators/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Generates I18n locale files for Rails 3 and Rails 2}
  s.test_files = ["spec/cldr_spec.rb", "spec/i18n_locale_command_spec.rb", "spec/i18n_translation_command_spec.rb", "spec/spec_helper.rb", "spec/translator_spec.rb", "spec/yaml_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
