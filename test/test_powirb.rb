require File.dirname(__FILE__) + '/test_helper'


class PowirbTest < Test::Unit::TestCase

  def test_valid_default_logger
    assert_not_nil Powirb.log
  end

  def test_valid_logger
	Powirb.set_logger(:debug)
	assert_not_nil Powirb.log
  end
  
end