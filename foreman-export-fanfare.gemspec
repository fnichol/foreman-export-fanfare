# -*- encoding: utf-8 -*-
require File.expand_path('../lib/foreman/export/fanfare/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "foreman-export-fanfare"
  gem.require_paths = ["lib"]
  gem.version       = Foreman::Export::Fanfare::VERSION

  gem.add_dependency "foreman"

  gem.add_development_dependency "minitest", "~> 2.11"
  gem.add_development_dependency "mocha", "~> 0.10.5"
end
