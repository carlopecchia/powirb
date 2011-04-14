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

  # Create a new instance of a workitem belonging to its representation 
  # in the standard way Polarion does it
  def initialize(filename)
    @filename = filename
  	Powirb.log.debug("Initializing workitem with #{filename}")
  end
  
  # Read workitem content
  def read
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
    fname = fname.to_s
    if self[fname].nil?
	    # inserting new field
	    Powirb.log.debug("[#{wid}] adding new field '#{fname}' with value '#{fvalue}'")
	    @doc.xpath('//field[@id="type"]').last.add_next_sibling("\n    <field id=\"#{fname}\">#{fvalue}</field>")
    else
	    if fvalue.nil?
	      # removing existing field
		    Powirb.log.debug("[#{wid}] removing field '#{fname}'")
		    @doc.xpath("//field[@id=\"#{fname}\"]").last.remove
	    else
	      # updating existing field
		    Powirb.log.debug("[#{wid}] updating field '#{fname}' with value '#{fvalue}'")
	      e = @doc.xpath("//field[@id=\"#{fname}\"]").last
	      e.content = fvalue
	    end
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
end

end

