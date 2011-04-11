
Gem::Specification.new do |s|
  s.name              = "powirb"
  s.version           = "1.0"
  s.summary           = "POlarion WorkItems handling with RuBy"
  s.description		  = <<-EOF
  Ruby interface to Polarion workitems content, for fast manipulation.
EOF
  s.authors           = ["Carlo Pecchia"]
  s.email             = ["info@carlopecchia.eu"]
  s.homepage          = "http://github.com/carlopecchia/powirb"
  s.add_dependency('nokogiri')
  s.files = ["LICENSE", "README.markdown", "Rakefile", "lib/powirb.rb", "lib/powirb/version.rb", "lib/powirb/workitem.rb", "lib/powirb/handler.rb", "powirb.gemspec", "test/test_helper.rb", "test/test_powirb_workitem.rb", "test/test_powirb.rb", "test/test_powirb_handler.rb"]
end

