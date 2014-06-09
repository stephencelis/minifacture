Gem::Specification.new do |s|
  s.name = "miniskirt"
  s.version = "1.2.1"
  s.summary = "factory_girl, relaxed"
  s.description = "Test::Unit begot MiniTest; factory_girl begets Miniskirt."

  s.require_path = "."
  s.files = "miniskirt.rb"
  s.test_file = "miniskirt_test.rb"

  s.has_rdoc = false

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/miniskirt"

  s.required_ruby_version = ">= 1.9.3"
  s.add_dependency "activesupport"
  s.add_development_dependency "rake"
  s.add_development_dependency "i18n"
end
