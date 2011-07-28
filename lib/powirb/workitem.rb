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
  
  # Set/remove a field
  def []=(fname, fvalue)
    # NOTE: only string/text field can be set/updated
    fname = fname.to_s
    if self[fname].nil?
	  # inserting new field
	  Powirb.log.debug("[#{wid}] adding new field '#{fname}' with value '#{fvalue}'")
	  if fvalue.instance_of?(Hash)
	    value = fvalue[:value]
		type  = fvalue[:type]
	    @doc.xpath('//field[@id="type"]').last.add_next_sibling("\n    <field id=\"#{fname}\" type=\"#{type}\">#{value}</field>")
	  else
	    @doc.xpath('//field[@id="type"]').last.add_next_sibling("\n    <field id=\"#{fname}\">#{fvalue}</field>")
	  end
	  # NOTE: we are sure that the 'type' field exists, so we add XML node after that one
    else
	  if fvalue.nil?
	    # remove existing field
		Powirb.log.debug("[#{wid}] removing field '#{fname}'")
		@doc.xpath("//field[@id=\"#{fname}\"]").last.remove
	  else
	    # update existing field
		Powirb.log.debug("[#{wid}] updating field '#{fname}' with value '#{fvalue}'")
        e = @doc.xpath("//field[@id=\"#{fname}\"]").last
        if fvalue.instance_of?(Hash)
	      value = fvalue[:value]
		  type  = fvalue[:type]
		  e['type'] = type
	    end		
	    e.content = fvalue
	  end
	end
	# NOTE: this method need some refactoring... :(
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

