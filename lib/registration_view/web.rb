require 'rack'
require 'rack/json_body_parser'
require 'router'
require 'view_data/postgres'
require 'dependency'
require 'identifier/uuid'
require 'settings'
require 'json'
require 'jwt'

require 'registration/client'

require 'registration_view/web/settings'
require 'registration_view/web/authorization'

require 'registration_view/web/command/access_control'
require 'registration_view/web/command/validate_parameters'
require 'registration_view/web/command/settings'
require 'registration_view/web/command/session'
require 'registration_view/web/command/command'

require 'registration_view/web/query/authorize_jwt'
require 'registration_view/web/query/settings'
require 'registration_view/web/query/session'
require 'registration_view/web/query/get'
require 'registration_view/web/query/query'

require 'registration_view/web/application'
require 'registration_view/web/middleware'
