require 'fastlane_core/ui/ui'
require 'spaceship/tunes/application'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?('UI')

  module Helper
    class ReleaseVersionHelper
      attr_accessor :options

      def initialize(config)
        require 'deliver'
        self.options = config

        # Check requirements
        has_data = (options[:app_identifier].to_s.length != 0 && options[:app_version].to_s.length != 0)
        has_app = (options[:ipa].to_s.length != 0)
        if !has_data && !has_app
          UI.error("You need to provide an app_identifier and an app_version or a path to an IPA file")
          return
        end

        # Logging into AppStore Connect
        login

        # Get app identifier
        UI.message("Getting app identifier")
        Deliver::DetectValues.new.find_app_identifier(options)
        if options[:app_identifier].to_s.length != 0
          UI.success("Found application identifier: #{options[:app_identifier]}")
        else
          UI.error("Could not find an app_identifier")
        end

        # Get app version
        UI.message("Getting app version")
        Deliver::DetectValues.new.find_version(options)
        if options[:app_version].to_s.length != 0
          UI.success("Found application version: #{options[:app_version]}")
        else
          UI.error("Could not find an app_version")
        end

        # Get applications
        UI.message("Find app from AppStore Connect")
        Deliver::DetectValues.new.find_app(options)
      end

      def login
        UI.message("Login to App Store Connect (#{options[:username]})")
        Spaceship::Tunes.login(options[:username])
        Spaceship::Tunes.select_team
        UI.message("Login successful")
      end

      # Try to release the application
      def release
        app = options[:app]
        if app != nil
          begin
            app.release!
          rescue
            UI.error("Failed to release application.")
          else
            UI.success("Successfully released the application")
          end
        end
      end

      # Try to reject the application
      def reject
        app = options[:app]
        if app != nil
          if app.reject_version_if_possible!
            UI.success("Successfully rejected previous version!")
          else
            UI.error("Application cannot be rejected")
          end
        end
      end
    end
  end
end


