Gem::Specification.new do |s|
  s.date = "2011-11-21"

  s.name = "miniskirt"
  s.version = "1.1.0"
  s.summary = "factory_girl, relaxed"
  s.description = "Test::Unit begot MiniTest; factory_girl begets Miniskirt."

  s.require_path = "."
  s.files = "miniskirt.rb"
  s.test_file = "miniskirt_test.rb"

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/miniskirt"

  s.required_ruby_version = ">= 1.8.7"
  s.add_dependency "activesupport",
    RUBY_VERSION >= "1.9" ? "~> 2.2" : "~> 3.0.0"
  s.add_development_dependency "rake", "~> 0.9.2"
end
