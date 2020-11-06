module RegistrationView
  module Web
    class Authorization
      include ::Settings::Setting

      setting :command_input_namespace
      setting :query_payload_namespace
      setting :secret
      setting :issuer
      setting :audience

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :authorization_settings
        registration_settings = Settings.instance
        instance = new
        registration_settings.set(instance, "registration_view_web", "authorization")
        receiver.public_send("#{attr_name}=", instance)
      end
    end
  end
end
