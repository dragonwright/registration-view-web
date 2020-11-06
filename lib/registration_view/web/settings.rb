module RegistrationView
  module Web
    class Settings < ::Settings
      def self.instance
        @instance ||= build
      end

      def self.data_source
        Defaults.data_source
      end

      def self.names
        [
          :registration_view_web
        ]
      end

      module Defaults
        def self.data_source
          ENV['REGISTRATION_VIEW_WEB_SETTINGS_PATH'] || 'settings/registration_view_web.json'
        end
      end
    end
  end
end
