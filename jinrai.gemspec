$:.push File.expand_path("lib", __dir__)

require "jinrai/version"

Gem::Specification.new do |s|
  s.name        = "jinrai"
  s.version     = Jinrai::VERSION
  s.authors     = ["atomiyama"]
  s.email       = ["akifumi.tomiyama@studyplus.jp"]
  s.homepage    = "https://github.com/studyplus/jinrai"
  s.summary     = "A cursor based pagination plugin for Rails"
  s.description = "Jinrai is a awesome Cursor based pagination Link."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 7.0"
  s.add_dependency "psych"
  s.add_dependency "sprockets-rails"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry-byebug"
end
