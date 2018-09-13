require 'fastlane/action'
require_relative '../helper/release_version_helper'

module Fastlane
  module Actions
    class RejectVersionAction < Action
      def self.run(params)
        helper = Helper::ReleaseVersionHelper.new(params)
        return helper.reject
      end

      def self.description
        "This action makes it possible to reject a binary in AppStore Connect"
      end

      def self.author
        "Leon Keijzer"
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        [
            "This plug can be used with an IPA file or just the application identifier.",
            "If the IPA is provided the app_identifier is extracted from that."
        ].join(' ')
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :app_identifier,
                                         description: "The bundle identifier of your app",
                                         optional: true,
                                         code_gen_sensitive: true,
                                         default_value_dynamic: true),
            FastlaneCore::ConfigItem.new(key: :app_version,
                                         description: "The version that should be edited or created",
                                         optional: true),
            FastlaneCore::ConfigItem.new(key: :ipa,
                                         optional: true,
                                         env_name: "DELIVER_IPA_PATH",
                                         description: "Path to your ipa file",
                                         code_gen_sensitive: true,
                                         default_value_dynamic: true,
                                         verify_block: proc do |value|
                                           UI.user_error!("Could not find ipa file at path '#{File.expand_path(value)}'") unless File.exist?(value)
                                           UI.user_error!("'#{value}' doesn't seem to be an ipa file") unless value.end_with?(".ipa")
                                         end,
                                         conflict_block: proc do |value|
                                           UI.user_error!("You can't use 'ipa' and '#{value.key}' options in one run.")
                                         end),
            FastlaneCore::ConfigItem.new(key: :platform,
                                         env_name: "DELIVER_PLATFORM",
                                         description: "The platform to use (optional)",
                                         optional: true,
                                         default_value: "ios",
                                         verify_block: proc do |value|
                                           UI.user_error!("The platform can only be ios, appletvos, or osx") unless %('ios', 'appletvos', 'osx').include?(value)
                                         end),
            #Login credentials
            FastlaneCore::ConfigItem.new(key: :username,
                                         env_name: "DELIVER_USERNAME",
                                         description: "Your Apple ID Username",
                                         default_value: ENV["DELIVER_USER"],
                                         default_value_dynamic: true),
            # internal
            FastlaneCore::ConfigItem.new(key: :app,
                                         short_option: "-p",
                                         env_name: "DELIVER_APP_ID",
                                         description: "The (spaceship) app ID of the app you want to use/modify",
                                         optional: true,
                                         is_string: false) # don't add any verification here, as it's used to store a spaceship ref
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include? platform
        true
      end
    end
  end
end
