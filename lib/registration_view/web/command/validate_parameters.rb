module RegistrationView
  module Web
    class Command
      class ValidateParameters
        REGISTRATION_ID_INPUT = "registration_id"
        EMAIL_ADDRESS_INPUT = "email_address"

        UUID_REGEXP = /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i

        def initialize(app, namespace)
          @app = app
          @namespace = namespace
        end

        def call(env)
          input = env[@namespace]
          errors = Hash.new { |hash, key| hash[key] = [] }

          registration_id = input.dig(REGISTRATION_ID_INPUT)
          email_address = input.dig(EMAIL_ADDRESS_INPUT)

          if registration_id.nil?
            errors[REGISTRATION_ID_INPUT] << "Registration ID may not be blank."
          end

          unless registration_id.nil? || registration_id =~ UUID_REGEXP
            errors[REGISTRATION_ID_INPUT] << "Registration ID must be valid."
          end

          if email_address.nil?
            errors[EMAIL_ADDRESS_INPUT] << "Email Address may not be blank."
          end

          unless email_address.nil? || email_address =~ URI::MailTo::EMAIL_REGEXP
            errors[EMAIL_ADDRESS_INPUT] << "Email Address must be valid."
          end

          if !errors.empty?
            body = errors.to_json
            header = { "Content-Type" => "application/json" }
            return Rack::Response.new(body, 400, header).finish
          end

          @app.(env)
        end
      end
    end
  end
end
