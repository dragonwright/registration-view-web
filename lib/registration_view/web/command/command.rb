module RegistrationView
  module Web
    class Command
      include Dependency

      FIVE_MINUTES = 5 * 60

      attr_reader :authorization_settings

      dependency :session, Session
      dependency :register, Registration::Client::Register
      dependency :identifier, Identifier::UUID::Random

      def initialize(authorization_settings)
        @authorization_settings = authorization_settings
      end

      def self.configure(receiver, authorization_settings, attr_name: nil)
        attr_name ||= :registration_command
        instance = build(authorization_settings)
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.build(authorization_settings)
        instance = new(authorization_settings)
        instance.configure
        instance
      end

      def configure
        Session.configure(self)
        Registration::Client::Register.configure(self, session: session)
        Identifier::UUID::Random.configure(self)
      end

      def call(env)
        command_input_namespace = authorization_settings.command_input_namespace
        issuer = authorization_settings.issuer
        audience = authorization_settings.audience
        secret = authorization_settings.secret

        input = env[command_input_namespace]

        registration_id = input["registration_id"]
        player_email_address_claim_id = identifier.get
        player_id = identifier.get
        email_address = input["email_address"]

        register.(
          registration_id: registration_id,
          player_email_address_claim_id: player_email_address_claim_id,
          player_id: player_id,
          email_address: email_address
        )

        request = Rack::Request.new(env)
        now = Time.now.to_i

        payload = {
          "exp" => now + FIVE_MINUTES,
          "iat" => now,
          "iss" => issuer,
          "aud" => audience,
          "sub" => registration_id
        }

        token = JWT.encode(payload, secret, "HS256")

        headers = {
          "Content-Type" => "application/json",
          "Location" => request.url
        }

        body = {
          "token": token
        }.to_json

        [202, headers, [body]]
      end
    end
  end
end
