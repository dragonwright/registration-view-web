module RegistrationView
  module Web
    class Application
      include Router

      def self.build
        instance = new
        instance
      end

      route do |r|
        r.root do
          [200, {"Content-Type" => "text/html"}, ["Hello, world!"]]
        end
      end
    end
  end
end
