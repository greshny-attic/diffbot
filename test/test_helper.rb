require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require "minitest/spec"
require "minitest/autorun"
require "diffbot"

begin
  require "purdytest"
rescue LoadError
  # Oh well, no colorized tests for you. You can always use minitest/pride if
  # you want :P
end

module MiniTest::DiffbotPlugin
  def before_setup
    Diffbot::Request.testing = true
    Diffbot.reset!
  end
end

class MiniTest::Unit::TestCase
  include MiniTest::DiffbotPlugin
end
