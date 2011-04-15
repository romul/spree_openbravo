module Spree
  module Openbravo
    # Singleton class to access the advanced cart configuration object (OpenbravoConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::Openbravo::Config[:foo]                  # Returns the foo preference
    #   Spree::Openbravo::Config[]                      # Returns a Hash with all the google base preferences
    #   Spree::Openbravo::Config.instance               # Returns the configuration object (OpenbravoConfiguration.first)
    #   Spree::Openbravo::Config.set(preferences_hash)  # Set the advanced cart preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess

      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          OpenbravoConfiguration.find_or_create_by_name("Openbravo configuration")
        end
      end
    end
  end
end

