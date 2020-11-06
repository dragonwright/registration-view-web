module RegistrationView
  module Web
    class Command
      class AccessControl
        def initialize(app)
          @app = app
        end

        def call(env)
          response = @app.(env)

          headers = response[1]
          headers["Access-Control-Expose-Headers"] = "Location"

          response
        end
      end
    end
  end
end
