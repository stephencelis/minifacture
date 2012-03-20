require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir["test/**/*_test.rb"]
end

task :default => :test

task :loc do
  count = 0
  File.open("midiskirt.rb").each do |line|
    count += 1 unless line =~ /^\s*($|#)/   # Any number of spaces followed by EOL or #
  end
  puts "#{count} lines of real code"
end
