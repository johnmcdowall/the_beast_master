require "the_beast_master_config"

module ReleaseDb

  def self.remove_parents_and_sort dirs
    return if dirs.nil?
    dirs.delete "."
    dirs.delete ".."
    dirs.sort
  end

  def self.release_db_path   
    File.join( Dir.pwd, TheBeastMasterConfig[:release_db_path] )
  rescue Errno::ENOENT
    ensure_release_db_exists
    File.join( Dir.pwd, TheBeastMasterConfig[:release_db_path] )
  end

  def self.ensure_release_db_exists
    Dir.mkdir( release_db_path ) if not File.directory?(release_db_path)
  end

  def self.list_environments
    ensure_release_db_exists
    remove_parents_and_sort( Dir.entries( release_db_path ) )
  end

  def self.environment_exists?(environment)
    File.directory?(get_environment_path(environment))
  end

  def self.project_exists_in_environment?(environment, project)
    raise Exception.new("Environment #{environment} does not yet exist.") if not environment_exists?(environment)
    File.directory?( get_project_path_in_environment(environment, project))
  end

  def self.create_environment environment
    ensure_release_db_exists
    Dir.mkdir( get_environment_path environment ) if not environment_exists? environment
  end

  def self.create_project_in environment, project_name
    raise Exception.new ("Environment #{environment} does not yet exist.") if not environment_exists?(environment)
    Dir.mkdir( get_project_path_in_environment( environment, project_name ) ) if not project_exists_in_environment?( environment, project_name )
  end

  def self.create_deployer_in environment, project, deployer
    Dir.mkdir( get_deployer_path( environment, project, deployer ) ) if not deployer_exists_in( environment, project, deployer )
  end

  def self.get_environment_path environment
    base_path = ReleaseDb.release_db_path
    environment_dir = File.join( base_path, environment)
  end

  def self.get_project_path_in_environment environment, project
    raise Exception.new ("Environment #{environment} does not yet exist.") if not environment_exists?(environment)
    File.join( get_environment_path(environment), project)    
  end

  def self.get_projects_in environment
    remove_parents_and_sort( Dir.entries( get_environment_path(environment) ) )
  end

  def self.get_deployer_path environment, project, deployer
    project_path = get_project_path_in_environment environment, project
    deployer_path = File.join( project_path, deployer )
  end

  def self.get_latest_path environment, project
    File.join( get_project_path_in_environment( environment, project ), "latest")
  end

  def self.deployer_exists_in environment, project, deployer
    File.directory?( get_deployer_path( environment, project, deployer ) )
  end

  def self.mark_release_for environment, project, deployer, sha
    create_environment( environment )
    create_project_in(  environment, project )
    create_deployer_in( environment, project, deployer )

    deployer_path = File.join( get_deployer_path( environment, project, deployer ), sha )
    File.new(deployer_path, "w+")

    File.open(get_latest_path( environment, project ), "w") { |file|
      file.write( "#{sha} - #{deployer}" )
    }
  end

  def self.release_exists_for? environment, project, deployer, sha
    deployer_path = get_deployer_path( environment, project, deployer )
    Dir.entries( deployer_path ).include? sha
  end

  def self.get_latest_release_for environment, project
    line = []
    File.open(get_latest_path( environment, project ), "r") { |file| 
      line = file.gets + " - " + file.mtime.to_s
    }
    line.split(" - ")
  end

  def self.get_all_latest_releases_for environment
    projects = get_projects_in environment
    latest   = []

    projects.each{ |project|
      details = get_latest_release_for( environment, project )
      latest << [ project, details[0], details[1], details[2]]
    }
    latest
  end

end