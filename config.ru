require_relative './init'

class NotFound
  def self.call(env)
    [404, {}, []]
  end
end

use(RegistrationView::Web::Middleware)

run(NotFound)
