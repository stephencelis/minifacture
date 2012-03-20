# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "midiskirt/version"

Gem::Specification.new do |s|
  s.name        = "midiskirt"
  s.version     = Midiskirt::VERSION
  s.summary     = "factory_girl, relaxed"
  s.description = "Test::Unit begot MiniTest; factory_girl begot Miniskirt, Miniskirt begets Midiskirt"

  s.authors     = ["Stephen Celis", "Alexey Bondar"]
  s.email       = ["stephen@stephencelis.com", "y8@ya.ru"]
  s.homepage    = "http://github.com/y8/midiskirt"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Development depensencies
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake"

  # Runtime dependencies
  s.add_runtime_dependency "activesupport", RUBY_VERSION >= "1.9" ? ">= 2.2" : ">= 3.0"
end
