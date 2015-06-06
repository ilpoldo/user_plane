ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'

require 'fabrication'
require 'timecop'
require 'pry'

require 'generator_spec'

Capybara.javascript_driver = :poltergeist

Rails.backtrace_cleaner.remove_silencers!
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.infer_spec_type_from_file_location!
end

RSpec::Rails::RoutingExampleGroup.include Rails.application.routes.url_helpers
RSpec::Rails::ControllerExampleGroup.include Rails.application.routes.url_helpers
Rails.configuration.action_mailer.default_url_options = {host: 'example.com' }