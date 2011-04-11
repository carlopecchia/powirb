require 'rubygems'
require 'rake'

task :default => :test


spec = Gem::Specification.new do |s|
  s.name = 'Powirb'
  s.version = '1.0'
  s.authors = ['Carlo Pecchia']
  s.date = '2011-04-11'
  s.email = 'c.pecchia@gmail.com'
  s.files = FileList['lib/**']
  s.has_rdoc = true
  s.summary = 'POlarion WorkItems handling with RuBy'
end

task :gemspec do
  File.open('powirb.gemspec','w') do |file|
    file.write spec.to_ruby
  end
end

require 'rake/gempackagetask'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'powirb'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.test_files = 'test/**/test_*.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = 'test/**/test_*.rb'
    t.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install rcov"
  end
end

