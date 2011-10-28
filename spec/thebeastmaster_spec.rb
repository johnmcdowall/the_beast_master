require 'spec_helper'

describe "The Beast Master" do
  include Rack::Test::Methods

  describe "/" do
    describe "Without Authentication" do
      it "should respond to /" do
        get '/'
        last_response.should be_ok
      end
    end

    describe "With Authentication" do
      it "should respond to /" do
        pending
        get '/'
        last_response.should_not be_ok
      end
    end
  end

  describe "/mark_release" do

    describe "validation" do
      describe "length"
        after do
          last_response.body.should == "Environments, projects must be less than 100 chars long, sha less than or equal to 40, and whom less than 30."
        end

        it "should halt with a 500 if the environment passed is longer than 100 characers" do
          post '/mark_release', {:env=>"production"*11, :project=>"testproj", :whom=>"john", :sha=>"af34123e3e"}     
        end

        it "should halt with a 500 if the project passed is longer than 100 characers" do
          post '/mark_release', {:env=>"production", :project=>"testprojnt"*11, :whom=>"john", :sha=>"af34123e3e"}
        end

        it "should halt with a 500 if the sha passed is longer than 40 characers" do
          post '/mark_release', {:env=>"production", :project=>"testprojnt", :whom=>"john", :sha=>"X5f96caf1f6d32453b76bcfd31fa4f8ca73a0ed91"}
        end

        it "should halt with a 500 if the whom passed is longer than 30 characers" do
          post '/mark_release', {:env=>"production", :project=>"testprojnt", :whom=>"john"*10, :sha=>"5f96caf1f6d32453b76bcfd31fa4f8ca73a0ed91"}      
        end
      end

      describe "spaces" do
        after do
          last_response.body.should == "No spaces allowed in environments, projects, whom or sha."
        end

        it "should halt with a 500 if the environment passed contains a space" do
          post '/mark_release', {:env=>"product ion", :project=>"testproj", :whom=>"john", :sha=>"af34123e3e"}     
        end

        it "should halt with a 500 if the project passed contains a space" do
          post '/mark_release', {:env=>"production", :project=>"testproj nt", :whom=>"john", :sha=>"af34123e3e"}
        end

        it "should halt with a 500 if the sha passed contains a space" do
          post '/mark_release', {:env=>"production", :project=>"testprojnt", :whom=>"john", :sha=>" f96caf1f6d32453b76bcfd31fa4f8ca73a0ed91"}
        end

        it "should halt with a 500 if the whom passed contains a space" do
          post '/mark_release', {:env=>"production", :project=>"testprojnt", :whom=>"joh n", :sha=>"5f96caf1f6d32453b76bcfd31fa4f8ca73a0ed91"}      
        end
      end
    end

    describe "Without Authentication" do
      it "should use ReleaseDb when posted to /mark_release" do
        ReleaseDb.expects(:mark_release_for).once
        post '/mark_release', {:env=>"production", :project=>"testproj", :whom=>"john", :sha=>"af34123e3e"}
        last_response.body.should == "Release marked."
      end
    end

    describe "With Authentication" do
      it "should use ReleaseDb when posted to /mark_release" do
        pending
        ReleaseDb.expects(:mark_release_for).once
        post '/mark_release', {:env=>"production", :project=>"testproj", :whom=>"john", :sha=>"af34123e3e"}
        last_response.should_not be_ok
      end
    end
end