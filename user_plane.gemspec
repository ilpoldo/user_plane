$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "user_plane/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_plane"
  s.version     = UserPlane::VERSION
  s.authors     = ["Leandro Pedroni"]
  s.email       = ["ilpoldo@gmail.com"]
  s.homepage    = "https://github.com/ilpoldo/user_plane"
  s.summary     = "User component for Rails applications."
  s.description = "User component for Rails applications."
  s.license     = "MIT"

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'bcrypt'
  s.add_dependency 'imperator'
  s.add_dependency 'email_validator'
  s.add_dependency 'support_segment'
  s.add_dependency 'omniauth-github'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-twitter'


  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-email'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'poltergeist'

  
  s.add_development_dependency 'brainsome_jasminerice'

  s.add_development_dependency 'fabrication-rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'timecop'

  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'thor' # Undeclared dependency of guard
  s.add_development_dependency 'guard-jasmine'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-doc'
  s.add_development_dependency 'pry-rescue'
  s.add_development_dependency 'pry-byebug'

  s.test_files = Dir["spec/**/*"]
end
