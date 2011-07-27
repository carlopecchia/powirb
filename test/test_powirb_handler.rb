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
  
  def test_wired_workitems_sources
    assert_not_nil @h.workitems_paths
	assert_kind_of Array, @h.workitems_paths
  end
  
  def test_workitems
    assert_kind_of Hash, @h.workitems
	assert @h.workitems.size == 4
	
	assert_equal 1, @h.workitems(:type => 'task').size
	assert_equal 3, @h.workitems(:type => 'action').size
	assert_equal 0, @h.workitems(:type => 'fooz').size
	
	assert_not_nil @h.workitems['WI-1']
	assert_nil @h.workitems['non existant wid']	
  end
  
end