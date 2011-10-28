require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/release_db'

describe ReleaseDb do

  describe "Paths" do
    it "should be able to access the release_db_path from the Config" do
      subject.release_db_path.should_not be_nil
    end
    
    it "should be possible to get an environment's path in the release_db" do
      subject.get_environment_path("staging").should match("spec/release_db/staging$")
    end
  end

  describe "Environments" do

    before do
      subject.create_environment "staging"
    end

    it "should return an environment if the release_db dir is contains one" do
      subject.list_environments.should == ["staging"] 
    end

    it "should return a list of the environments it release_db has more than one environment" do
      subject.create_environment "production"
      subject.list_environments.should == ["production", "staging"]
    end

    it "should be possible to check the existense of an environment" do    
      subject.environment_exists?("staging").should be_true
    end

    it "should be possible to create an environment in the release_db" do
      should_create_a_directory_in_release_db "staging"
    end
      
    it "should be possible to get the projects in an environment" do
      subject.create_project_in "staging", "thebestprojectever"
      subject.get_projects_in("staging").should include("thebestprojectever")
    end
  end

  describe "Projects" do

    describe "When an environment hasn't been created" do
      it "should raise an Exception stating the environment must exist first when no environment exists" do
        expect{ subject.create_project_in("staging", "thebestprojectever")}.to raise_error(Exception, "Environment staging does not yet exist.")
      end
    end

    describe "When an environment exists" do
      before { subject.create_environment "staging" } 

      it "should be possible to get the path of a project in an environment" do
        p subject.get_project_path_in_environment( "staging", "thebestprojectever" )
        subject.get_project_path_in_environment( "staging", "thebestprojectever" ).should match("spec/release_db/staging/thebestprojectever$")
      end

      it "should be possible to check a project exists in an environment" do
        subject.create_project_in "staging", "thebestprojectever"
        subject.project_exists_in_environment?("staging", "thebestprojectever").should be_true
      end

      it "should be possible to create a project in an environment" do
        subject.create_project_in "staging", "thebestprojectever"
        subject.get_projects_in("staging").should include("thebestprojectever")
      end

      it "should be possible to list all projects in an environment" do
        subject.create_project_in "staging", "thebestprojectever"
        subject.create_project_in "staging", "thebestprojecteverofalltime"
        subject.get_projects_in("staging").should == ["thebestprojectever", "thebestprojecteverofalltime"]
      end
    end
  end

  describe "Deployers" do   
    before do
     subject.create_environment "staging" 
     subject.create_project_in  "staging", "thebestprojectever"
     subject.create_deployer_in "staging", "thebestprojectever", "john"
    end

    it "should be possible to get the path for a deployer in a project within an environment" do     
      subject.get_deployer_path( "staging", "thebestprojectever", "john" ).should match("spec/release_db/staging/thebestprojectever/john$")
    end

    it "should be possible to create a deployer within a project and enviroments" do
      subject.deployer_exists_in("staging", "thebestprojectever", "john").should be_true
    end
  end

  describe "A Release" do
    it "should be possible to create a Release with a SHA1 within a deployer, for a project in an environment" do
      subject.mark_release_for "staging", "thebestprojectever", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae18"
      subject.release_exists_for?( "staging", "thebestprojectever", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae18" ).should be_true
    end

    it "should be possible to get the latest release for a project in an environment" do
      subject.mark_release_for "staging", "thebestprojectever", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae18"
      subject.get_latest_release_for( "staging", "thebestprojectever" ).should include("d1b6fe8b876fdede200577edcb1065ab8b5aae18", "john")
    end
  end

  describe "All releases" do
    it "should be possible to get all releases for an environment by project" do
      subject.mark_release_for "staging", "thebestprojectever", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae18"
      subject.mark_release_for "staging", "thebestprojectever2", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae19"
      subject.mark_release_for "staging", "thebestprojectever3", "john", "d1b6fe8b876fdede200577edcb1065ab8b5aae20"

      subject.get_all_latest_releases_for( "staging" ).flatten.should  include("thebestprojectever", "d1b6fe8b876fdede200577edcb1065ab8b5aae18",  
                                                                       "john",
                                                                       "thebestprojectever2", "d1b6fe8b876fdede200577edcb1065ab8b5aae19",
                                                                       "thebestprojectever3", "d1b6fe8b876fdede200577edcb1065ab8b5aae20")
    end
  end

end