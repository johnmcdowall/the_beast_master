require 'rubygems'
require 'sinatra'

# add lib dir to load path
$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), 'lib')

# Sinatra defines #set at the top level as a way to set application configuration
set :views, File.join(File.dirname(__FILE__), 'app','views')
set :release_db_path, File.join(File.dirname(__FILE__), 'release_db')
set :run, false
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)

require './app/thebeastmaster'  
TheBeastMasterConfig.set_environment settings.env

run Sinatra::Application