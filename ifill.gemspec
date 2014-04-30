# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ifill/version'

Gem::Specification.new do |gem|
  gem.name          = "ifill"
  gem.version       = Ifill::VERSION
  gem.authors       = ["Derek Willis"]
  gem.email         = ["dwillis@gmail.com"]
  gem.description   = %q{Thin Ruby wrapper for the Compilation of Presidential Documents}
  gem.summary       = %q{Official publications of materials released by the White House Press Secretary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.required_rubygems_version = ">= 1.3.6"
  gem.rubyforge_project         = "ifill"
  gem.add_runtime_dependency "json"
  
  gem.add_dependency "oj"
  
  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "minitest"
  
end
