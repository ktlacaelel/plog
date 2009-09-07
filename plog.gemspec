# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{plog}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kazuyoshi Tlacaelel"]
  s.date = %q{2009-09-07}
  s.default_executable = %q{plog}
  s.description = %q{Plog - Ruby on Rails production log statistic generator. by Kazuyoshi Tlacaelel}
  s.email = %q{kazu.dev@gmail.com}
  s.executables = ["plog"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/plog",
     "lib/cli.rb",
     "lib/completed_line.rb",
     "lib/log_file.rb",
     "lib/object_file.rb",
     "lib/plog.rb",
     "lib/url.rb",
     "plog.gemspec",
     "test/completed_line_test.rb",
     "test/data/example.log",
     "test/log_file_test.rb",
     "test/object_file_test.rb",
     "test/plog_test.rb",
     "test/test_helper.rb",
     "test/url_test.rb"
  ]
  s.homepage = %q{http://github.com/ktlacaelel/plog}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Plog - Ruby on Rails production log statistic generator. by Kazuyoshi Tlacaelel}
  s.test_files = [
    "test/completed_line_test.rb",
     "test/log_file_test.rb",
     "test/object_file_test.rb",
     "test/plog_test.rb",
     "test/test_helper.rb",
     "test/url_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
