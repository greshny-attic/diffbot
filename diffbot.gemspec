Gem::Specification.new do |s|
  s.name        = "diffbot"
  s.version     = "0.1.8"
  s.description = "Diffbot provides a concise API for analyzing and extracting semantic information from web pages using Diffbot (http://www.diffbot.com)."
  s.summary     = "Ruby interface to the Diffbot API "
  s.authors     = ["Nicolas Sanguinetti", "Roman Greshny"]
  s.email       = ["hi@nicolassanguinetti.info", "greshny@gmail.com"]
  s.homepage    = "http://github.com/greshny/diffbot"
  s.has_rdoc    = false
  s.files       = `git ls-files`.split "\n"
  s.platform    = Gem::Platform::RUBY

  s.add_dependency("excon")
  s.add_dependency("yajl-ruby")
  s.add_dependency("nokogiri", "~> 1.5.0")
  s.add_dependency("hashie", "3.3.2")

  s.add_development_dependency("bundler", "~> 1.3")
  s.add_development_dependency("minitest")
  s.add_development_dependency("pry")
end
