# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongoid-rspec}
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Sagge"]
  s.date = %q{2011-04-23}
  s.description = %q{RSpec matches for Mongoid models, including association and validation matchers}
  s.email = %q{evansagge@gmail.com}
  s.files = ["spec/models/article.rb", "spec/models/comment.rb", "spec/models/log.rb", "spec/models/movie_article.rb", "spec/models/permalink.rb", "spec/models/profile.rb", "spec/models/record.rb", "spec/models/site.rb", "spec/models/user.rb", "spec/spec_helper.rb", "spec/unit/associations_spec.rb", "spec/unit/collections_spec.rb", "spec/unit/document_spec.rb", "spec/unit/validations_spec.rb"]
  s.homepage = %q{http://github.com/evansagge/mongoid-rspec}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mongoid-rspec}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{RSpec matchers for Mongoid}
  s.test_files = ["spec/models/article.rb", "spec/models/comment.rb", "spec/models/log.rb", "spec/models/movie_article.rb", "spec/models/permalink.rb", "spec/models/profile.rb", "spec/models/record.rb", "spec/models/site.rb", "spec/models/user.rb", "spec/spec_helper.rb", "spec/unit/associations_spec.rb", "spec/unit/collections_spec.rb", "spec/unit/document_spec.rb", "spec/unit/validations_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>, ["~> 2.0"])
      s.add_runtime_dependency(%q<rspec>, ["~> 2"])
    else
      s.add_dependency(%q<mongoid>, ["~> 2.0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
    end
  else
    s.add_dependency(%q<mongoid>, ["~> 2.0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
  end
end
