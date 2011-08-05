require 'nokogiri'

module Powirb

# This class represent a workitem instance, that is serialized in a XML
# file under Polarion subversion repository (for us - more conveniently - 
# a working copy of it).
#
# Author:: Carlo Pecchia (mailto:info@carlopecchia.eu)
# Copyright:: Copyright (c) 2011 Carlo Pecchia
# License:: See LICENSE file
class Workitem
  attr_reader :filename

  # Create a new instance of a workitem belonging to its representation 
  # in the standard way Polarion does it
  def initialize(filename)
    @filename = filename
    Powirb.log.debug("Retrieving workitem from #{@filename}")
    begin
	  @doc = Nokogiri::XML(open(@filename))
	rescue Exception => e
	  Powirb.log.error(e)
	end	
  end
  
  # Return a field value
  def [](fname)
    fname = fname.to_s
    node = @doc.xpath("//field[@id=\"#{fname}\"]")
    return nil  if node.text.empty?
	node.text
  end
  
  # Set/remove a field, optionally is possible to specify a 'type'
  # eg: wi[:foo] = nil   -> remove the field 'foo'
  #     wi[:foo] = 'bar' -> add/update the field 'foo'
  #     wi[:foo] = {:value => 'bar', :type => 'enum:foo'} -> the same as above
  def []=(f,v)
    f = f.to_s

	# with a null value we remove and existing field
	if v.nil?
	  # Delete
      Powirb.log.debug("[#{wid}] removing field '#{f}'")
      @doc.xpath("//field[@id=\"#{f}\"]").last.remove
	  return
	end
	# assert: v is defined (String or Hash)
	
	# retrieve the 'value' and the optional 'type'
	if v.instance_of?(Hash)
	  value = v[:value]
	  type  = v[:type]
	else 
	  value = v
	  type  = nil
	end
	# assert: 'value' and 'type' are defined
	
	if self[f].nil?
	  # Create: the field is not already present
      Powirb.log.debug("[#{wid}] adding new field '#{f}' with value '#{value}'")
	  e = Nokogiri::XML::Node.new('field', @doc)
	  e['id'] = f
	  e['type'] = type  unless type.nil?
	  e.content = value
	  # we are sure the 'type' field always exists for any workitem, so attach after that
	  @doc.xpath('//field[@id="type"]').last.add_next_sibling(e)
	else
	  # Update: the field is already present
	  Powirb.log.debug("[#{wid}] updating existing field '#{f}' with value '#{value}'")
	  e = @doc.xpath("//field[@id=\"#{f}\"]").last
	  e['type'] = type  unless type.nil?
	  e.content = value	  
	end	
  end
  
  
  # Return the list of linked workitems ['role1:wid1', ..., 'roleN:widN']
  def links
	tmp = []
    @doc.xpath('//field[@id="linkedWorkItems"]/list/struct').each do |struct|
	  linked_wid = struct.xpath('item[@id="workItem"]').text
	  role = struct.xpath('item[@id="role"]').text
	  tmp << "#{role}:#{linked_wid}"
	end
	return tmp
  end
  
  # Add a link to another workitem with specified role
  def add_link(lh)
    lnk_wid  = lh[:wid]
	lnk_role = lh[:role]
	
	# find or create the attach node
    if @doc.xpath('//field[@id="linkedWorkItems"]/list').last.nil?
      Nokogiri::XML::Builder.with(@doc.xpath('//work-item').last) do
        field(:id => 'linkedWorkItems') {
	      list {}
	    }
      end
    end
	
	# build and attach the link struct
	Nokogiri::XML::Builder.with(@doc.xpath('//field[@id="linkedWorkItems"]/list').last) do
	  struct {
	    item(:id => 'revision')
		item(:id => 'workItem') {
		  text lnk_wid
		}
		item(:id => 'role') {
		  text lnk_role
		}
	  }
	end
  end
  
  # Save workitem on filesystem
  def save!
    Powirb.log.debug("[#{wid}] saving on #{@filename}")
    File.open(@filename, 'w+') {|io| io.puts @doc}
  end
  
  # Return workitem ID
  def wid
    File.basename(File.dirname(@filename))
  end
  
  # Return XML content
  def to_xml
    @doc.to_xml
  end
  
  # Return a list with all field names
  def fields
    @doc.xpath("//field").map{|node| node['id']}.sort
  end
  
  # Return the "space" under which the workitem lives (tracker xor document)
  def space
    if @filename.include?('/.polarion/tracker/')
	  return 'tracker'
	else
	  File.dirname(@filename).split(/\//)[4]
	end
  end
end

end

