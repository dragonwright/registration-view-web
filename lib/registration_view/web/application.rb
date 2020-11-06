module RegistrationView
  module Web
    class Application
      include Router
      include Dependency

      dependency :authorization_settings, Authorization
      dependency :registration_command, Command
      dependency :registration_query, Query

      def self.build
        instance = new
        instance.configure
        instance
      end

      def configure
        Authorization.configure(self)
        Command.configure(self, authorization_settings)
        Query.configure(self, authorization_settings)
      end

      route do |r|
        r.is do
          r.options do
            [204, { "Allow" => "OPTIONS, GET, POST" }, []]
          end

          r.post do
            handler = registration_command
            command_input_namespace = authorization_settings.command_input_namespace

            app = Rack::Builder.new do
              use(Command::AccessControl)
              use(Rack::JSONBodyParser, command_input_namespace)
              use(Command::ValidateParameters, command_input_namespace)
              run(handler)
            end

            r.run(app)
          end

          r.get do
            handler = registration_query
            settings = authorization_settings

            app = Rack::Builder.new do
              use(Query::AuthorizeJWT, settings)
              run(handler)
            end

            r.run(app)
          end
        end
      end
    end
  end
end
