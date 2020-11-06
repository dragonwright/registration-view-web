module RegistrationView
  module Web
    class Query
      include Dependency

      attr_reader :registration_settings

      dependency :get_registration, Get

      def initialize(registration_settings)
        @registration_settings = registration_settings
      end

      def self.configure(receiver, registration_settings, attr_name: nil)
        attr_name ||= :registration_query
        instance = build(registration_settings)
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.build(registration_settings)
        instance = new(registration_settings)
        instance.configure
        instance
      end

      def configure
        Get.configure(self)
      end

      def call(env)
        registration_id = env[registration_settings.query_payload_namespace]

        registration = get_registration.(registration_id)

        if registration.nil?
          return error_response
        end

        unless registration.is_email_rejected || registration.is_registered
          return error_response
        end

        headers = {
          "Content-Type" => "application/json"
        }

        body = {
          "is_email_rejected" => registration.is_email_rejected,
          "is_registered" => registration.is_registered
        }.to_json

        [200, headers, [body]]
      end

      def error_response
        body = { "error" => "Registration is not available." }.to_json
        header = { "Content-Type" => "application/json" }
        Rack::Response.new(body, 404, header).finish
      end
    end
  end
end
