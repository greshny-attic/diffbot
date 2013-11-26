require "rake/testtask"
require "rubygems/package_task"

gem_spec = eval(File.read("./diffbot.gemspec")) rescue nil
Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
  t.verbose = true
  t.libs << 'test'
end

task default: :test
