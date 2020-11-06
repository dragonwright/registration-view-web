module RegistrationView
  module Web
    class Middleware
      def initialize(app)
        @app = app
        @registration_application = Application.build
      end

      def call(env)
        response = @registration_application.(env)

        if response.nil?
          return @app.(env)
        end

        response
      end
    end
  end
end
