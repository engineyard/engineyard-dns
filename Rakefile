require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new

namespace :cucumber do
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
    t.cucumber_opts = "--tags @wip"
  end
  Cucumber::Rake::Task.new(:ok, 'Run features that should be working') do |t|
    t.cucumber_opts = "--tags ~@wip"
  end
  task :all => [:ok, :wip]
end

desc 'Alias for cucumber:ok'
task :cucumber => 'cucumber:ok'

desc "Specs and Cucumber features by default"
task :default => ["spec", "cucumber"]
