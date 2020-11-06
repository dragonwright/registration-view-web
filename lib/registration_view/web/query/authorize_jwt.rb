module RegistrationView
  module Web
    class Query
      class AuthorizeJWT
        attr_reader :settings

        def initialize(app, settings)
          @app = app
          @settings = settings
        end

        def call(env)
          issuer = settings.issuer
          audience = settings.audience
          secret = settings.secret
          query_payload_namespace = settings.query_payload_namespace

          options = {
            :algorithm => "HS256",
            :iss => issuer,
            :aud => audience,
            :verify_iss => true,
            :verify_aud => true
          }
          token = env.fetch("HTTP_AUTHORIZATION", "").slice(7..-1)
          payload, header = JWT.decode(token, secret, true, options)

          registration_id = payload.dig("sub")

          env.update(query_payload_namespace => registration_id)

          @app.(env)
        rescue JWT::ExpiredSignature
          error_response(403, "The token has expired.")
        rescue JWT::DecodeError
          error_response(401, "The token is not valid.")
        end

        def error_response(status, message)
          body = {
            "error" => message
          }.to_json
          header = { "Content-Type" => "application/json" }
          Rack::Response.new(body, status, header).finish
        end
      end
    end
  end
end
