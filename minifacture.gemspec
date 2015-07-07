Gem::Specification.new do |s|
  s.name = "minifacture"
  s.version = "1.3.0"
  s.summary = "factory_girl for minitest."
  s.description = "Test::Unit begot MiniTest; factory_girl begets Minifacture."

  s.require_path = "."
  s.files = "minifacture.rb"
  s.test_file = "minifacture_test.rb"

  s.has_rdoc = false

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/minifacture"
  s.license = "MIT"

  s.required_ruby_version = ">= 1.8.7"
  s.add_dependency "activesupport", ">= 2.2"
  s.add_development_dependency "rake", "~> 10.0", ">= 10.0.0"
  s.add_development_dependency "i18n", "~> 0.6", ">= 0.6.0"
end
