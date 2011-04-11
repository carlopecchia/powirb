**Powirb** (*PO*larion *W*ork*I*tems handling with *R*u*B*y) aims to offer a Ruby interface to [Polarion ALM](http://www.polarion.com/)&trade; workitems content, for fast manipulation.


# Installation

    $ gem install powirb

  
# Intro

Often when using Polarion ALM and you refine (and redefine) step-by-step you process, or perhaps you need a fine-tune over the way you defines wor items the workflows and so and so. Other time you need to import data from other tools and - again - you need an adjustment on some workitems (eg: author name, status, etc).

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

	h.workitems.each do |wi|
	  if  wi['status'] == 'closed' and wi[:type] == 'action'
	    wi[:resolution] = 'done'
	    wi.save!
	  end
	end

Please, *remember*: In order to "save" the modification we have to hit a commit with subversion.


# Notes

* it does work with Polarion 2011
* it does **not** support the "old" *LiveDoc* technology
* the actual version was tested under Linux and Mac OS X only


# Author

**Powirb** is written by [Carlo Pecchia](mailto:info@carlopecchia.eu) and released under the terms of Apache License (see LICENSE file).


----


