# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.name = 'registration_view-web'
  spec.version = '0.0.0'
  spec.summary = 'Registration View Web'
  spec.description = ' '

  spec.authors = ['Joseph Choe']
  spec.email = ['joseph@josephchoe.com']
  spec.homepage = 'https://github.com/dragonwright/registration-view-web'

  spec.require_paths = ['lib']
  spec.files = Dir.glob('{lib}/**/*')
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency 'jwt'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'rack-json_body_parser'
  spec.add_runtime_dependency 'router'
  spec.add_runtime_dependency 'view_data-postgres'

  spec.add_runtime_dependency 'evt-dependency'
  spec.add_runtime_dependency 'evt-identifier-uuid'
  spec.add_runtime_dependency 'evt-settings'

  spec.add_runtime_dependency 'registration-client'

  spec.add_development_dependency 'test_bench'
end
