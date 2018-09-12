require 'fastlane/action'
require_relative '../helper/release_version_helper'

module Fastlane
  module Actions
    class ReleaseVersionAction < Action
      def self.run(params)
        UI.message("The release_version plugin is working!")
      end

      def self.description
        "This plugin makes it possible to release an already approved version in AppStore Connect"
      end

      def self.author
        "Leon Keijzer"
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                     description: "The bundle identifier of your app",
                                     optional: false,
                                     code_gen_sensitive: true,
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier),
                                     default_value_dynamic: true),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                     description: "The version that should be released",
                                     optional: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:ios].include?(platform)
        true
      end
    end
  end
end
