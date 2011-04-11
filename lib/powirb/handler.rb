
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
	
	@workitems_count = 0
	self.workitems_paths.each do |path|
	  @workitems_count += Dir[@project_path + path + "/**/workitem.xml"].size
	end
	Powirb.log.debug("Found #{@workitems_count} workitems.")
  end
  
  # Return all workitems in the project
  def workitems
	tmp = []
	self.workitems_paths.each do |path|
	  Dir[@project_path + path + "/**/workitem.xml"].each do |filename|
	    tmp << Workitem.new(filename)
		Powirb.log.debug("Added workitem from #{filename}")
	  end
	end
	tmp
  end
  
  # Return the number of total workitems found in the project
  def workitems_count
    @workitems_count
  end
  
  # Returns the path for workitems in the specified project
  def workitems_paths
    ["/.polarion/tracker/workitems", "/modules/**/workitems"]
  end
end

end

