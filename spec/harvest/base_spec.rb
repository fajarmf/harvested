require 'spec_helper'

describe Harvest::Base do
  describe "username/password errors" do
    it "should raise error if missing a credential" do
      lambda { Harvest::Base.new(nil) }.should raise_error(Harvest::InvalidCredentials)
      lambda do
        credential = double('credential')
        credential.stub(valid?: false)
        Harvest::Base.new(credential)
      end.should raise_error(Harvest::InvalidCredentials)
    end
  end
end
