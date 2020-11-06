require_relative './init'

class AccessControl
  def initialize(app)
    @app = app
  end

  def call(env)
    response = @app.(env)

    headers = response[1]
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type"

    response
  end
end

class NotFound
  def self.call(env)
    [404, {}, []]
  end
end

use(AccessControl)
use(RegistrationView::Web::Middleware)

run(NotFound)
