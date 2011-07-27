**Powirb** (*PO*larion *W*ork*I*tems handling with *R*u*B*y) aims to offer a Ruby interface to [Polarion ALM](http://www.polarion.com/)&trade; workitems content, for fast manipulation.


# Installation

    $ gem install powirb

  
# Intro

Often when using Polarion ALM you refine (and redefine) step-by-step your process, or perhaps you need a fine-tune over the way you defines work items, workflows and so and so. Other time you need to import data from other tools and - again - you need an adjustment on some workitems (eg: author name, status, external references, etc).

I've fonud extremely valuable and fast to do all this operation in [CLI](http://en.wikipedia.org/wiki/Command-line_interface) with ruby.


# Examples

First, we need a working copy of the project repository. Usually this live under something like  http://yourpolarionserver/repo/ProjectName

Only basic operation on workitems are implemented, see the example above:

	#!/usr/bin/env ruby

	require 'rubygems'
	require 'powirb'

	# Set a logger level, on a specified filename (default is STDOUT)
	Powirb.set_logger(:debug, 'log.txt')

	# this referes to a project working copy of the subversion repository
	h = Powirb::Handler.new('./SampleProject')
	# now the handler has loaded all workitems data in memory (very fast)

	# we can access a particular workitem with its "wid"
	wi = h.workitems['WI-1234']
	
	# or by and AND'ed set of conditions, eg: all closed requirements
	h.workitems(:type => 'requirements', :status => 'closed').each do |wid,wi|
	  puts "#{wid} - #{wi[:title]}"
      wi[:resolution] = 'done'
	  wi.save!
	end

Please, *remember*: In order to "save" the modification we have to hit a subsequent *commit* with subversion.


# Notes

* Powirb can't create new workitems, only updating on existing ones is allowed
* it does **not** support the "old" *LiveDoc* technology, but it's ok with the new one
* the only fields you can change are "string/text" (more work have to be done here!)
* the actual version was tested under Linux and Mac OS X only


# Author

**Powirb** is written by [Carlo Pecchia](mailto:info@carlopecchia.eu) and released under the terms of Apache License (see LICENSE file).

----
