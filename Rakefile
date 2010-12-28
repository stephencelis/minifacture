require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = %w(miniskirt_test.rb)
  t.libs << '.'
end

task :default => :test
