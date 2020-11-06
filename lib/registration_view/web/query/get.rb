module RegistrationView
  module Web
    class Query
      class Get
        include Dependency

        dependency :session, Session
        dependency :get_one, ViewData::Postgres::Get::One

        def self.configure(receiver, attr_name: nil)
          attr_name ||= :get_registration
          instance = build
          receiver.public_send("#{attr_name}=", instance)
        end

        def self.build
          instance = new
          instance.configure
          instance
        end

        def configure
          Session.configure(self)
          ViewData::Postgres::Get::One.configure(self, session: session)
        end

        def call(registration_id)
          query = ViewData::Postgres::Query.new
          query.name = 'registrations'
          query.statement = sql_statement
          query.parameters = [registration_id]

          get_one.(query, message_class: Tuple)
        end

        def sql_statement
          <<~SQL.chomp
            SELECT
              is_email_rejected,
              is_registered
            FROM registrations
            WHERE registration_id = $1::uuid
          SQL
        end

        class Tuple
          include Schema::DataStructure

          attribute :is_email_rejected, Boolean
          attribute :is_registered, Boolean
        end
      end
    end
  end
end
