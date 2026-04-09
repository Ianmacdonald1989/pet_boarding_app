require_relative "boot"

require "logger"
require "active_support/logger"

require "rails/all"

module PetBoarding
  class Application < Rails::Application
    config.load_defaults 6.1
  end
end
