require 'faker'

Fabrication.configure do |config|
  config.fabricator_path = "fabricators"
  config.path_prefix = File.expand_path('../..', __FILE__)
  config.sequence_start = 10000
end