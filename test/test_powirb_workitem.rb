require File.dirname(__FILE__) + '/test_helper'
#require 'Nokogiri'

class PowirbWorkitemTest < Test::Unit::TestCase

  def setup
    src = File.join(File.dirname(__FILE__), '_sample_project')
    dst = File.join(File.dirname(__FILE__), 'sample_project')
    FileUtils.rm_rf dst
    FileUtils.cp_r  src, dst
    
    @pp = File.join(File.dirname(__FILE__),'sample_project')
	Powirb.set_logger(:debug,'/dev/null')
    @h = Powirb::Handler.new(@pp)
	@wi = @h.workitems[@h.workitems.keys.first]
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
	
	@wi['foo'] = {:value => 'new foo', :type => 'enum:fooz'}
	assert @wi.to_xml.include?("id=\"foo\" type=\"enum:fooz\"")
  end

  def test_updating_existing_field
    assert_not_nil @wi['title']
	@wi['title'] = 'Some silly Title here...'
	assert @wi['title'] == 'Some silly Title here...'
	
	@wi['title'] = {:value => 'new title', :type => 'text/plain'}
	assert @wi.to_xml.include?("id=\"title\" type=\"text/plain\"")
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
	
	h2 = Powirb::Handler.new(@pp)
	w = h2.workitems[@wi.wid]
    assert_nil w['priority']
  end
  
  def test_xml
    xml = @wi.to_xml
    assert_kind_of String, xml
    assert xml.include?("<field id=\"title\">#{@wi[:title]}</field>")
  end
  
  def test_fields
    fields = @wi.fields
    assert_kind_of Array, fields
    assert fields.include?('title')
    assert !fields.include?('foo')
  end
  
  def test_space
    assert_not_nil @wi.space
	assert_kind_of String, @wi.space
	assert_equal 'tracker', @wi.space
  end
  
  def test_links
	wi = @h.workitems['WI-2']
	assert_not_nil wi.links
	assert_equal 1, wi.links.size
	assert_equal 'parent:WI-1', wi.links.first
  end
  
  def test_add_link
    wi1 = @h.workitems['WI-1']
	assert_not_nil wi1
	wi2 = @h.workitems['WI-2']
	assert_not_nil wi2
	
    # to empty link set
	wi1.add_link(:wid => 'WI-2', :role => 'relates_to')
	assert wi1.links.include?('relates_to:WI-2')
	
	# to non empty links set
	wi2.add_link(:wid => 'WI-1', :role => 'relates_to')
	assert wi2.links.include?('relates_to:WI-1')
  end
end