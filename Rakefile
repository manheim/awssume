require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => [:help]

desc "Display the list of available rake tasks"
task :help do
  system("rake -T")
end
