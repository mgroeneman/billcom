# -*- encoding: utf-8 -*-
require File.expand_path('../lib/billcom/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sylvain Niles"]
  gem.email         = ["sylvain.niles@gmail.com"]
  gem.description   = %q{A gem for using the bill.com api}
  gem.summary       = %q{It does cool stuff.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "billcom"
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake'
  gem.add_dependency 'httparty'
  gem.add_dependency 'nokogiri'
  gem.version       = Billcom::VERSION
end
