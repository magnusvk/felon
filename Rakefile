# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "felon"
  gem.homepage = "http://github.com/magnusvk/felon"
  gem.license = "MIT"
  gem.summary = %Q{Easy multi-armed bandit testing for Rails.}
  gem.description = %Q{This gem provides a framework to run automated multi-armed bandit testing in Rails.}
  gem.email = "magnus@vonkoeller.de"
  gem.authors = ["Magnus von Koeller"]
  gem.require 'felon/counter'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "felon #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
