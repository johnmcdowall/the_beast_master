require 'spec_helper'

describe ReleasePresenter do

  let(:data) { ["project_name", "d34ac3cb3cd3dcd", "john", "Tue Apr 08 12:58:04 2003"]}

  subject  { ReleasePresenter.new(data) }

  it "should capitalize the project name" do
    subject.get_release_project.should == "PROJECT_NAME" 
  end

  it "should return the first eight characters of the release SHA" do
    subject.get_release_sha.should == "d34ac3cb"
  end

  it "should return the release date" do
    subject.get_release_date.should == "Tuesday,  8 April 2003"
  end

  it "should return the reelase time" do
    subject.get_release_time.should == "12:58:04"
  end

  it "should return the release deployer" do
    subject.get_release_deployer.should == "-by john"
  end

  it "should return the Github base url" do
    subject.get_release_github_url.should match("#{subject.get_release_project}"+"/commit/d34ac3cb3cd3dcd")
  end

end