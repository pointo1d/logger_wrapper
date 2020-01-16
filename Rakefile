require "bundler/gem_tasks"
require "rake/clean"
require "rdoc/task"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.exclude("README.md")
  rdoc.rdoc_files.include("**/*.rb")
end

task :default => :spec

#### END OF FILE
