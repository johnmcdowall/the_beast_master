class ReleasePresenter

  def initialize( data )
    @data = data
  end

  def get_release_project
    @data[0].upcase
  end

  def get_release_date
    Time.parse(@data[3]).strftime('%A, %e %B %G')
  end

  def get_release_time
    Time.parse(@data[3]).strftime('%H:%M:%S')
  end

  def get_release_github_url
    "#{TheBeastMasterConfig[:github_base_url]+get_release_project+"/commit/"+@data[1]}"
  end

  def get_release_sha
    @data[1].downcase[0..7]
  end

  def get_release_deployer
    "-by " + @data[2]
  end

end