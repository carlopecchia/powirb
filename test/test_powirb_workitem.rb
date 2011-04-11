require File.dirname(__FILE__) + '/test_helper'

class PowirbWorkitemTest < Test::Unit::TestCase

  def setup
    src = File.join(File.dirname(__FILE__), '_sample_project')
    dst = File.join(File.dirname(__FILE__), 'sample_project')
    FileUtils.rm_rf dst
    FileUtils.cp_r  src, dst
    
    pp = File.join(File.dirname(__FILE__),'sample_project')
	Powirb.set_logger(:debug,'/dev/null')
    @h = Powirb::Handler.new(pp)
	@wi = @h.workitems.first
	@wi.read
  end
  
  def teardown
    FileUtils.rm_rf File.join(File.dirname(__FILE__), 'sample_project')
  end
  
  def test_valid_workitem
	assert_not_nil @wi
	assert_kind_of Powirb::Workitem, @wi
  end

  def test_wid
    assert_not_nil @wi.wid
	assert_match /(\w+)\-(\d+)/, @wi.wid
  end
  
  def test_add_field
	assert_nil @wi['foo']
	assert_nil @wi[:foo]
    @wi['foo'] = 'bar'
	assert @wi['foo'] == 'bar'
	assert @wi[:foo] == 'bar'
  end
  
  def test_updating_existing_field
    assert_not_nil @wi['title']
	@wi['title'] = 'Some silly Title here...'
	assert @wi['title'] == 'Some silly Title here...'
  end

  def test_remove_field
    assert_not_nil @wi['priority']
	@wi['priority'] = nil
	assert_nil @wi['priority']
  end

  def test_change_field_name
    value = @wi['priority']
    assert_not_nil value

	@wi['extimatedPriority'] = value
	@wi['priority'] = nil
	
	assert_nil @wi['priority']
	assert @wi['extimatedPriority'] == value
  end
  
  def test_save
    assert_not_nil @wi['priority']
	@wi['priority'] = nil
	assert_nil @wi['priority']
	@wi.save!
	
	w = @h.workitems.first
	w.read
    assert_nil w['priority']
  end

end