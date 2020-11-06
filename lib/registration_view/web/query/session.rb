module RegistrationView
  module Web
    class Query
      class Session < ViewData::Postgres::Session
        settings.each do |setting_name|
          setting setting_name
        end

        def self.build(settings: nil)
          registration_settings = RegistrationView::Web::Settings.instance
          view_data_settings = registration_settings.data.dig("registration_view_web", "view_data_pg")

          settings = Settings.build(view_data_settings)

          super(settings: settings)
        end
      end
    end
  end
end
