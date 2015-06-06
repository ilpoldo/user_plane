module UserPlane
  class Engine < ::Rails::Engine
    isolate_namespace UserPlane

    config.generators do |g|
      g.test_framework      :rspec,       :fixture => false
      g.fixture_replacement :fabrication, :dir => 'spec/fabricators'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer  :'user_plane.controller_concern' do
      ActiveSupport.on_load(:action_controller) do
        include SessionManagerConcern
      end
    end

  end
end
