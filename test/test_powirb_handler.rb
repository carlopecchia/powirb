require File.dirname(__FILE__) + '/test_helper'


class PowirbHandlerTest < Test::Unit::TestCase

  def setup
    pp = File.join(File.dirname(__FILE__),'_sample_project')
	Powirb.set_logger(:debug,'/dev/null')
    @h = Powirb::Handler.new(pp)
  end
  
  def test_valid_handler
	assert_not_nil @h
  end
  
  def test_invalid_project_path
	assert_raise RuntimeError do
		assert_nil Powirb::Handler.new(File.join('s0m3','n0n','ex1st3nt','p4thn4m3'))
	end
  end
  
  def test_workitems
    assert_kind_of Array, @h.workitems
	assert @h.workitems_count == 4
	assert @h.workitems.size == 4
  end
  
end