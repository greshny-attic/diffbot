require "minitest/spec"
require "minitest/autorun"
require "diffbot"

begin
  require "purdytest"
rescue LoadError
  # Oh well, no colorized tests for you. You can always use minitest/pride if
  # you want :P
end
