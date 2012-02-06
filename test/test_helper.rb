require "minitest/spec"
require "minitest/autorun"
require "diffbot"

begin
  require "purdytest"
rescue LoadError
  # Oh well, no colorized tests for you. You can always use minitest/pride if
  # you want :P
end

MiniTest::Unit::TestCase.add_setup_hook do
  Diffbot::Request.testing = true
  Diffbot.reset!
end
