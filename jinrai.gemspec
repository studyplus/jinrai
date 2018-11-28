$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "jinrai/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jinrai"
  s.version     = Jinrai::VERSION
  s.authors     = ["atomiyama"]
  s.email       = ["akifumi.tomiyama@studyplus.jp"]
  s.homepage    = "https://github.com/studyplus/jinrai"
  s.summary     = "Summary of Jinrai."
  s.description = "Description of Jinrai."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
end
