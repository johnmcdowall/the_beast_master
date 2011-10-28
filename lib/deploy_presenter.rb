class DeployPresenter

  def has_environments?
    not ReleaseDb.list_environments == []
  end

  def get_environment_list
    environments = ReleaseDb.list_environments
  end

  def format_environment env
    env.capitalize
  end

  def get_releases_for_environment env
    ReleaseDb.get_all_latest_releases_for env
  end

end