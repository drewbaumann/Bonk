# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'resque/server'

AUTH_PASSWORD = 'gsy'
if AUTH_PASSWORD
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == AUTH_PASSWORD 
  end
end

run Rack::URLMap.new \
  "/"       => Bonk::Application,
  "/resque2140" => Resque::Server.new