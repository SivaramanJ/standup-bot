require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module StandupBot
  class Application < Rails::Application
    config.load_defaults 7.1

    config.generators do |g|
      g.orm :active_record
      g.test_framework false
      g.helper false
      g.assets false
    end

    # Allow importing from importmap
    config.importmap.draw_paths << config.root.join("config/importmap.rb") if File.exist?(config.root.join("config/importmap.rb"))
  end
end
