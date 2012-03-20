Gem::Specification.new do |s|
  s.date = "2011-11-21"

  s.name = "midiskirt"
  s.version = "1.1.1"
  s.summary = "factory_girl, relaxed"
  s.description = "Test::Unit begot MiniTest; factory_girl begot Miniskirt, Miniskirt begets Midiskirt"

  s.require_path = "."
  s.files = "midiskirt.rb"
  s.test_file = "midiskirt_test.rb"

  s.authors = ["Stephen Celis", "Alexey Bondar"]
  s.email = ["stephen@stephencelis.com", "y8@ya.ru"]
  s.homepage = "http://github.com/y8/midiskirt"

  s.required_ruby_version = ">= 1.8.7"
  s.add_dependency "activesupport",
    RUBY_VERSION >= "1.9" ? ">= 2.2" : ">= 3.0"
  s.add_development_dependency "rake", "~> 0.9.2"
end
