require 'spec_helper'

describe Harvest::Credentials do
  describe "#valid?" do
    it "should return true if domain is filled out" do
      Harvest::Credentials.new("some-domain").should be_valid
    end
    
    it "should return false if domain is nil" do
      Harvest::Credentials.new(nil).should_not be_valid
    end
  end
  
  describe "#basic_auth" do
    it "should not have base64" do
      Harvest::Credentials.new("some-domain").basic_auth.should == nil
    end
  end

  describe "#headers" do
    it "should return empty hash" do
      Harvest::Credentials.new("some-domain").headers.should == {}
    end
  end

  describe "#build_path(path)" do
    it "should return path back" do
      Harvest::Credentials.new("some-domain").build_path('/path').should == '/path'
    end
  end
end

describe Harvest::PasswordCredentials do
  describe "#valid?" do
    it "should return true if domain, username, and password is filled out" do
      Harvest::PasswordCredentials.new("some-domain", "username", "password").should be_valid
    end
    
    it "should return false if either domain, username, or password is nil" do
      Harvest::PasswordCredentials.new("some-domain", "username", nil).should_not be_valid
      Harvest::PasswordCredentials.new("some-domain", nil, "password").should_not be_valid
      Harvest::PasswordCredentials.new(nil, "username", "password").should_not be_valid
      Harvest::PasswordCredentials.new(nil, nil, nil).should_not be_valid
    end
  end
  
  describe "#basic_auth" do
    it "should base64 encode the credentials" do
      Harvest::PasswordCredentials.new("some-domain", "username", "password").basic_auth.should == "dXNlcm5hbWU6cGFzc3dvcmQ="
    end
  end

  describe "#headers" do
    it "should Authorization with basic auth" do
      credentials = Harvest::PasswordCredentials.new("some-domain", "username", "password")
      headers = credentials.headers
      basic_auth = credentials.basic_auth
      headers['Authorization'].should_not be_nil
      headers['Authorization'].should == "Basic #{basic_auth}"
    end
  end
end

describe Harvest::TokenCredentials do
  describe "#valid?" do
    it "should return true if domain, and token is filled out" do
      Harvest::TokenCredentials.new("some-domain", "access_token").should be_valid
    end
    
    it "should return false if either domain, or token is nil" do
      Harvest::TokenCredentials.new("some-domain", nil).should_not be_valid
      Harvest::TokenCredentials.new(nil, "access_token").should_not be_valid
      Harvest::TokenCredentials.new(nil, nil).should_not be_valid
    end
  end
  
  describe "#build_path(path)" do
    it "should append path with access_token" do
      Harvest::TokenCredentials.new("some-domain", "token").build_path('/path').should == "/path?access_token=token"
    end
  end
end