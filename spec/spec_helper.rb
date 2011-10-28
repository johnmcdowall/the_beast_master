require 'simplecov'
SimpleCov.start

require File.join(File.dirname(__FILE__), '../app/', 'thebeastmaster.rb')
require File.join(File.dirname(__FILE__), '../lib/', 'the_beast_master_config')

require 'rubygems'
require 'sinatra'
require 'rack/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |configuration|
  include Rack::Test::Methods

  configuration.mock_with :mocha
  configuration.after :each do
    clear_uploaded_files!
    remove_environments!
  end

  TheBeastMasterConfig.set_environment settings.environment

  def app
    @app ||= Sinatra::Application
  end

  def uploaded_files
    Dir["#{TheBeastMasterConfig[:release_db_path]}/**/*.*"]
  end

  def environment_directories
    envs = Dir.entries("#{TheBeastMasterConfig[:release_db_path]}")
    envs.delete "."
    envs.delete ".."
    envs
  end

  def remove_environments!
    environment_directories.each do |f| 
      base = File.join( Dir.pwd, TheBeastMasterConfig[:release_db_path] )
      path = File.join( base, f )
      FileUtils.rm_rf( path )
    end
  end

  def clear_uploaded_files!
    uploaded_files.each { |f| FileUtils.rm(f) }
  end

  def should_create_a_directory_in_release_db directory
    base_path = ReleaseDb.release_db_path
    environment_dir = File.join( base_path, directory)
    File.directory?(environment_dir).should be_true 
  end

end



