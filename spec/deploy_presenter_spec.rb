require 'spec_helper'

describe DeployPresenter do

  subject { DeployPresenter.new }

  describe "#format_environment" do
    it "should capitalize the environment name" do
      subject.format_environment("production").should == "Production"
    end
  end

  describe "#get_releases_for_environment" do
    it "should make a call to ReleaseDb to get the latest releases" do
      ReleaseDb.expects(:get_all_latest_releases_for).once
      subject.get_releases_for_environment("production")
    end
  end

end