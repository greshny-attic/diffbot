Gem::Specification.new do |s|
  s.name        = "diffbot"
  s.version     = "0.1.1"
  s.description = "Diffbot provides a concise API for analyzing and extracting semantic information from web pages using Diffbot (http://www.diffbot.com)."
  s.summary     = "Ruby interface to the Diffbot API "
  s.authors     = ["Nicolas Sanguinetti"]
  s.email       = "hi@nicolassanguinetti.info"
  s.homepage    = "http://github.com/tinder/diffbot"
  s.has_rdoc    = false
  s.files       = `git ls-files`.split "\n"
  s.platform    = Gem::Platform::RUBY

  s.add_dependency("excon")
  s.add_dependency("yajl-ruby")
  s.add_dependency("nokogiri")
  s.add_dependency("hashie")

  s.add_development_dependency("minitest")
end
