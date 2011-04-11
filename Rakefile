require 'rubygems'
require 'rake'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'powirb/version'

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'Powirb'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.test_files = 'test/**/test_*.rb'
  t.verbose = false
end


desc "Build gem for release"
task :build do
  system "erb powirb.gemspec.erb > powirb.gemspec"
  system "gem build powirb.gemspec"
end
 
desc "Release gem to RubyGems.org"
task :release => :build do
  #system "gem push powirb-#{Powirb::VERSION}"
end