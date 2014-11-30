begin
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
rescue LoadError
  require 'rubygems'
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
end

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
