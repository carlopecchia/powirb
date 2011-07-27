
module Powirb

# This class represent the workitems handler, that is an "iterator"
# over workitems in the same projects.
#
# Author:: Carlo Pecchia (mailto:info@carlopecchia.eu)
# Copyright:: Copyright (c) 2011 Carlo Pecchia
# License:: See LICENSE file
class Handler
  attr_reader :project_path

  # Initialize the handler with the project path (usually a subversion
  # working copy)
  def initialize(project_path)
  	unless File.exist?(project_path)
	  msg = "Invalid project path '#{project_path}'"  
	  Powirb.log.error(msg)
	  raise msg
	end
    @project_path = project_path
	Powirb.log.debug("Initialized handler for #{@project_path}")
	
	@space = {}
	self.workitems_paths.each do |path|
      Dir[File.join(@project_path, path, "/**/workitem.xml")].each do |filename|
	    wid = File.dirname(filename).split(/\//).last
        @space[wid] = Workitem.new(filename)
        Powirb.log.debug("Added workitem from #{filename}")
      end
	end
	Powirb.log.debug("Found #{@space.keys.size} workitems.")
  end

  # Return all workitems in the project
  def workitems(conds=nil)
    return @space  if conds.nil?
	# Return only workitems for which *all* specified conditions are true
	@space.select do |wid,wi|
	  conds.map{|k,v| wi[k] == v}.reduce(:&)
	end
  end
  
  # Returns the path for workitems in the specified project
  def workitems_paths
    [ File.join('.polarion', 'tracker', 'workitems'),
      File.join('modules', '**', 'workitems') ]
  end
end

end

