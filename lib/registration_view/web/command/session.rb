module RegistrationView
  module Web
    class Command
      class Session < ::MessageStore::Postgres::Session
        settings.each do |setting_name|
          setting setting_name
        end

        def self.build(settings: nil)
          registration_settings = RegistrationView::Web::Settings.instance
          message_store_settings = registration_settings.data.dig("registration_view_web", "message_store")

          settings = Settings.build(message_store_settings)

          super(settings: settings)
        end
      end
    end
  end
end
