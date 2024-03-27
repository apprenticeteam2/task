require 'rack/session'
require_relative 'db_config'
require_relative 'web_app'
require_relative 'task_api'

use Rack::Static,
  urls: ['/images', '/js', '/css']

use Rack::Session::Cookie,
  key: 'taskapp.session',
  path: '/',
  secret: '3e1499aaf168aed3eff37344fe4857ca20c11ecab912f9757f84358a7a4c452c276c6ce0acab7ee0273daf2e72603870aa0349d0dd81ae15ee5ea08afb3d3cbc'

class API < Grape::API
  mount WebApp
  mount TaskAPI
end

run API