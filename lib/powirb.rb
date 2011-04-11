
$:.unshift(File.dirname(__FILE__))

Dir.glob(File.join('..','vendor','gems','*','lib')).each do |lib|
  $:.unshift(File.expand_path(lib))
end

require 'powirb/workitem'
require 'powirb/handler'
require 'logger'

# This module represent a container for Powirb classes.
#
# Author:: Carlo Pecchia (mailto:info@carlopecchia.eu)
# Copyright:: Copyright (c) 2011 Carlo Pecchia
# License:: See LICENSE file
module Powirb

  # Set the logger used for all classes under Powirb module.
  #
  # +level+ debug, info, warn (default), error, fatal
  #
  # +filename+ if not specified STDOUT is used
  def self.set_logger(level, filename=STDOUT)
    @logger = Logger.new(filename)
	@logger.datetime_format = "%Y-%m-%d %H:%M:%S"
	@logger.level = case level.to_s
	  when 'debug'
		Logger::DEBUG
	  when 'info'
		Logger::INFO
	  when 'warn'
		Logger::WARN
	  when 'error'
		Logger::ERROR
	  when 'fatal'
		Logger::FATAL
	  else
	    Logger::WARN
	end	
  end
  
  # we have to provide a default logger
  self.set_logger(:warn)
  
  # Provide access to internal Logger instance.
  # Usual classes are used: fatal, error, warn, info, debug
  #
  # eg: <tt>Powirb.log.warn("message here...")</tt>
  def self.log
    @logger
  end
end