require 'rubygems'
require 'test/unit'
require 'fileutils'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'..','lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'powirb'

class Test::Unit::TestCase
  def test_true
    assert true
  end
end
