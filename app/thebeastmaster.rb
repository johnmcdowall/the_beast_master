require 'sinatra'
require 'release_db'
require 'deploy_presenter'
require 'release_presenter'

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="The Beast Master challenges you. Show yourself!")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [TheBeastMasterConfig[:auth_username], TheBeastMasterConfig[:auth_password]]
  end

  def constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def present(object, data = nil)
    klass ||= constantize( "#{object.to_s.capitalize}Presenter" )
    presenter = klass.new(data)
    yield presenter if block_given?
    presenter
  end
end

get '/' do
  protected! if TheBeastMasterConfig[:use_auth]
  haml :index
end

post '/mark_release' do
  protected! if TheBeastMasterConfig[:use_auth]

  environment = params[:env].downcase
  project     = params[:project].downcase
  sha         = params[:sha].downcase
  whom        = params[:whom].downcase

  if environment.length > 100 || project.length > 100 || sha.length > 40 || whom.length > 30
    halt 500, "Environments, projects must be less than 100 chars long, sha less than or equal to 40, and whom less than 30."
  end

  if environment.include?(" ") || project.include?(" ")  || sha.include?(" ")  || whom.include?(" ") 
    halt 500, "No spaces allowed in environments, projects, whom or sha."
  end

  ReleaseDb.mark_release_for( environment, project, whom, sha )
  [200, "Release marked."]
end
