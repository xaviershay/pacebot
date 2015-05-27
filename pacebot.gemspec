# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Xavier Shay"]
  gem.email         = ["contact@xaviershay.com"]
  gem.description   =
    %q{CLI for converting and calculating paces.}
  gem.summary   =
    %q{CLI for converting and calculating paces.}
  gem.homepage      = "http://github.com/xaviershay/pacebot"

  gem.executables   = []
  gem.required_ruby_version = '>= 2.0.0'
  gem.files         = Dir.glob("{spec,lib}/**/*.rb") + %w(
                        README.md
                        pacebot.gemspec
                      )
  gem.test_files    = Dir.glob("spec/**/*.rb")
  gem.name          = "pacebot"
  gem.require_paths = ["lib"]
  gem.bindir        = "bin"
  gem.executables  << "pacebot"
  gem.license       = "Apache 2.0"
  gem.version       = "1.0.0"
  gem.has_rdoc      = false
end
