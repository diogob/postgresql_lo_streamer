$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "postgresql_lo_streamer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "postgresql_lo_streamer"
  s.version     = PostgresqlLoStreamer::VERSION
  s.authors     = ["Diogo Biazus"]
  s.email       = ["diogo@biazus.me"]
  s.homepage    = "https://github.com/diogob/postgresql_lo_streamer"
  s.summary     = "A Rails engine to stream PostgreSQL Large Objects to clients"
  s.description = "A simple engine of one controller that will use PostgreSQL LO interface and retrieve a large object by its oid."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.2.8"

  s.add_development_dependency "rspec-rails", "~> 2.11.0"
  s.add_development_dependency "pg"
end
