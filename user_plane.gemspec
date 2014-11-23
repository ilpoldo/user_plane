$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "user_plane/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_plane"
  s.version     = UserPlane::VERSION
  s.authors     = ["Leandro Pedroni"]
  s.email       = ["ilpoldo@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "User component set for Rails applications."
  s.description = "TODO: Description of UserPlane."
  s.license     = "MIT"

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.1.8'
  s.add_dependency 'omniauth-github'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-twitter'


  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'capybara'

  
  s.add_development_dependency 'jasminerice'

  s.add_development_dependency 'fabrication-rails'
  s.add_development_dependency 'timecop'

  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-jasmine'

  s.test_files = Dir["spec/**/*"]
end
